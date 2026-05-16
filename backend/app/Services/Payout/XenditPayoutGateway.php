<?php

namespace App\Services\Payout;

use Illuminate\Support\Facades\Http;

/**
 * Simple Xendit payout adapter scaffold.
 *
 * Notes:
 * - Requires XENDIT_API_KEY in environment to be useful.
 * - The exact endpoint/payload may need adjustment to match the provider API.
 */
class XenditPayoutGateway implements PayoutGatewayInterface
{
  protected string $apiKey;
  protected string $baseUrl;

  public function __construct(string $apiKey, string $baseUrl = 'https://api.xendit.co')
  {
    $this->apiKey = $apiKey;
    $this->baseUrl = rtrim($baseUrl, '/');
  }

  public function send(array $payload): array
  {
    // payload: provider_id, amount, payment_ids, force_fail
    if (!empty($payload['force_fail'])) {
      return [
        'success' => false,
        'error' => 'forced-failure',
        'meta' => ['mock' => 1]
      ];
    }

    // Basic disbursement example - adapt to real provider API requirements
    try {
      $res = Http::withBasicAuth($this->apiKey, '')
        ->timeout(15)
        ->post($this->baseUrl . '/v2/disbursements', [
          // map fields as required by provider
          'external_id' => 'payout_' . time() . '_' . rand(1000, 9999),
          'bank_code' => $payload['bank_code'] ?? 'MANDIRI',
          'account_holder_name' => $payload['account_name'] ?? 'Provider',
          'account_number' => $payload['account_number'] ?? '0000000000',
          'amount' => (int) round($payload['amount'] ?? 0),
          'description' => $payload['description'] ?? 'Provider payout',
        ]);

      if ($res->successful()) {
        $body = $res->json();
        return [
          'success' => true,
          'transaction_reference' => $body['id'] ?? ($body['reference'] ?? null),
          'meta' => $body,
        ];
      }

      return [
        'success' => false,
        'error' => $res->body(),
        'meta' => $res->json() ?? null,
      ];
    } catch (\Throwable $e) {
      return [
        'success' => false,
        'error' => $e->getMessage(),
      ];
    }
  }
}

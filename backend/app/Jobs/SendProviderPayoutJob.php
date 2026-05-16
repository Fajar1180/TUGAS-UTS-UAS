<?php

namespace App\Jobs;

use App\Models\ProviderPayout;
use App\Services\Payout\ProviderPayoutService;
use App\Services\Payout\PayoutGatewayInterface;
use App\Services\Payout\MockPayoutGateway;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Bus\Dispatchable;
use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Queue\SerializesModels;

class SendProviderPayoutJob implements ShouldQueue
{
  use Dispatchable, InteractsWithQueue, Queueable, SerializesModels;

  public int $payoutId;
  public array $options;

  public function __construct(int $payoutId, array $options = [])
  {
    $this->payoutId = $payoutId;
    $this->options = $options;
  }

  public function handle()
  {
    $p = ProviderPayout::find($this->payoutId);
    if (!$p) return;
    if ($p->status !== 'PENDING') return;

    // Resolve gateway from container if bound, otherwise fallback to Mock
    if (app()->bound(PayoutGatewayInterface::class)) {
      $gateway = app(PayoutGatewayInterface::class);
    } else {
      $gateway = new MockPayoutGateway();
    }

    $service = new ProviderPayoutService($gateway);
    $service->process($p, $this->options);
  }
}

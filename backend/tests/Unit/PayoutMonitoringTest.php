<?php

namespace Tests\Unit;

use Tests\TestCase;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Notification;
use Illuminate\Support\Facades\Artisan;
use Illuminate\Support\Facades\Config;
use Illuminate\Support\Facades\DB;
use App\Services\Payout\XenditPayoutGateway;
use App\Models\PayoutProviderResponse;
use App\Notifications\PayoutFailed;

class PayoutMonitoringTest extends TestCase
{
    public function test_payout_response_persisted_and_notification_sent_on_failure()
    {
        Notification::fake();
        // set alert email for gateway to pick up
        putenv('PAYOUT_ALERT_EMAIL=ops@example.com');

        Http::fake([
            '*' => Http::response(['id' => 'tx_123', 'status' => 'FAILED', 'error' => 'insufficient_funds'], 500),
        ]);

        // Ensure DB migrated
        Artisan::call('migrate', ['--database' => Config::get('database.default'), '--path' => 'database/migrations', '--force' => true]);

        $gateway = new XenditPayoutGateway('sk_test_xnd_example_key', 'https://api.xendit.com');

        $res = $gateway->send(['amount' => 10000, 'bank_code' => 'BCA', 'account_number' => '000111222']);

        $this->assertIsArray($res);
        $this->assertFalse($res['success']);

        // DB should have a record
        $this->assertDatabaseHas('payout_provider_responses', ['provider' => 'xendit']);

        // Notification should be sent to anonymous notifiable (mail route)
        Notification::assertSentTo(new \Illuminate\Notifications\AnonymousNotifiable, PayoutFailed::class);
    }
}

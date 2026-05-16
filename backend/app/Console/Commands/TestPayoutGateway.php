<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use App\Services\Payout\PayoutGatewayInterface;

class TestPayoutGateway extends Command
{
  protected $signature = 'payouts:test-gateway {amount=10000} {--to=} {--force : Allow running in production}';
  protected $description = 'Kirim percobaan payout melalui gateway terkonfigurasi (sandbox/mock)';

  public function handle()
  {
    if (app()->environment('production') && !$this->option('force')) {
      $this->error('Tidak boleh menjalankan command ini di production tanpa --force');
      return 1;
    }

    $amount = (int) $this->argument('amount');
    $to = $this->option('to') ?: '0000000000';

    $gateway = app(PayoutGatewayInterface::class);

    $this->info(sprintf('Menggunakan gateway: %s', get_class($gateway)));

    $payload = [
      'account_number' => $to,
      'account_name' => 'Test Payout',
      'bank_code' => 'MANDIRI',
      'amount' => $amount,
      'description' => 'Test payout from artisan command',
      'force_fail' => false,
    ];

    $this->info('Mengirim request ke gateway...');
    $res = $gateway->send($payload);

    $this->info('Hasil:');
    $this->line(json_encode($res, JSON_PRETTY_PRINT | JSON_UNESCAPED_SLASHES));

    return 0;
  }
}

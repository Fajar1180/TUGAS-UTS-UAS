<?php

namespace App\Providers;

use Illuminate\Support\ServiceProvider;
use App\Services\Payout\PayoutGatewayInterface;
use App\Services\Payout\XenditPayoutGateway;
use App\Services\Payout\MockPayoutGateway;

class AppServiceProvider extends ServiceProvider
{
    /**
     * Register any application services.
     */
    public function register(): void
    {
        // Bind payout gateway implementation based on environment
        $this->app->singleton(PayoutGatewayInterface::class, function ($app) {
            $xenditKey = env('XENDIT_API_KEY');
            if (!empty($xenditKey)) {
                return new XenditPayoutGateway($xenditKey, env('XENDIT_BASE_URL', 'https://api.xendit.co'));
            }

            // Fallback to mock gateway for local/dev
            return new MockPayoutGateway();
        });
    }

    /**
     * Bootstrap any application services.
     */
    public function boot(): void
    {
        //
    }
}

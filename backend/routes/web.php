<?php

use Illuminate\Support\Facades\Route;

Route::get('/', function () {
    return view('welcome');
});

// Admin/Treasurer UI
use App\Http\Controllers\Admin\TreasurerWebController;

Route::middleware(['auth'])->group(function () {
    Route::get('/admin/treasurer/payments', [TreasurerWebController::class, 'index'])->name('admin.treasurer.report');
});

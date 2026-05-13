<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class Payment extends Model
{
  use HasFactory;

  protected $fillable = [
    'order_id',
    'payment_type',
    'amount',
    'status',
    'provider',
    'external_payment_id',
    'paid_at',
  ];

  protected $casts = [
    'amount' => 'integer',
    'paid_at' => 'datetime',
  ];

  public function order(): BelongsTo
  {
    return $this->belongsTo(Order::class);
  }
}

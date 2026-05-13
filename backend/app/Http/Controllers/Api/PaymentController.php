<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Payment;
use App\Models\Order;
use App\Models\NotificationLog;
use Illuminate\Http\Request;

class PaymentController extends Controller
{
  /**
   * Get payment untuk order
   */
  public function getPayments($orderId)
  {
    $payments = Payment::where('order_id', $orderId)->get();

    return response()->json([
      'data' => $payments,
    ], 200);
  }

  /**
   * Generate QRIS untuk payment (simulasi)
   * Di production, ini akan memanggil payment gateway seperti Midtrans/Xendit
   */
  public function generateQRIS(Request $request, $paymentId)
  {
    $payment = Payment::find($paymentId);

    if (!$payment) {
      return response()->json([
        'message' => 'payment not found',
      ], 404);
    }

    // Simulasi generate QRIS
    $qrisData = [
      'payment_id' => $payment->id,
      'amount' => $payment->amount,
      'payment_type' => $payment->payment_type,
      'qris_code' => 'https://api.qris.example.com/qr?id=' . $payment->id,
      'qris_image' => 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNk+M9QDwADhgGAWjR9awAAAABJRU5ErkJggg==',
    ];

    return response()->json([
      'data' => $qrisData,
    ], 200);
  }

  /**
   * Webhook callback dari payment gateway
   * Endpoint ini menerima notifikasi pembayaran dari Midtrans/Xendit
   */
  public function webhookPaymentCallback(Request $request)
  {
    $data = $request->all();

    // TODO: Verifikasi signature dari payment gateway

    $paymentId = $data['payment_id'] ?? null;
    $externalPaymentId = $data['transaction_id'] ?? null;
    $status = $data['status'] ?? null; // 'success', 'pending', 'failed'

    if (!$paymentId) {
      return response()->json(['message' => 'invalid payload'], 400);
    }

    $payment = Payment::find($paymentId);

    if (!$payment) {
      return response()->json(['message' => 'payment not found'], 404);
    }

    // Map status dari gateway ke status lokal
    $statusMap = [
      'success' => 'PAID',
      'pending' => 'PENDING',
      'failed' => 'FAILED',
    ];

    $newStatus = $statusMap[$status] ?? 'PENDING';

    $payment->update([
      'status' => $newStatus,
      'external_payment_id' => $externalPaymentId,
      'paid_at' => ($newStatus === 'PAID') ? now() : null,
    ]);

    // Jika payment berhasil, update order status
    if ($newStatus === 'PAID') {
      $order = $payment->order;

      // Jika DP sudah dibayar dan order masih CREATED, ubah ke ACCEPTED (opsional)
      // Atau biarkan provider menerima order secara manual

      // Log notifikasi
      NotificationLog::create([
        'event_name' => 'payment_' . strtolower($payment->payment_type) . '_paid',
        'channel' => 'WA', // Akan dihandle oleh n8n
        'payload_json' => json_encode([
          'order_id' => $order->id,
          'payment_type' => $payment->payment_type,
          'amount' => $payment->amount,
        ]),
        'status' => 'SENT',
        'sent_at' => now(),
      ]);

      // Jika FINAL payment sudah dibayar, tutup order
      if ($payment->payment_type === 'FINAL') {
        $order->update(['status' => 'CLOSED']);
      }
    }

    return response()->json(['message' => 'payment processed'], 200);
  }

  /**
   * Get payment status
   */
  public function getPaymentStatus($paymentId)
  {
    $payment = Payment::find($paymentId);

    if (!$payment) {
      return response()->json([
        'message' => 'payment not found',
      ], 404);
    }

    return response()->json([
      'data' => $payment,
    ], 200);
  }
}

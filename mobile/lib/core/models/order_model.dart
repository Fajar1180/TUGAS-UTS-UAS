class OrderData {
  final int id;
  final String orderCode;
  final String status;
  final int estimatedPrice;
  final int? finalPrice;
  final String address;
  final String? notes;
  final String scheduleAt;
  final List<PaymentData> payments;

  OrderData({
    required this.id,
    required this.orderCode,
    required this.status,
    required this.estimatedPrice,
    this.finalPrice,
    required this.address,
    this.notes,
    required this.scheduleAt,
    required this.payments,
  });

  factory OrderData.fromJson(Map<String, dynamic> json) {
    return OrderData(
      id: json['id'] ?? 0,
      orderCode: json['order_code'] ?? '',
      status: json['status'] ?? 'CREATED',
      estimatedPrice: json['estimated_price'] ?? 0,
      finalPrice: json['final_price'],
      address: json['address'] ?? '',
      notes: json['notes'],
      scheduleAt: json['schedule_at'] ?? '',
      payments: (json['payments'] as List?)
              ?.map((item) => PaymentData.fromJson(item))
              .toList() ??
          [],
    );
  }
}

class PaymentData {
  final int id;
  final String paymentType;
  final int amount;
  final String status;
  final String? externalPaymentId;
  final String? paidAt;

  PaymentData({
    required this.id,
    required this.paymentType,
    required this.amount,
    required this.status,
    this.externalPaymentId,
    this.paidAt,
  });

  factory PaymentData.fromJson(Map<String, dynamic> json) {
    return PaymentData(
      id: json['id'] ?? 0,
      paymentType: json['payment_type'] ?? '',
      amount: json['amount'] ?? 0,
      status: json['status'] ?? 'UNPAID',
      externalPaymentId: json['external_payment_id'],
      paidAt: json['paid_at'],
    );
  }
}

class OrdersResponse {
  final List<OrderData> data;

  OrdersResponse({required this.data});

  factory OrdersResponse.fromJson(Map<String, dynamic> json) {
    return OrdersResponse(
      data: (json['data'] as List?)
              ?.map((item) => OrderData.fromJson(item))
              .toList() ??
          [],
    );
  }
}

class CreateOrderRequest {
  final int providerId;
  final int categoryId;
  final int? providerServiceId;
  final String scheduleAt;
  final String address;
  final String? notes;
  final int estimatedPrice;

  CreateOrderRequest({
    required this.providerId,
    required this.categoryId,
    this.providerServiceId,
    required this.scheduleAt,
    required this.address,
    this.notes,
    required this.estimatedPrice,
  });

  Map<String, dynamic> toJson() {
    return {
      'provider_id': providerId,
      'category_id': categoryId,
      'provider_service_id': providerServiceId,
      'schedule_at': scheduleAt,
      'address': address,
      'notes': notes,
      'estimated_price': estimatedPrice,
    };
  }
}

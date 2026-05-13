import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'order_providers.dart';

class OrderDetailPage extends ConsumerWidget {
  final int orderId;

  const OrderDetailPage({
    super.key,
    required this.orderId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderAsync = ref.watch(orderDetailProvider(orderId));

    return Scaffold(
      appBar: AppBar(title: const Text('Detail Order')),
      body: orderAsync.when(
        loading: () =>
            const Center(child: CircularProgressIndicator()),
        error: (err, st) => Center(
          child: Text('Error: $err'),
        ),
        data: (order) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Status card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Status Order',
                          style:
                              Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: _getStatusColor(order.status)
                                .withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            order.status,
                            style: TextStyle(
                              color: _getStatusColor(order.status),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Order info
                _buildSection(
                  context,
                  'Informasi Order',
                  [
                    _buildInfo('Kode Order', order.orderCode),
                    _buildInfo('Alamat', order.address),
                    _buildInfo(
                      'Jadwal',
                      order.scheduleAt != null
                          ? DateFormat('dd MMM yyyy HH:mm')
                              .format(DateTime.parse(order.scheduleAt!))
                          : '-',
                    ),
                    if (order.notes != null && order.notes!.isNotEmpty)
                      _buildInfo('Catatan', order.notes!),
                  ],
                ),
                const SizedBox(height: 16),

                // Pricing
                _buildSection(
                  context,
                  'Pricing',
                  [
                    _buildInfo(
                      'Harga Estimasi',
                      'Rp${order.estimatedPrice ?? 0}',
                    ),
                    if (order.finalPrice != null)
                      _buildInfo(
                        'Harga Final',
                        'Rp${order.finalPrice}',
                      ),
                  ],
                ),
                const SizedBox(height: 16),

                // Payments
                if (order.payments.isNotEmpty)
                  _buildSection(
                    context,
                    'Pembayaran',
                    [
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: order.payments.length,
                        itemBuilder: (context, index) {
                          final payment = order.payments[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(payment.paymentType),
                                      Text(
                                        'Rp${payment.amount}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Status: ${payment.status}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: payment.status == 'COMPLETED'
                                              ? Colors.green
                                              : Colors.orange,
                                        ),
                                      ),
                                      if (payment.paidAt != null)
                                        Text(
                                          DateFormat('dd MMM HH:mm')
                                              .format(DateTime.parse(
                                                  payment.paidAt!)),
                                          style:
                                              const TextStyle(fontSize: 12),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSection(
    BuildContext context,
    String title,
    List<Widget> children,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: children,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'CREATED':
        return Colors.blue;
      case 'ACCEPTED':
        return Colors.orange;
      case 'IN_PROGRESS':
        return Colors.purple;
      case 'COMPLETED':
        return Colors.green;
      case 'CANCELLED':
        return Colors.red;
      case 'CLOSED':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }
}

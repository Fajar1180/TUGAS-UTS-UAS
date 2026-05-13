import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/models/order_model.dart';
import '../auth/auth_controller.dart';
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
                const SizedBox(height: 20),

                // Provider action buttons
                _buildProviderActions(context, ref, order),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProviderActions(
    BuildContext context,
    WidgetRef ref,
    OrderData order,
  ) {
    final authState = ref.watch(authControllerProvider);
    final actionState = ref.watch(orderActionControllerProvider);

    // Only show for providers
    if (authState.userRole != 'PROVIDER') {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Tindakan Provider',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        if (order.status == 'CREATED') ...[
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            onPressed: actionState.isLoading
                ? null
                : () async {
                    final success = await ref
                        .read(orderActionControllerProvider.notifier)
                        .respondToOrder(order.id, 'accept');
                    if (success && context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Order diterima!')),
                      );
                      ref.refresh(orderDetailProvider(order.id));
                    } else if (!success && context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(actionState.errorMessage ?? 'Error'),
                        ),
                      );
                    }
                  },
            child: actionState.isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text(
                    'Terima Order',
                    style: TextStyle(color: Colors.white),
                  ),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            onPressed: actionState.isLoading
                ? null
                : () async {
                    final success = await ref
                        .read(orderActionControllerProvider.notifier)
                        .respondToOrder(order.id, 'reject');
                    if (success && context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Order ditolak')),
                      );
                      ref.refresh(orderDetailProvider(order.id));
                    }
                  },
            child: const Text(
              'Tolak Order',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ] else if (order.status == 'ACCEPTED') ...[
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            onPressed: actionState.isLoading
                ? null
                : () async {
                    final success = await ref
                        .read(orderActionControllerProvider.notifier)
                        .startWork(order.id);
                    if (success && context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Pekerjaan dimulai')),
                      );
                      ref.refresh(orderDetailProvider(order.id));
                    }
                  },
            child: const Text(
              'Mulai Pekerjaan',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ] else if (order.status == 'IN_PROGRESS') ...[
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            onPressed: actionState.isLoading
                ? null
                : () async {
                    // Show dialog untuk input final price
                    final controller = TextEditingController(
                      text: (order.estimatedPrice ?? 0).toString(),
                    );
                    
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Harga Final'),
                        content: TextField(
                          controller: controller,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Masukkan harga final (Rp)',
                            hintText: '0',
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx),
                            child: const Text('Batal'),
                          ),
                          TextButton(
                            onPressed: () async {
                              final finalPrice = int.tryParse(controller.text) ?? 0;
                              if (finalPrice <= 0) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Harga tidak valid')),
                                );
                                return;
                              }
                              
                              final success = await ref
                                  .read(orderActionControllerProvider.notifier)
                                  .completeOrder(order.id, finalPrice);
                              
                              if (context.mounted) {
                                Navigator.pop(ctx);
                                if (success) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Pekerjaan selesai')),
                                  );
                                  ref.refresh(orderDetailProvider(order.id));
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(actionState.errorMessage ?? 'Error'),
                                    ),
                                  );
                                }
                              }
                            },
                            child: const Text('Selesai'),
                          ),
                        ],
                      ),
                    );
                  },
            child: const Text(
              'Selesaikan Pekerjaan',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ],
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

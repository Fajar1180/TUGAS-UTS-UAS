import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services/api_service.dart';
import '../../core/models/order_model.dart';

// My orders provider
final myOrdersProvider = FutureProvider<List<OrderData>>((ref) async {
  final apiService = ref.read(apiServiceProvider);
  final response = await apiService.getMyOrders();
  return response.data;
});

// Order detail provider
final orderDetailProvider = FutureProvider.family<OrderData, int>((ref, orderId) async {
  final apiService = ref.read(apiServiceProvider);
  return await apiService.getOrderDetail(orderId);
});

// Create order controller
final createOrderControllerProvider = StateNotifierProvider<CreateOrderController, CreateOrderState>((ref) {
  return CreateOrderController(ref);
});

class CreateOrderState {
  final bool isLoading;
  final String? errorMessage;
  final OrderData? createdOrder;

  const CreateOrderState({
    this.isLoading = false,
    this.errorMessage,
    this.createdOrder,
  });

  CreateOrderState copyWith({
    bool? isLoading,
    String? errorMessage,
    OrderData? createdOrder,
  }) {
    return CreateOrderState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      createdOrder: createdOrder ?? this.createdOrder,
    );
  }
}

class CreateOrderController extends StateNotifier<CreateOrderState> {
  CreateOrderController(this._ref) : super(const CreateOrderState());

  final Ref _ref;

  Future<bool> createOrder(CreateOrderRequest request) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final apiService = _ref.read(apiServiceProvider);
      final order = await apiService.createOrder(request);
      state = state.copyWith(
        isLoading: false,
        createdOrder: order,
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to create order: $e',
      );
      return false;
    }
  }

  void reset() {
    state = const CreateOrderState();
  }
}

import 'package:flutter/material.dart';
import '../data/services/order_service.dart';
import '../data/model/order_model.dart';

class OrderProvider extends ChangeNotifier {
  final OrderService _service = OrderService();
  String _paymentMethod = "Cash";
  String get paymentMethod => _paymentMethod;

  bool loading = false;
  String? error;
  List<OrderModel> orders = [];

  bool _loadedOnce = false;

  void setPaymentMethod(String method) {
    _paymentMethod = method;
    notifyListeners();
  }

  /// 🔵 Fetch orders (history)
  Future<void> fetchMyOrders({bool force = false}) async {
    if (_loadedOnce && !force) return;

    loading = true;
    error = null;
    notifyListeners();

    try {
      orders = await _service.getMyOrders();
      _loadedOnce = true;
    } catch (e) {
      error = e.toString();
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  /// 🟢 Add new order immediately (NO REFRESH)
  void addOrder(OrderModel order) {
    orders.insert(0, order);
    notifyListeners();
  }

  /// 🧹 Clear cache if needed
  void clearOrders() {
    orders.clear();
    _loadedOnce = false;
    notifyListeners();
  }
OrderModel createLocalPendingOrder({
  required double totalCost,
  required String paymentMethod,
  required bool isPickup,
}) {
  final tempId = DateTime.now().millisecondsSinceEpoch; // temp unique id

  return OrderModel(
    id: tempId,
    totalCost: totalCost,
    status: "Pending",
    createdAt: DateTime.now(),
    items: const [],
  );
}

/// Replace temp order with real order from API (optional)
void replaceTempOrder(OrderModel temp, OrderModel real) {
  final idx = orders.indexWhere((o) => o.id == temp.id);
  if (idx != -1) {
    orders[idx] = real;
  } else {
    orders.insert(0, real);
  }
  notifyListeners();
}


}
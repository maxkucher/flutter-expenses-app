import 'package:flutter/foundation.dart';
import 'package:tasks_app/models/cart_item.dart';

import 'order_item.dart';

class OrdersProvider with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  void addOrder(List<CartItem> cartProducts, double total) {
    _orders.insert(
        0,
        OrderItem(
            id: DateTime.now().toString(),
            amount: total,
            products: cartProducts,
            date: DateTime.now()));
    notifyListeners();
  }
}

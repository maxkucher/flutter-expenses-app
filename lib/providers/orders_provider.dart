import 'package:flutter/foundation.dart';
import 'package:tasks_app/models/cart_item.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'order_item.dart';

class OrdersProvider with ChangeNotifier {
  static const url = 'https://turorial-12beb.firebaseio.com/orders.json';

  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  void addOrder(List<CartItem> cartProducts, double total) async {
    final timestamp = DateTime.now();
    final response = await http.post(url,
        body: json.encode({
          'amount': total,
          'dateTime': timestamp.toIso8601String(),
          'products': cartProducts.map((cp) => {
            'id':cp.id,
            'title':cp.title,
            'quantity':cp.quantity,
            'price':cp.price
          }).toList()
        }));
    _orders.insert(
        0,
        OrderItem(
            id: json.decode(response.body)['name'],
            amount: total,
            products: cartProducts,
            date: DateTime.now()));
    notifyListeners();
  }
}

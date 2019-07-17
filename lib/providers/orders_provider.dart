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

  Future<void> fetchAndSetOrder() async {
    final res = await http.get(url);

    final List<OrderItem> loadedOrders = [];
    if(res.body!=null){
      final extractedResponseBody = json.decode(res.body) as Map<String, dynamic>;
      extractedResponseBody.forEach((orderId, orderData) {
        loadedOrders.add(OrderItem(
            id: orderId,
            amount: orderData['amount'],
            date: DateTime.parse(orderData['dateTime']),
            products: (orderData['products'] as List<dynamic>).map((item) =>
                CartItem(
                    id: item['id'],
                    title: item['title'],
                    quantity: item['quantity'],
                    price: item['price'])).toList()
        ));
      });
      _orders = loadedOrders;
      notifyListeners();
    }


  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final timestamp = DateTime.now();
    final response = await http.post(url,
        body: json.encode({
          'amount': total,
          'dateTime': timestamp.toIso8601String(),
          'products': cartProducts
              .map((cp) => {
                    'id': cp.id,
                    'title': cp.title,
                    'quantity': cp.quantity,
                    'price': cp.price
                  })
              .toList()
        }));
    print(json.encode(response));
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

import 'package:flutter/widgets.dart';
import 'package:tasks_app/models/cart_item.dart';

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => {..._items};

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach(
        (_, CartItem value) => {total += value.price * value.quantity});
    return total;
  }

  void addItem(String productId, double price, String title) {
    if (_items.containsKey(productId)) {
      _items.update(
          productId,
          (prevCardItem) => CartItem(
              id: prevCardItem.id,
              price: prevCardItem.price,
              title: prevCardItem.title,
              quantity: prevCardItem.quantity + 1));
    } else {
      _items.putIfAbsent(
          productId,
          () => CartItem(
              id: DateTime.now().toString(),
              quantity: 1,
              title: title,
              price: price));
    }

    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  clearCart() {
    _items = {};
    notifyListeners();
  }
}

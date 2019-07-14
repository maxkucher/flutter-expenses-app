import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tasks_app/providers/product.dart';
import 'package:http/http.dart' as http;

class ProductsProvider with ChangeNotifier {
  static const backendUrl =
      'https://turorial-12beb.firebaseio.com/products.json';

  List<Product> _items = [
    Product(
        id: 'p1',
        title: 'Black shit',
        description: 'A red shit - it is pretty red',
        price: 29.99,
        imageUrl:
            'https://www.celio.com/medias/sys_master/productMedias/productMediasImport/h0c/h18/9509185749022/product-media-import-1073434-1-weared.jpg?frz-v=1575'),
    Product(
        id: 'p2',
        title: 'Red shit',
        description: 'A red shit - it is pretty red',
        price: 29.99,
        imageUrl:
            'https://target.scene7.com/is/image/Target/GUEST_9413e897-f5a4-44ec-9989-d3a79f5351f3?wid=488&hei=488&fmt=pjpeg')
  ];

  Future<void> addProduct(Product product) async {
    return http
        .post(backendUrl,
            body: json.encode({
              'title': product.title,
              'description': product.description,
              'imageUrl': product.imageUrl,
              'price': product.price,
              'isFavourite': product.isFavourite
            }))
        .then((response) {
      final newProduct = Product(
          id: json.decode(response.body)['name'],
          title: product.title,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl);
      _items.add(newProduct);
      notifyListeners();
    });
  }

  void updateProduct(Product product) {
    final prodIndex = findProductIndex(product.id);
    if (prodIndex >= 0) {
      _items[prodIndex] = product;
    }
    notifyListeners();
  }

  void deleteProduct(String productId) {
    _items.removeWhere((product) => product.id == productId);
    notifyListeners();
  }

  int findProductIndex(String productId) {
    return _items.indexWhere((prod) => productId == prod.id);
  }

  List<Product> get items {
    return [..._items];
  }

  Product findById(String id) {
    return _items.firstWhere((product) => product.id == id);
  }
}

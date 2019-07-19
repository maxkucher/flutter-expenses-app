import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tasks_app/providers/product.dart';
import 'package:http/http.dart' as http;

class ProductsProvider with ChangeNotifier {
  static const backendUrl =
      'https://turorial-12beb.firebaseio.com/products.json';

  final _token;

  ProductsProvider(this._token, this._items);

  List<Product> _items = [];

  Future<void> fetchProducts() async {
    try {
      _items.clear();
      var response = await http.get('$backendUrl?auth=$_token');
      print(json.decode(response.body));
      (json.decode(response.body) as Map<String, dynamic>)
          .forEach((key, value) {
        _items.add(Product(
            id: key,
            title: value['title'],
            description: value['description'],
            price: value['price'],
            imageUrl: value['imageUrl']));
      });
    } catch (e) {
      print(e);
      throw e;
    } finally {
      notifyListeners();
    }
  }

  Future<void> addProduct(Product product) async {
    try {
      var response = await http.post(backendUrl,
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'price': product.price,
            'isFavourite': product.isFavourite
          }));
      final newProduct = Product(
          id: json.decode(response.body)['name'],
          title: product.title,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl);
      _items.add(newProduct);
      notifyListeners();
      return Future.value();
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<void> updateProduct(Product product) async {
    final prodIndex = findProductIndex(product.id);
    if (prodIndex >= 0) {
      final url =
          'https://turorial-12beb.firebaseio.com/products/${product.id}.json?auth=$_token';
      try {
        await http.post(url,
            body: json.encode({
              'title': product.title,
              'description': product.description,
              'imageUrl': product.imageUrl,
              'price': product.price,
              'isFavourite': product.isFavourite
            }));
        _items[prodIndex] = product;
        notifyListeners();
        return Future.value();
      } catch (e) {
        print(e);
        throw e;
      }
    }
  }

  Future<void> deleteProduct(String productId) async {
    final prodIndex = findProductIndex(productId);
    if (prodIndex >= 0) {
      final existingProduct = _items[prodIndex];
      _items.removeWhere((product) => product.id == productId);
      try {
        await http.delete(
            'https://turorial-12beb.firebaseio.com/products/$productId.json?auth=$_token');
        notifyListeners();
      } catch (e) {
        print(e);
        _items.insert(prodIndex, existingProduct);
        throw e;
      }
    }
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

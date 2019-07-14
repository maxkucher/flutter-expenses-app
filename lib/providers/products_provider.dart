import 'package:flutter/material.dart';
import 'package:tasks_app/providers/product.dart';

class ProductsProvider with ChangeNotifier {
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



  List<Product> get items {
    return [..._items];
  }

  Product findById(String id){
    return _items
        .firstWhere((product) => product.id == id);
  }

  void addProduct(){
    notifyListeners();
  }
}

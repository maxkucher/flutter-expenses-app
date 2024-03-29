import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavourite;

  void toggleFavourite(String token, String userId) async {
    final oldStatus = this.isFavourite;
    this.isFavourite = !this.isFavourite;
    try{
     await   http.patch('https://turorial-12beb.firebaseio.com/userFavourites/$userId/$id.json?auth=$token',
         body: json.encode({
           'isFavourite':this.isFavourite
         }));
    }catch(e){
      this.isFavourite = oldStatus;
    }finally{
      notifyListeners();
    }

  }

  Product(
      {@required this.id,
      @required this.title,
      @required this.description,
      @required this.price,
      @required this.imageUrl,
      this.isFavourite = false});
}

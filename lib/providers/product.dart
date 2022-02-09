import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String? id;
  final String? title;
  final String? desc;
  final double? price;
  final String? imageUrl;
  bool isFavourite;

  Product({
    this.id,
    this.title,
    this.desc,
    this.price,
    this.imageUrl,
    this.isFavourite = false,
  });

  void toggleFavouriteStatus() async {
    final oldStatus = isFavourite;
    isFavourite = !isFavourite;
    notifyListeners();
    print(id);
    final url = Uri.parse(
        'https://shopapp-6eec0-default-rtdb.firebaseio.com/products/$id.json');
    print('kiran $url');
    try {
      await http.patch(
        url,
        body: jsonEncode({
          'isFavourite': isFavourite,
        }),
      );
    } catch (error) {
      isFavourite = oldStatus;
    }
  }
}

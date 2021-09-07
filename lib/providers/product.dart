import 'package:flutter/material.dart';

class Product with ChangeNotifier {
  final String? id;
  final String? title;
  final String? desc;
  final double? price;
  final String? imageUrl;
  bool isFavourite;

  Product(
      {
      this.id,
      this.title,
      this.desc,
      this.price,
      this.imageUrl,
      this.isFavourite = false,
      }
    );

  void toggleFavouriteStatus() {
    isFavourite = !isFavourite;
    notifyListeners();
  }
  
}

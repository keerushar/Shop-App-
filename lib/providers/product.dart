import 'package:flutter/material.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String desc;
  final double price;
  final String imageUrl;
  bool isFavourite;

  Product(
      {
      required this.id,
      required this.title,
      required this.desc,
      required this.price,
      required this.imageUrl,
      this.isFavourite = false,
      }
    );

  void toggleFavouriteStatus() {
    isFavourite = !isFavourite;
    notifyListeners();
  }
  
}

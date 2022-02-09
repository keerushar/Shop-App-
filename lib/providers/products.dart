import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shopapp/exception/http_exception.dart';
import 'package:shopapp/providers/product.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  List<Product> _items = [
    Product(
        id: 'p1',
        title: "Dabur Amala",
        desc: "Hair Oil that keeps your hair strong and beautiful",
        price: 50,
        imageUrl:
            'https://www.dabur.com/img/product/small/2-dabur-amla-hair-oil-smal.JPG'),
    Product(
        id: 'p2',
        title: "Fogg Deo",
        desc: "Fogg Deo Spicy Fragrance for men",
        price: 100,
        imageUrl:
            'https://static-01.daraz.com.np/p/a0f8b4a10e7f5f97b9b23147188013a7.jpg'),
    Product(
        id: 'p3',
        title: "Vaseline",
        desc: "Vaseline for your Skin",
        price: 150,
        imageUrl:
            'https://4.imimg.com/data4/HB/OL/GLADMIN-185864/vaseline-body-lotion-500x500.png'),
    Product(
        id: 'p4',
        title: "Nivea Men Facewash",
        desc: "Nivea Men Facewash for cleaning",
        price: 200,
        imageUrl:
            'https://images-eu.nivea.com/-/media/media-center-items/5/c/c/371875-1.png'),
  ];

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((element) => element.isFavourite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future<void> fetchAndSetProducts() async {
    final url = Uri.parse(
        'https://shopapp-6eec0-default-rtdb.firebaseio.com/products.json');

    try {
      final response = await http.get(url);
      // ignore: unnecessary_cast
      final extractedData = jsonDecode(response.body) ??
          <String, dynamic>{} as Map<String, dynamic>;
      if (extractedData == <String, dynamic>{}) {
        return;
      }
      final List<Product> loadedProduct = [];
      extractedData.forEach((prodId, prodData) {
        loadedProduct.add(Product(
          id: prodId,
          title: prodData['title'],
          desc: prodData['desc'],
          price: prodData['price'],
          imageUrl: prodData['imageUrl'],
          isFavourite: prodData['isFavourite'],
        ));
      });
      _items = loadedProduct;
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> addProduct(Product product) async {
    final url = Uri.parse(
        'https://shopapp-6eec0-default-rtdb.firebaseio.com/products.json');
    print(url);
    try {
      final response = await http.post(
        url,
        body: jsonEncode(
          {
            'title': product.title,
            'desc': product.desc,
            'price': product.price,
            'imageUrl': product.imageUrl,
            'isFavourite': product.isFavourite,
          },
        ),
      );

      final newProduct = Product(
        id: json.decode(response.body)['name'],
        title: product.title,
        desc: product.desc,
        imageUrl: product.imageUrl,
        price: product.price,
      );
      _items.add(newProduct);
      notifyListeners();
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((e) => e.id == id);

    if (prodIndex >= 0) {
      final url = Uri.parse(
          'https://shopapp-6eec0-default-rtdb.firebaseio.com/products/$id.json');
      await http.patch(url,
          body: json.encode({
            'title': newProduct.title,
            'desc': newProduct.desc,
            'imageUrl': newProduct.imageUrl,
            'price': newProduct.price,
          }));
      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      print('...');
    }
  }

  Future<void> deleteProduct(String id) async {
    final url = Uri.parse(
        'https://shopapp-6eec0-default-rtdb.firebaseio.com/products/$id.json');
    final existingProductIndex = _items.indexWhere((e) => e.id == id);
    Product? existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete Product');
    }
    existingProduct = null;
  }
}

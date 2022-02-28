import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shopapp/exception/dio_exception.dart';
import 'package:shopapp/providers/product.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  List<Product> _items = [];

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
      throw DioException('Could not delete Product');
    }
    existingProduct = null;
  }
}

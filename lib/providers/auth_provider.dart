import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shopapp/providers/api_key.dart';
import 'package:shopapp/providers/base_api.dart';

class Auth extends BaseApi with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  String? _userId;

  static const baseUrl = 'https://identitytoolkit.googleapis.com';

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url = '$baseUrl/v1/accounts:$urlSegment?key=${ApiKey.shopApi}';

      final response = await dio.post(
        url,
        data: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
  }

  Future<void> signUp(String? email, String? password) async {
    return _authenticate(email!, password!, 'signUp');
  }

  Future<void> signIn(String? email, String? password) async {
    return _authenticate(email!, password!, 'signInWithPassword');
  }
}

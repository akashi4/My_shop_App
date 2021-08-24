import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;
  Timer _authTimer;

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
  }

  bool get isAuth {
    return _token != null;
  }

  String get userId {
    return _userId;
  }

  Future<void> _authenticate(String email, String password, String dest) async {
    try {
      final url = Uri.parse(
          'https://identitytoolkit.googleapis.com/v1/accounts:$dest?key=AIzaSyDhMpMKfB4TD1-XQlitFBqhZfFgzUBI4X4');
      final response = await http.post(url,
          body: json.encode({
            "email": email,
            "password": password,
            "returnSecureToken": true
          }));
      print("singing in \n" + (json.decode(response.body)));
      final responseData = json.decode(response.body);

      if (responseData['error'] != null) {
        throw responseData['error']['message'];
      }

      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'])));
      autoLogout();
    } catch (error) {
      throw error;
    }
  }

  Future<void> singUp(String email, String password) async {
    return _authenticate(email, password, "signUp");
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, " signInWithPassword");
  }

  void logOut() {
    _token = null;
    _userId = null;
    _expiryDate = null;
    notifyListeners();
  }

  void autoLogout() {
    //automaticaly logout the user after the token expire
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    final timeToExpire = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpire), () => logOut);
  }
}

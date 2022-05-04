import 'dart:async';
import 'package:flutter/foundation.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  bool isVisible = true;
  bool isVisible2 = true;
  bool isVisible3 = true;

  String? _token = null;
  String? _userId = null;
  DateTime? _expirydate = null;
  Timer? _authTimer;

  bool get alreadyAuth {
    return _token != null;
  }

  String? get token {
    if (_token != null && _expirydate != null && _expirydate!.isAfter(DateTime.now())) {
      return _token;
    } else {
      return null;
    }
  }

  Future<void> auth(String email, String pass, String urlSegment) async {
    final url = Uri.parse('https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyDmbl-nZmQr2hyjtmLKFyROacz2Wn0APVE');
    try {
      final res = await http.post(url,
          body: json.encode({
            'email': email,
            'password': pass,
            'returnSecureToken': true,
          }));
      final resData = json.decode(res.body);
      _token = resData['idToken	'];
      _userId = resData['localId'];
      _expirydate = DateTime.now().add(Duration(seconds: int.parse(resData['expiresIn'])));

      autoLogOut();
      final userData = json.encode({
        'token': _token,
        'userId': _userId,
        'expiryDate': _expirydate!.toIso8601String()
      });
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('uesrData', userData);
      notifyListeners();

      if (resData['error'] != null) {
        throw '${resData['error']['message']}';
      }
    } catch (e) {
      throw e;
    }
    notifyListeners();
  }

  Future<bool> autoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('uesrData')) {
      return false;
    } else {
      final data = json.decode(prefs.getString('uesrData')!) as Map<String, dynamic>;
      final expDate = DateTime.parse(data['expiryDate']!);
      if (expDate.isBefore(DateTime.now())) {
        return false;
      }
      _token = data['token'];
      _userId = data['userId'];
      _expirydate = expDate;
      notifyListeners();
      autoLogOut();
      return true;
    }
  }

  Future<void> logIn(String email, String pass) async {
    return auth(email, pass, 'signInWithPassword');
  }

  Future<void> signUp(String email, String pass) async {
    return auth(email, pass, 'signUp');
  }

  void logOut() async {
    final prefs = await SharedPreferences.getInstance();
    if (_authTimer != null) {
      _authTimer!.cancel();
    }
    _token = null;
    _userId = null;
    _expirydate = null;
    prefs.clear();

    notifyListeners();
  }

  void autoLogOut() {
    if (_authTimer != null) {
      _authTimer!.cancel();
    }
    _authTimer = Timer(Duration(seconds: _expirydate!.difference(DateTime.now()).inSeconds), logOut);

    notifyListeners();
  }

  changeVisibility() {
    isVisible = !isVisible;
    notifyListeners();
  }

  changeVisibility2() {
    isVisible2 = !isVisible2;
    notifyListeners();
  }

  changeVisibility3() {
    isVisible3 = !isVisible3;
    notifyListeners();
  }

  notifyListeners();
}

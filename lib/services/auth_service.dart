import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthService extends ChangeNotifier {
  
  final String _baseUrl = 'identitytoolkit.googleapis.com';
  final String _firebaseToken = 'AIzaSyBsyGSn5nt5y8Ebvl2Wti9BeNIeuU0O1bg';
  final storage = FlutterSecureStorage();


  Future<String?> createUser(String email, String password) async {
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };

    final url = Uri.https(_baseUrl, '/v1/accounts:signUp', {
      'key': _firebaseToken
    });

    print('$authData');
    final res = await http.post(url, body: json.encode(authData) );
    final Map<String, dynamic> decodeRes = json.decode(res.body);

    if (!decodeRes.containsKey('idToken')) {
      return decodeRes['error']['message'];
    }

    storage.write(key: 'token', value: decodeRes['idToken']);
    return null;
  }

  Future<String?> login(String email, String password) async {
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };

    final url = Uri.https(_baseUrl, '/v1/accounts:signInWithPassword', {
      'key': _firebaseToken
    });

    final res = await http.post(url, body: json.encode(authData) );
    final Map<String, dynamic> decodeRes = json.decode(res.body);

    if (!decodeRes.containsKey('idToken')) {
      return decodeRes['error']['message'];
    }

    storage.write(key: 'token', value: decodeRes['idToken']);
    return null;
  }

  Future logOut() async {
    await storage.delete(key: 'token');
  }

  Future<String> readToken() async {
    return await storage.read(key: 'token') ?? '';
  }
}
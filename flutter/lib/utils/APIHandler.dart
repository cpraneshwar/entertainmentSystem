import 'dart:collection';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class APIhandler {
  final Dio _dio = Dio();
  final String hostname = "http://10.61.25.233:8000";

  Future<Map> signUp(Map<String, dynamic> userData) async {
    try {
      Response response = await _dio.post(
        '$hostname/users/signup/',
        data: {
          'email': userData['email'],
          'password': userData['password'],
          'password2': userData['password'],
          'username': userData['email'],
          'first_name': 'f_name',
          'last_name': 'l_name'
        },
      );
      //returns the successful user data json object

      await logIn(userData);
      return {'status': 'success', 'response': response.data};
    } on DioError catch (e) {
      //returns the error object if any

      return {'status': 'failure', 'data': e.response!.data};
    }
  }

  Future<Map> logIn(Map<String, dynamic> userData) async {
    try {
      Response response = await _dio.post(
        '$hostname/auth/',
        data: {
          'username': userData['email'],
          'password': userData['password'],
        },
      );
      //returns the successful user data json object

      const storage = FlutterSecureStorage();
      String token = response.data['token'];
      await storage.write(key: 'authToken', value: token);
      await storage.write(key: 'loginStatus', value: 'true');
      await storage.write(key: 'email', value: userData['email']);
      return {'status': 'success', 'data': response.data};
    } on DioError catch (e) {
      //returns the error object if any

      return {'status': 'failure', 'response': e.response!.data};
    }
  }

  Future<Map> getUser() async {
    try {
      const storage = FlutterSecureStorage();
      String? token = await storage.read(key: 'authToken');
      Response response = await _dio.get(
        '$hostname/users/self/',
        options: Options(
          headers: {
            'Authorization': 'Token $token',
          },
        ),
      );
      return {'status': 'success', 'data': response.data};
    } on DioError catch (e) {
      return {'status': 'failure', 'response': e.response!.data};
    }
  }
}

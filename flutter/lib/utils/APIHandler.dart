import 'dart:collection';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class APIhandler {
  final Dio _dio = Dio();
  final String hostname = "https://unnovent1.canadacentral.cloudapp.azure.com";

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

  Future<String> getLinkURL() async {
    const storage = FlutterSecureStorage();
    String? token = await storage.read(key: 'authToken');
    Response response = await _dio.get(
      '$hostname/ms_graph/get_graph_auth_api/',
      options: Options(
        headers: {
          'Authorization': 'Token $token',
        },
      ),
    );
    return response.data['OauthUrl'];
  }

  Future<List> getQuizData(int category,int difficulty) async {
    var diffList = ["easy","medium","hard"];
    String diff = diffList[difficulty];
    try {
      Response response = await _dio.get('https://opentdb.com/api.php?amount=10&category=$category&difficulty=$diff&type=multiple');
      return response.data['results'];
    } on DioError catch(e){
      return [{'status': 'failure', 'response': e.response!.data}];
    }
  }

  void uploadDeviceID(String deviceID) async {
    const storage = FlutterSecureStorage();
    String? token = await storage.read(key: 'authToken');
    Response response = await _dio.post(
      '$hostname/users/set_device_id/',
      data:{
        'device_id':deviceID
      },
      options: Options(
        headers: {
          'Authorization': 'Token $token',
        },
      ),
    );
  }

  Future<Map> removePoints(int point) async{
    const storage = FlutterSecureStorage();
    String? token = await storage.read(key: 'authToken');
    Response response = await _dio.post(
      '$hostname/rewards/withdraw_points',
      data: {
        'points': point
      },
      options: Options(
        headers: {
          'Authorization': 'Token $token',
        },
      ),
    );
    return {'status': 'success', 'data': response.data};
  }

  void uploadQuizData(int score,int total,int difficulty,int category) async {
    const storage = FlutterSecureStorage();
    String? token = await storage.read(key: 'authToken');
    Response response = await _dio.post(
      '$hostname/challenges/add_quiz_history/',
      data: {
        'totalQuestions': total,
        'totalCorrectAns': score,
        'difficulty':difficulty,
        'category':category
      },
      options: Options(
        headers: {
          'Authorization': 'Token $token',
        },
      ),
    );

  }
}

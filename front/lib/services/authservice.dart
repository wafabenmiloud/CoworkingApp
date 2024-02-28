import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decode/jwt_decode.dart';

import '../constants.dart';

class AuthService {
  Dio dio = new Dio();

  getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    dio.options.headers['Authorization'] = 'Bearer $token';
    final payload = Jwt.parseJwt(token!);
    final userId = payload['id'];
    final res = await dio.get('$server/user/$userId');
    return res.data;
  }

  updateUser(fullname, nickname, email, phone, country, gender, address) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    dio.options.headers['Authorization'] = 'Bearer $token';
    final payload = Jwt.parseJwt(token!);
    final userId = payload['id'];
    return await dio.put('$server/user/$userId',
        data: {
          "fullname": fullname,
          "nickname": nickname,
          "email": email,
          "phone_number": phone,
          "country": country,
          "gender": gender,
          "address": address
        },
        options: Options(contentType: Headers.jsonContentType));
  }

  register(
      String fullname, String email, String password) async {
    try {
      final response = await dio.post(
        '$server/register',
        data: {
          'fullname': fullname,
          'email': email,
          'password': password,
        },
        options: Options(contentType: Headers.jsonContentType),
      );

      return response.data;
    } catch (error) {
      print('Error registering user: $error');
      throw error;
    }
  }

  login(email, password) async {
    final response = await dio.post('$server/login',
        data: {"email": email, "password": password},
        options: Options(contentType: Headers.jsonContentType));

    if (response.statusCode == 200) {
      final token = response.data['token'];
      if (token == null) {
        Fluttertoast.showToast(
            msg: 'Wrong email or password !!!',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        await prefs.setBool('isLogin', true);
      }
    }
    return response;
  }

  forgetpass(email) async {
    return await dio.post('$server/forgetpass',
        data: {"email": email},
        options: Options(contentType: Headers.jsonContentType));
  }

  verifycode(code) async {
    return await dio.post('$server/verifycode',
        data: {"code": code},
        options: Options(contentType: Headers.jsonContentType));
  }

  resetpass(password, code) async {
    return await dio.post('$server/resetpass',
        data: {"password": password, "code": code},
        options: Options(contentType: Headers.jsonContentType));
  }
}

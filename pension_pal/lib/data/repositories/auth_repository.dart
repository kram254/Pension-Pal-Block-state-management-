import '../models/user.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  final Dio _dio = Dio();

  Future<User> authenticate(String nssfNumber, String password) async {
    final response = await _dio.post('https://api.pensionapp.com/login', data: {
      'nssf_number': nssfNumber,
      'password': password,
    });

    if (response.statusCode == 200) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', response.data['token']);
      return User.fromJson(response.data['user']);
    } else {
      throw Exception('Failed to authenticate');
    }
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
  }
}
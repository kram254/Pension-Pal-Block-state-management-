import '../models/user.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  final Dio _dio = Dio();

  Future<User> authenticate(String nssfNumber, String password) async {
    // Commented out original authentication logic
    // final response = await _dio.post('https://api.pensionapp.com/login', data: {
    //   'nssf_number': nssfNumber,
    //   'password': password,
    // });

    // if (response.statusCode == 200) {
    //   SharedPreferences prefs = await SharedPreferences.getInstance();
    //   prefs.setString('token', response.data['token']);
    //   return User.fromJson(response.data['user']);
    // } else {
    //   throw Exception('Failed to authenticate');
    // }

   
    final String testUsername = 'User1';
    final String testPassword = 'pass123';

    if (nssfNumber == testUsername && password == testPassword) {
      // Simulating successful authentication
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', 'test_token');
      return User(id: '1', name: 'Test User', nssfNumber: testUsername);
    } else {
      throw Exception('Invalid credentials');
    }
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
  }
}
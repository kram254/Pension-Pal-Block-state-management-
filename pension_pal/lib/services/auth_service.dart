    // Start of Selection
    import 'dart:convert';
    import 'package:flutter/foundation.dart';
    import 'package:http/http.dart' as http;
    import 'package:shared_preferences/shared_preferences.dart';
    import '../data/models/user.dart';
    // Removed the import for constants.dart and defined the base URL directly
    
    class AuthService with ChangeNotifier {
      User? _currentUser;
      String? _token;
    
      User? get currentUser => _currentUser;
      bool get isAuthenticated => _token != null;
    
      // Define the base URL for the Flask backend
      static const String _apiBaseUrl = 'http://localhost:5000'; // Update with your backend URL
    
      Future<bool> login(String email, String password) async {
        try {
          final response = await http.post(
            Uri.parse('$_apiBaseUrl/login'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'email': email, 'password': password}),
          );
    
          if (response.statusCode == 200) {
            final data = jsonDecode(response.body);
            _token = data['token'];
            _currentUser = User.fromJson(data['user']);
            final prefs = await SharedPreferences.getInstance();
            await prefs.setString('token', _token!);
            notifyListeners();
            return true;
          } else {
            // Handle invalid credentials or other errors
            return false;
          }
        } catch (e) {
          // Handle exceptions such as network errors
          return false;
        }
      }
    }


import 'dart:convert';
import 'package:pt2flutter/data/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:pt2flutter/config/app_config.dart';

abstract class IAuthenticationService {
  Future<User> validateLogin(String email, String password);
}

class AuthenticationService implements IAuthenticationService {
  @override
  Future<User> validateLogin(String email, String password) async {
    final url = Uri.parse('${AppConfig.authUrl}/token?grant_type=password');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${AppConfig.anonKey}',
        'apikey': AppConfig.anonKey,
      },
      body: jsonEncode({'email': email, 'password': password}),
    );
    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body)); // HTTP OK
    } else if (response.statusCode == 400) {
      final errorResponse = jsonDecode(response.body);
      throw Exception(
        '${errorResponse['error_description'] ?? errorResponse['message']}',
      ); // HTTP Bad Request
    } else {
      throw Exception('Login error'); // HTTP Error
    }
  }
}

import 'dart:convert';
import 'package:pt2flutter/data/models/profile.dart';
import 'package:pt2flutter/data/models/user.dart';
import 'package:http/http.dart' as http;

abstract class IAuthenticationService {
  Future<User> validateLogin(String username, String password);
  Future<Profile> getProfile(User user);
}

class AuthenticationService implements IAuthenticationService {
  @override
  Future<User> validateLogin(String username, String password) async {
    final url = Uri.parse('https://dummyjson.com/auth/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );
    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body)); // HTTP OK
    } else if (response.statusCode == 400) {
      final errorResponse = jsonDecode(response.body);
      throw Exception('${errorResponse['message']}'); // HTTP Bad Request
    } else {
      throw Exception('Login error'); // HTTP Error
    }
  }

  @override
  Future<Profile> getProfile(User user) async {
    final url = Uri.parse('https://dummyjson.com/auth/me');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer ${user.accessToken}'},
    );
    if (response.statusCode == 200) {
      return Profile.fromJson(jsonDecode(response.body)); // HTTP OK
    } else {
      throw Exception('Profile error'); // HTTP Error
    }
  }
}

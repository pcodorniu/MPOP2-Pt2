import 'dart:convert';
import 'package:pt2flutter/data/models/profile.dart';
import 'package:pt2flutter/data/models/user.dart';
import 'package:http/http.dart' as http;

abstract class IAuthenticationService {
  Future<User> validateLogin(String email, String password);
  Future<Profile> getProfile(User user);
}

class AuthenticationService implements IAuthenticationService {
  // Clau de la supabase
  static const String _apiKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Iml0dnl2dnhvbm5zZG9xb2t2aWt3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjU0ODE1NTQsImV4cCI6MjA4MTA1NzU1NH0.6AxDj1flnnqtBvOjoKe9_MehqBwo0kNgxLGOf4VKQ5A';

  @override
  Future<User> validateLogin(String email, String password) async {
    final url = Uri.parse(
      'https://itvyvvxonnsdoqokvikw.supabase.co/auth/v1/token?grant_type=password',
    );
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_apiKey',
        'apikey': _apiKey,
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

  @override
  Future<Profile> getProfile(User user) async {
    final url = Uri.parse(
      'https://itvyvvxonnsdoqokvikw.supabase.co/rest/v1/profiles?id=eq.${user.id}&select=*',
    );
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer ${user.accessToken}',
        'apikey': _apiKey,
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      if (data.isNotEmpty) {
        return Profile.fromJson(data[0]); // HTTP OK
      } else {
        throw Exception('Profile not found');
      }
    } else {
      throw Exception('Profile error: ${response.body}'); // HTTP Error
    }
  }
}

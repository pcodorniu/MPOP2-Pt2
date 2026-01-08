import 'package:pt2flutter/data/models/profile.dart';
import 'package:pt2flutter/data/models/user.dart';
import 'package:pt2flutter/data/repositories/login_repository.dart';
import 'package:flutter/material.dart';

class LoginViewModel extends ChangeNotifier {
  final ILoginRepository loginRepository;

  LoginViewModel({required this.loginRepository});

  String _username = '';
  String _password = '';
  bool _isLoading = false;
  String? _errorMessage;
  User? _currentUser;
  Profile? _currentProfile;

  String get username => _username;
  String get password => _password;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  User? get currentUser => _currentUser;
  Profile? get currentProfile => _currentProfile;

  void setUsername(String value) {
    _username = value;
    notifyListeners();
  }

  void setPassword(String value) {
    _password = value;
    notifyListeners();
  }

  Future<bool> login() async {
    _isLoading = true;
    _errorMessage = null;
    _currentProfile = null;
    notifyListeners();

    try {
      _currentUser = await loginRepository.login(_username, _password);
      await fetchProfile();
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  Future<void> fetchProfile() async {
    if (_currentUser == null) return;
    try {
      _currentProfile = await loginRepository.getProfile(_currentUser!);
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
    }
  }

  void logout() {
    _currentUser = null;
    _currentProfile = null;
    _username = '';
    _password = '';
    notifyListeners();
  }
}

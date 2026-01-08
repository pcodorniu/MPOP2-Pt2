import 'package:pt2flutter/data/models/profile.dart';
import 'package:pt2flutter/data/models/user.dart';
import 'package:pt2flutter/data/services/authentication_services.dart';

abstract class ILoginRepository {
  Future<User> login(String username, String password);
  Future<Profile> getProfile(User user);
}

class LoginRepository implements ILoginRepository {
  final IAuthenticationService authenticationService;

  LoginRepository({required this.authenticationService});

  @override
  Future<User> login(String username, String password) async {
    return await authenticationService.validateLogin(username, password);
  }

  @override
  Future<Profile> getProfile(User user) async {
    return await authenticationService.getProfile(user);
  }
}

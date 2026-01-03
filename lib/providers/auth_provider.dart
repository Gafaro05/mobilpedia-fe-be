import 'package:flutter/material.dart';
import '../api/api_service.dart';
import '../utils/session_manager.dart';

class AuthProvider extends ChangeNotifier {
  final ApiService _api = ApiService();

  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  String? get userName => _api.userName;

  Future<void> refreshUser() async {
    await _api.getProfile();
    notifyListeners();
  }

  Future<void> init() async {
    final token = await SessionManager.getToken();
    if (token != null && token.isNotEmpty) {
      _api.setToken(token);
      _isLoggedIn = true;
      notifyListeners();
    }
  }

  Future<bool> login(String user, String pass) async {
    final ok = await _api.login(
      emailOrUsername: user,
      password: pass,
    );
    if (ok && _api.token != null) {
      await SessionManager.saveToken(_api.token!);
      _isLoggedIn = true;
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> register({
    required String name,
    required String username,
    required String email,
    required String password,
    String? phone,
    String? address,
  }) async {
    return _api.register(
      name: name,
      username: username,
      email: email,
      password: password,
      phone: phone,
      address: address,
    );
  }

  Future<void> logout() async {
    _isLoggedIn = false;
    _api.setToken(null);
    await SessionManager.clear();
    notifyListeners();
  }
}

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../data/mock_users.dart';

class AuthProvider with ChangeNotifier {
  User? _currentUser;

  User? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;

  Future<bool> login(String email, String password) async {
    try {
      final user = mockUsers.firstWhere(
        (u) => u.email == email && u.password == password,
      );

      _currentUser = user;

      // Save user data
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("userId", user.id);
      await prefs.setString("userName", user.userName);
      await prefs.setString("email", user.email);
      await prefs.setString("profileImage", user.profileImage ?? "");
      await prefs.setBool("isLoggedIn", true);

      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getString("userId");
    final name = prefs.getString("userName");
    final email = prefs.getString("email");
    final profileImage = prefs.getString("profileImage");

    if (id != null && name != null && email != null) {
      _currentUser = User(
        id: id,
        userName: name,
        email: email,
        password: "",
        profileImage: profileImage,
      );
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _currentUser = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("isLoggedIn", false);

    await prefs.clear();
    notifyListeners();
  }
}

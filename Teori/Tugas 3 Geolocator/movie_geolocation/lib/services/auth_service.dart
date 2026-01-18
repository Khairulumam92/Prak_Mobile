import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class AuthService {
  static const String _usersKey = 'users';
  static const String _currentUserKey = 'current_user';
  static const String _isLoggedInKey = 'is_logged_in';

  // Register new user
  Future<bool> register(UserModel user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final usersJson = prefs.getString(_usersKey);
      
      List<UserModel> users = [];
      if (usersJson != null) {
        final List<dynamic> usersList = json.decode(usersJson);
        users = usersList.map((u) => UserModel.fromJson(u)).toList();
      }

      // Check if email already exists
      if (users.any((u) => u.email == user.email)) {
        return false; // Email already registered
      }

      users.add(user);
      final updatedUsersJson = json.encode(users.map((u) => u.toJson()).toList());
      await prefs.setString(_usersKey, updatedUsersJson);
      
      return true;
    } catch (e) {
      return false;
    }
  }

  // Login user
  Future<bool> login(String email, String password) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final usersJson = prefs.getString(_usersKey);
      
      if (usersJson == null) {
        return false;
      }

      final List<dynamic> usersList = json.decode(usersJson);
      final users = usersList.map((u) => UserModel.fromJson(u)).toList();

      final user = users.firstWhere(
        (u) => u.email == email && u.password == password,
        orElse: () => UserModel(fullName: '', email: '', password: ''),
      );

      if (user.email.isEmpty) {
        return false; // User not found or wrong password
      }

      // Save current user and login status
      await prefs.setString(_currentUserKey, json.encode(user.toJson()));
      await prefs.setBool(_isLoggedInKey, true);
      
      return true;
    } catch (e) {
      return false;
    }
  }

  // Logout user
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_currentUserKey);
    await prefs.setBool(_isLoggedInKey, false);
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  // Get current user
  Future<UserModel?> getCurrentUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString(_currentUserKey);
      
      if (userJson == null) {
        return null;
      }

      return UserModel.fromJson(json.decode(userJson));
    } catch (e) {
      return null;
    }
  }
}

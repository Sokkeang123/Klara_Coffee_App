import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class UserStorage {
  static const _kUser = "user";
  static const _kToken = "token"; // ✅ ADD

  // ---------------- USER ----------------
  static Future<void> saveUser(Map<String, dynamic> user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kUser, jsonEncode(user));
  }

  static Future<Map<String, dynamic>?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kUser);
    if (raw == null) return null;

    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map) {
        return decoded.map((k, v) => MapEntry(k.toString(), v));
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  static Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kUser);
  }

  // ---------------- TOKEN ---------------- ✅ ADD
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kToken, token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kToken);
  }

  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kToken);
  }

  // optional helper
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kUser);
    await prefs.remove(_kToken);
  }
}
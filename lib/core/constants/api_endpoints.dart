


import 'package:flutter/foundation.dart';

class ApiEndpoints {
  static String get baseUrl =>
      kIsWeb
          ? "http://localhost:5000"
          : "http://10.0.2.2:5000";

  static String get login => "$baseUrl/auth/login";
  static String get signup => "$baseUrl/auth/signup";
  static String get profile => "$baseUrl/auth/profile";
  static String get logout => "$baseUrl/auth/logout";

  static String get menus => "$baseUrl/menu";
}

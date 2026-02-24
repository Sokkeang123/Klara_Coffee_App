// class ApiEndpoints {
//   static const String baseUrl = "http://localhost:5000";

//   static const String login = "$baseUrl/auth/login";
//   static const String signup = "$baseUrl/auth/signup";

//   // static String get profile => null;
// }


class ApiEndpoints {
  static const String baseUrl = "http://localhost:5000";

  static const String login = "$baseUrl/auth/login";
  static const String signup = "$baseUrl/auth/signup";
  static const String profile = "$baseUrl/auth/profile";
}

// import 'package:flutter/foundation.dart';

// class ApiEndpoints {
//   static String get baseUrl => kIsWeb
//       ? "http://localhost:5000"     // ✅ Web (Chrome)
//       : "http://10.0.2.2:5000";     // ✅ Android Emulator

//   static String get login => "$baseUrl/auth/login";
//   static String get signup => "$baseUrl/auth/signup";
// }
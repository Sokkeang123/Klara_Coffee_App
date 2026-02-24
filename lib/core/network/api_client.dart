// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import '../storage/token_storage.dart';

// class ApiClient {
//   Future<Map<String, dynamic>> post(
//     String url,
//     Map<String, dynamic> body, {
//     bool auth = false,
//   }) async {
//     final headers = <String, String>{
//       "Content-Type": "application/json",
//       "Accept": "application/json",
//     };

//     if (auth) {
//       final token = await TokenStorage.getToken();
//       if (token != null && token.isNotEmpty) {
//         headers["Authorization"] = "Bearer $token";
//       }
//     }

//     final res = await http.post(
//       Uri.parse(url),
//       headers: headers,
//       body: jsonEncode(body),
//     );

//     final data = _safeJsonMap(res.body);

//     if (res.statusCode >= 200 && res.statusCode < 300) return data;

//     throw Exception(data["message"] ?? "Request failed (${res.statusCode})");
//   }

//   Map<String, dynamic> _safeJsonMap(String body) {
//     try {
//       final decoded = jsonDecode(body);
//       if (decoded is Map) {
//         return decoded.map((k, v) => MapEntry(k.toString(), v));
//       }
//       return {"data": decoded};
//     } catch (_) {
//       return {"message": body};
//     }
//   }
// }
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../storage/token_storage.dart';

class ApiClient {

  Map<String, dynamic> _safeJsonMap(String body) {
    try {
      final decoded = jsonDecode(body);
      if (decoded is Map) {
        return decoded.map((k, v) => MapEntry(k.toString(), v));
      }
      return {"data": decoded};
    } catch (_) {
      return {"message": body};
    }
  }

  /// ========================
  /// POST
  /// ========================
  Future<Map<String, dynamic>> post(
    String url,
    Map<String, dynamic> body, {
    bool auth = false,
  }) async {
    final headers = <String, String>{
      "Content-Type": "application/json",
      "Accept": "application/json",
    };

    if (auth) {
      final token = await TokenStorage.getToken();
      if (token != null && token.isNotEmpty) {
        headers["Authorization"] = "Bearer $token";
      }
    }

    final res = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(body),
    );

    final data = _safeJsonMap(res.body);

    if (res.statusCode >= 200 && res.statusCode < 300) {
      return data;
    }

    throw Exception(data["message"] ?? "Request failed (${res.statusCode})");
  }

  /// ========================
  /// PUT
  /// ========================
  Future<Map<String, dynamic>> put(
    String url,
    Map<String, dynamic> body, {
    bool auth = false,
  }) async {
    final headers = <String, String>{
      "Content-Type": "application/json",
      "Accept": "application/json",
    };

    if (auth) {
      final token = await TokenStorage.getToken();
      if (token == null || token.isEmpty) {
        throw Exception("No token found. Please login again.");
      }
      headers["Authorization"] = "Bearer $token";
    }

    final res = await http.put(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(body),
    );

    final data = _safeJsonMap(res.body);

    if (res.statusCode >= 200 && res.statusCode < 300) {
      return data;
    }

    throw Exception(data["message"] ?? "Request failed (${res.statusCode})");
  }
}
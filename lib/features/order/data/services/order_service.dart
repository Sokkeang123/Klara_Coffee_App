// import 'dart:convert';
// import 'package:http/http.dart' as http;

// import '../../../../core/constants/api_endpoints.dart';
// import '../../../../core/storage/user_storage.dart';
// import '../model/order_model.dart';

// class OrderService {
//   // ---------------- CREATE ORDER ----------------
//   Future<void> createOrder({
//     required List<Map<String, dynamic>> items,
//     required double totalCost,
//   }) async {
//     final token = await UserStorage.getToken();

//     final res = await http.post(
//       Uri.parse(ApiEndpoints.orders),
//       headers: {
//         "Content-Type": "application/json",
//         if (token != null && token.isNotEmpty)
//           "Authorization": "Bearer $token",
//       },
//       body: jsonEncode({
//         "items": items,
//         "totalCost": totalCost,
//       }),
//     );

//     final data = jsonDecode(res.body.isEmpty ? "{}" : res.body);

//     if (res.statusCode < 200 || res.statusCode >= 300) {
//       throw Exception(data["message"] ?? "Order failed (${res.statusCode})");
//     }
//   }

//   // ---------------- GET MY ORDERS ---------------- ✅ ADD THIS
//   Future<List<OrderModel>> getMyOrders() async {
//     final token = await UserStorage.getToken();

//     final res = await http.get(
//       Uri.parse(ApiEndpoints.myOrders),
//       headers: {
//         "Content-Type": "application/json",
//         if (token != null && token.isNotEmpty)
//           "Authorization": "Bearer $token",
//       },
//     );

//     final data = jsonDecode(res.body.isEmpty ? "[]" : res.body);

//     if (res.statusCode < 200 || res.statusCode >= 300) {
//       throw Exception("Failed to fetch orders (${res.statusCode})");
//     }

//     if (data is List) {
//       return data
//           .map<OrderModel>(
//             (e) => OrderModel.fromJson(Map<String, dynamic>.from(e)),
//           )
//           .toList();
//     }

//     return [];
//   }
// }

import 'dart:convert';
import 'package:flutter_application_1/core/storage/token_storage.dart';
import 'package:http/http.dart' as http;

import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/storage/user_storage.dart';
import '../model/order_model.dart';

class OrderService {
 
 Future<OrderModel> createOrder({
  required List<Map<String, dynamic>> items,
  required double totalCost,
}) async {
  // final token = await UserStorage.getToken();
  final token = await TokenStorage.getToken();

  final res = await http.post(
    Uri.parse(ApiEndpoints.orders),
    headers: {
      "Content-Type": "application/json",
      if (token != null && token.isNotEmpty)
        "Authorization": "Bearer $token",
    },
    body: jsonEncode({
      "items": items,
      "totalCost": totalCost,
    }),
  );

  final data = jsonDecode(res.body);

  if (res.statusCode >= 200 && res.statusCode < 300) {
    return OrderModel.fromJson(data); // ✅ IMPORTANT
  }

  throw Exception(data["message"] ?? "Order failed");
}

  Future<List<OrderModel>> getMyOrders() async {
    // final token = await UserStorage.getToken();
    final token = await TokenStorage.getToken();

    final res = await http.get(
      Uri.parse(ApiEndpoints.myOrders),
      headers: {
        "Content-Type": "application/json",
        if (token != null && token.isNotEmpty) "Authorization": "Bearer $token",
      },
    );

    final data = jsonDecode(res.body.isEmpty ? "[]" : res.body);

    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception("Failed to fetch orders (${res.statusCode})");
    }

    if (data is List) {
      return data
          .map<OrderModel>((e) => OrderModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }
    return [];
  }
}
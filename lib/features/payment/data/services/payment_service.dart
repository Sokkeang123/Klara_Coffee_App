import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/storage/user_storage.dart';

class PaymentService {
  Future<Map<String, dynamic>> createPayment({
    required int orderId,
    required String method, // "QR" | "Card" | "Cash"
    required double amount,
  }) async {
    final token = await UserStorage.getToken();

    final res = await http.post(
      Uri.parse(ApiEndpoints.payment),
      headers: {
        "Content-Type": "application/json",
        if (token != null && token.isNotEmpty) "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        "orderId": orderId,
        "method": method,
        "amount": amount,
      }),
    );

    final data = jsonDecode(res.body.isEmpty ? "{}" : res.body);

    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception(data["message"] ?? "Payment create failed (${res.statusCode})");
    }

    return Map<String, dynamic>.from(data);
  }

  Future<void> confirmPayment({required int paymentId}) async {
    final token = await UserStorage.getToken();

    final res = await http.post(
      Uri.parse(ApiEndpoints.paymentConfirm),
      headers: {
        "Content-Type": "application/json",
        if (token != null && token.isNotEmpty) "Authorization": "Bearer $token",
      },
      body: jsonEncode({"paymentId": paymentId}),
    );

    final data = jsonDecode(res.body.isEmpty ? "{}" : res.body);

    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception(data["message"] ?? "Confirm failed (${res.statusCode})");
    }
  }
}
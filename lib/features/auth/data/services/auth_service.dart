import 'package:http/http.dart';

import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/storage/token_storage.dart';
import '../../../../core/storage/user_storage.dart';

class AuthService {
  final ApiClient _client = ApiClient();

  Future<void> login({required String email, required String password}) async {
    final res = await _client.post(ApiEndpoints.login, {
      "email": email,
      "password": password,
    });

    final token = res["token"];
    final user = res["user"];

    if (token is String && token.isNotEmpty) {
      // await TokenStorage.saveToken(token);
      await UserStorage.saveToken(token); // ✅ FIX
    } else {
      throw Exception(res["message"] ?? "Login failed");
    }

    if (user is Map) {
      await UserStorage.saveUser(user.map((k, v) => MapEntry(k.toString(), v)));
    }
  }

  Future<void> signup({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    final res = await _client.post(ApiEndpoints.signup, {
      "name": name,
      "email": email,
      "phone": phone,
      "password": password,
    });

    // optional: save user from signup response
    final user = res["user"];
    if (user is Map) {
      await UserStorage.saveUser(user.map((k, v) => MapEntry(k.toString(), v)));
    }
  }
}
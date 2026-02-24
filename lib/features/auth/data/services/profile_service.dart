import 'package:http/http.dart';

import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/storage/user_storage.dart';

class ProfileService {
  final ApiClient _client = ApiClient();

  Future<void> updateProfile({
    required String name,
    required String email,
    required String phone,
    String? password,
  }) async {
    final body = <String, dynamic>{
      "name": name.trim(),
      "email": email.trim(),
      "phone": phone.trim(),
    };

    if (password != null && password.trim().isNotEmpty) {
      body["password"] = password.trim();
    }

    final res = await _client.put(ApiEndpoints.profile, body, auth: true);

    // ✅ store updated user back for UI next time
    final user = res["user"];
    if (user is Map) {
      await UserStorage.saveUser(
        user.map((k, v) => MapEntry(k.toString(), v)),
      );
    }
  }
}
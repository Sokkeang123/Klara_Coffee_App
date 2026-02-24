import 'user_model.dart';

class AuthResponse {
  final String message;
  final String? token;
  final UserModel? user;

  AuthResponse({required this.message, this.token, this.user});

  factory AuthResponse.fromJson(Map<String, dynamic> json) => AuthResponse(
    message: json["message"] ?? "",
    token: json["token"],
    user: json["user"] != null ? UserModel.fromJson(json["user"]) : null,
  );
}
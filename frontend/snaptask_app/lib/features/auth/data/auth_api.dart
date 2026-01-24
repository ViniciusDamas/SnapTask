import 'package:dio/dio.dart';
import 'package:snaptask_app/features/auth/data/register_models.dart';
import '../../../core/http/api_client.dart';
import '../../../core/auth/token_storage.dart';
import 'login_models.dart';

class AuthApi {
  final Dio _dio;

  AuthApi(ApiClient client) : _dio = client.dio;

  Future<void> register(RegisterRequest req) async {
    try {
      final res = await _dio.post('/auth/register', data: req.toJson());
      final parsed = RegisterRsponse.fromJson(res.data);
      TokenStorage.save(parsed.token);
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw AuthUnauthorizedException();
      }
      throw AuthException(e.message);
    }
  }

  Future<void> login(LoginRequest req) async {
    try {
      final res = await _dio.post('/auth/login', data: req.toJson());
      final parsed = LoginResponse.fromJson(res.data);
      TokenStorage.save(parsed.token);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw AuthUnauthorizedException();
      }
      throw AuthException(e.message);
    }
  }
}

class AuthUnauthorizedException implements Exception {}

class AuthException implements Exception {
  final String? message;
  AuthException(this.message);
}

import 'package:dio/dio.dart';
import 'package:snaptask_app/core/http/api_client.dart';
import 'package:snaptask_app/core/http/exceptions/api_exception.dart';
import 'package:snaptask_app/core/storage/token_storage.dart';
import 'package:snaptask_app/features/auth/data/register_models.dart';
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

  Future<LoginResponse> login(LoginRequest req) async {
    try {
      final res = await _dio.post('/auth/login', data: req.toJson());

      final data = res.data as Map<String, dynamic>;
      return LoginResponse.fromJson(data);
    } on DioException catch (e) {
      final err = e.error;
      if (err is ApiException) throw err;

      throw ApiException(
        statusCode: e.response?.statusCode,
        problem: null,
        rawError: e,
      );
    }
  }
}

class AuthUnauthorizedException implements Exception {}

class AuthException implements Exception {
  final String? message;
  AuthException(this.message);
}

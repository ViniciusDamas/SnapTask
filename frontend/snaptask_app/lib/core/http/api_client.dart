import 'package:dio/dio.dart';
import 'package:snaptask_app/core/http/exceptions/api_exception.dart';
import 'package:snaptask_app/core/http/interceptors/auth_interceptor.dart';
import 'package:snaptask_app/core/http/problem_details.dart';

class ApiClient {
  final Dio dio;

  ApiClient._(this.dio);

  factory ApiClient({required String baseUrl}) {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json,',
        },
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
      ),
    );

    dio.interceptors.add(AuthInterceptor());
    dio.interceptors.add(
      InterceptorsWrapper(
        onError: (e, handler) {
          final apiEx = _mapDioErrorToApiException(e);
          handler.reject(
            DioException(
              requestOptions: e.requestOptions,
              response: e.response,
              type: e.type,
              error: apiEx,
              message: apiEx.message,
            ),
          );
        },
      ),
    );

    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));

    return ApiClient._(dio);
  }

  static ApiException _mapDioErrorToApiException(DioException e) {
    final status = e.response?.statusCode;
    ProblemDetails? problem;

    final data = e.response?.data;

    if (data is Map<String, dynamic>) {
      problem = ProblemDetails.fromJson(data);
    } else if (data is String) {
      problem = ProblemDetails(status: status, title: 'Erro', detail: data);
    } else {
      final isNetwork =
          e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.connectionError;

      if (isNetwork) {
        problem = ProblemDetails(
          status: status,
          title: 'Falha de conexão',
          detail: 'Verifique sua internet e tente novamente.',
        );
      } else {
        problem = ProblemDetails(
          status: status,
          title: 'Erro',
          detail: 'Não foi possível concluir a requisição.',
        );
      }
    }

    return ApiException(statusCode: status, problem: problem, rawError: e);
  }
}

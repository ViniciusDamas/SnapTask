import 'package:snaptask_app/core/http/problem_details.dart';

class ApiException implements Exception {
  final int? statusCode;
  final ProblemDetails? problem;
  final Object? rawError;

  ApiException({
    required this.statusCode,
    required this.problem,
    this.rawError,
  });

  String get message {
    if (problem != null) return problem!.userMessage;
    return 'Falha na requisição.';
  }

  String toDebugString() {
    final t = problem?.traceId;
    return 'ApiException(status=$statusCode, title=${problem?.title}, detail=${problem?.detail}, traceId=$t, raw=$rawError)';
  }
}

import 'package:dio/dio.dart';
import '../../../core/http/api_client.dart';
import 'boards_models.dart';

class BoardsApi {
  final Dio _dio;

  BoardsApi(ApiClient client) : _dio = client.dio;

  Future<List<BoardSummary>> getAll() async {
    final res = await _dio.get('/api/boards');

    final data = res.data;
    if (data is! List) {
      throw BoardsApiException('Resposta inesperada em GET /api/boards');
    }

    return data
        .map((e) => BoardSummary.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<BoardSummary> create(CreateBoardRequest req) async {
    final res = await _dio.post('/api/boards', data: req.toJson());
    return BoardSummary.fromJson(res.data as Map<String, dynamic>);
  }

  Future<void> updateName(String id, UpdateBoardRequest req) async {
    await _dio.put('/api/boards/$id', data: req.toJson());
  }

  Future<void> delete(String id) async {
    await _dio.delete('/api/boards/$id');
  }

  Future<BoardDetails> getById(String id) async {
    final res = await _dio.get('/api/boards/$id');
    return BoardDetails.fromJson(res.data as Map<String, dynamic>);
  }
}

class BoardsApiException implements Exception {
  final String message;
  BoardsApiException(this.message);

  @override
  String toString() => message;
}

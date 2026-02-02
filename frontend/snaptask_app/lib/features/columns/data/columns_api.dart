import 'package:dio/dio.dart';
import 'package:snaptask_app/core/http/api_client.dart';
import 'package:snaptask_app/features/columns/data/columns_models.dart';

class ColumnsApi {
  final Dio _dio;

  ColumnsApi(ApiClient client) : _dio = client.dio;

  Future<ColumnSummary> create(CreateColumnRequest req) async {
    final res = await _dio.post('/api/columns', data: req.toJson());
    return ColumnSummary.fromJson(res.data as Map<String, dynamic>);
  }

  Future<void> updateColumn(String columnId, String newName) async {
    await _dio.put('/api/columns/$columnId', data: {'name': newName});
  }

  Future<void> delete(String columnId) async {
    await _dio.delete('/api/columns/$columnId');
  }
}

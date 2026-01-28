import 'package:dio/dio.dart';
import '../../../core/http/api_client.dart';
import 'boards_models.dart';

class ColumnsApi {
  final Dio _dio;

  ColumnsApi(ApiClient client) : _dio = client.dio;

  Future<ColumnSummary> create(CreateColumnRequest req) async {
    final res = await _dio.post('/api/columns', data: req.toJson());
    return ColumnSummary.fromJson(res.data as Map<String, dynamic>);
  }
}

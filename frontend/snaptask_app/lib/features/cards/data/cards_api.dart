import 'package:dio/dio.dart';
import 'package:snaptask_app/core/http/api_client.dart';
import 'package:snaptask_app/features/cards/data/cards_models.dart';

class CardsApi {
  final Dio _dio;

  CardsApi(ApiClient client) : _dio = client.dio;

  Future<CardSummary> create(CreateCardRequest req) async {
    final res = await _dio.post('/api/cards', data: req.toJson());
    return CardSummary.fromJson(res.data as Map<String, dynamic>);
  }
}

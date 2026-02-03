import 'package:dio/dio.dart';
import 'package:snaptask_app/core/http/api_client.dart';
import 'package:snaptask_app/features/cards/data/cards_models.dart';
import 'package:snaptask_app/features/cards/ui/card_status.dart';

class CardsApi {
  final Dio _dio;

  CardsApi(ApiClient client) : _dio = client.dio;

  Future<CardSummary> create(CreateCardRequest req) async {
    final res = await _dio.post('/api/cards', data: req.toJson());
    return CardSummary.fromJson(res.data as Map<String, dynamic>);
  }

  Future<void> update(String cardId, UpdateCardRequest req) async {
    await _dio.patch('/api/cards/$cardId', data: req.toJson());
  }

  Future<void> updateStatus(String cardId, CardStatus status) async {
    await _dio.patch('/api/cards/$cardId/status', data: {'status': status.name});
  }

  Future<void> delete(String cardId) async {
    await _dio.delete('/api/cards/$cardId');
  }
}

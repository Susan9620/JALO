import 'package:dio/dio.dart';
import '../env.dart';
import '../models/jalo_card.dart';

class SyncService {
  final Dio _dio = Dio(BaseOptions(baseUrl: baseUrl));

  Future<List<JaloCard>> fetchUserCards(String deviceId) async {
    final res = await _dio.get('/api/cards/user', queryParameters: {'deviceId': deviceId});
    final data = (res.data as List).cast<Map<String, dynamic>>();
    return data.map(JaloCard.fromMap).toList();
  }

  Future<void> createCard(JaloCard card) async {
    await _dio.post('/api/cards/user', data: card.toMap());
  }

  Future<void> updateCard(JaloCard card) async {
    await _dio.patch('/api/cards/user/${card.id}', data: card.toMap());
  }

  Future<void> deleteCard(String id, String deviceId) async {
    await _dio.delete('/api/cards/user/$id', data: {'deviceId': deviceId});
  }
}

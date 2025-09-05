import 'package:flutter_test/flutter_test.dart';
import 'package:jalo/models/jalo_card.dart';

void main() {
  test('serializes to map and back', () {
    final card = JaloCard(
      id: '1',
      text: 'hola',
      category: 'juegos',
      emoji: '🎮',
      isUser: true,
      forAll: true,
      createdAt: DateTime.utc(2023),
      deviceId: 'dev',
    );
    final map = card.toMap();
    final from = JaloCard.fromMap(map);
    expect(from.text, 'hola');
    expect(from.category, 'juegos');
  });

  test('json roundtrip', () {
    final card = JaloCard(
      id: '2',
      text: 'adios',
      category: 'juegos',
      emoji: '🎮',
      isUser: false,
      forAll: false,
      createdAt: DateTime.utc(2023),
      deviceId: 'dev',
    );
    final json = card.toJson();
    final from = JaloCard.fromJson(json);
    expect(from.id, '2');
    expect(from.isUser, false);
  });
}

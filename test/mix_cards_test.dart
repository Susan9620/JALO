import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:jalo/features/cards/providers/cards_provider.dart';
import 'package:jalo/services/sync_service.dart';
import 'package:mockito/mockito.dart';

class MockSyncService extends Mock implements SyncService {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    await Hive.initFlutter();
  });

  test('deck combines official and user cards', () async {
    final box = await Hive.openBox('cards_test');
    final provider = CardsProvider(box, 'dev', MockSyncService());
    await Future.delayed(Duration.zero);
    await provider.addCard(text: 'user', category: 'juegos', emoji: '🎮');
    final deck = provider.deckForCategory('juegos');
    final hasOfficial = deck.any((c) => !c.isUser);
    final hasUser = deck.any((c) => c.isUser);
    expect(hasOfficial, true);
    expect(hasUser, true);
  });
}

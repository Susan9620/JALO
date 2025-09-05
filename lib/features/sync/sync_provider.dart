import 'package:flutter/foundation.dart';

import '../../models/jalo_card.dart';
import '../../services/sync_service.dart';
import '../cards/providers/cards_provider.dart';

class SyncProvider extends ChangeNotifier {
  final CardsProvider _cards;
  final SyncService _service;
  final String deviceId;

  SyncProvider(this._cards, this._service, this.deviceId);

  Future<void> sync() async {
    try {
      final remote = await _service.fetchUserCards(deviceId);
      for (final card in remote) {
        await _cards.editCard(card); // ensure exists locally
      }
      await _cards.syncPending();
    } catch (_) {}
  }
}

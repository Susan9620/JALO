import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

import '../../../data/seed_official_cards.dart';
import '../../../models/jalo_card.dart';
import '../../../services/sync_service.dart';

class CardsProvider extends ChangeNotifier {
  final Box _box;
  final String deviceId;
  final SyncService _service;

  final _uuid = const Uuid();

  List<JaloCard> _userCards = [];
  List<JaloCard> _official = [];

  CardsProvider(this._box, this.deviceId, this._service) {
    _load();
  }

  Future<void> _load() async {
    _official = officialCards(deviceId);
    _userCards = _box.values.map((e) => JaloCard.fromMap(Map<String, dynamic>.from(e))).toList();
    notifyListeners();
  }

  List<JaloCard> deckForCategory(String category) {
    final cards = [
      ..._official.where((c) => c.category == category),
      ..._userCards.where((c) => c.category == category),
    ];
    cards.shuffle(Random());
    return cards;
  }

  Future<void> addCard({
    required String text,
    required String category,
    required String emoji,
    bool forAll = true,
  }) async {
    final card = JaloCard(
      id: _uuid.v4(),
      text: text,
      category: category,
      emoji: emoji,
      isUser: true,
      forAll: forAll,
      createdAt: DateTime.now(),
      deviceId: deviceId,
      pendingSync: false,
    );
    _userCards.add(card);
    await _box.put(card.id, card.toMap());
    try {
      await _service.createCard(card);
    } catch (_) {
      await _box.put(card.id, card.copyWith(pendingSync: true).toMap());
    }
    notifyListeners();
  }

  Future<void> editCard(JaloCard card) async {
    _userCards = _userCards.map((c) => c.id == card.id ? card : c).toList();
    await _box.put(card.id, card.toMap());
    try {
      await _service.updateCard(card);
    } catch (_) {
      await _box.put(card.id, card.copyWith(pendingSync: true).toMap());
    }
    notifyListeners();
  }

  Future<void> deleteCard(JaloCard card) async {
    _userCards.removeWhere((c) => c.id == card.id);
    await _box.delete(card.id);
    try {
      await _service.deleteCard(card.id, deviceId);
    } catch (_) {
      // store a tombstone? ignored for simplicity
    }
    notifyListeners();
  }

  Future<void> syncPending() async {
    for (var card in _box.values.map((e) => JaloCard.fromMap(Map<String, dynamic>.from(e)))) {
      if (card.pendingSync) {
        try {
          await _service.createCard(card);
          await _box.put(card.id, card.copyWith(pendingSync: false).toMap());
        } catch (_) {}
      }
    }
  }
}

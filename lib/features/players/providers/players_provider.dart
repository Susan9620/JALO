import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

class PlayersProvider extends ChangeNotifier {
  final Box _box;
  List<String> _players = [];

  PlayersProvider(this._box) {
    _players = (_box.get('list') as List?)?.cast<String>() ?? [];
  }

  List<String> get players => List.unmodifiable(_players);

  void addPlayer(String name) {
    _players.add(name);
    _box.put('list', _players);
    notifyListeners();
  }

  void removePlayer(String name) {
    _players.remove(name);
    _box.put('list', _players);
    notifyListeners();
  }
}

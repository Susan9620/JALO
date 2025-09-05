import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/players_provider.dart';

class PlayersScreen extends StatefulWidget {
  const PlayersScreen({super.key});

  @override
  State<PlayersScreen> createState() => _PlayersScreenState();
}

class _PlayersScreenState extends State<PlayersScreen> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PlayersProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('Jugadores')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: const InputDecoration(hintText: 'Nombre'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    if (controller.text.isNotEmpty) {
                      provider.addPlayer(controller.text);
                      controller.clear();
                    }
                  },
                )
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                for (final p in provider.players)
                  ListTile(
                    title: Text(p),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => provider.removePlayer(p),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

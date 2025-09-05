import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../players/providers/players_provider.dart';
import '../providers/cards_provider.dart';

class CardScreen extends StatefulWidget {
  final String category;
  const CardScreen(this.category, {super.key});

  @override
  State<CardScreen> createState() => _CardScreenState();
}

class _CardScreenState extends State<CardScreen> {
  int index = 0;
  late List deck;

  @override
  void initState() {
    super.initState();
    final cards = context.read<CardsProvider>();
    deck = cards.deckForCategory(widget.category);
  }

  void _next() {
    setState(() => index = (index + 1) % deck.length);
  }

  void _prev() {
    setState(() => index = (index - 1 + deck.length) % deck.length);
  }

  @override
  Widget build(BuildContext context) {
    if (deck.isEmpty) {
      return Scaffold(appBar: AppBar(), body: const Center(child: Text('Sin cartas')));
    }
    final card = deck[index];
    final players = context.watch<PlayersProvider>().players;
    return Scaffold(
      appBar: AppBar(title: Text(widget.category)),
      body: GestureDetector(
        onHorizontalDragEnd: (d) => d.primaryVelocity! < 0 ? _next() : _prev(),
        child: Center(
          child: Card(
            color: Colors.white10,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(card.emoji, style: const TextStyle(fontSize: 48)),
                  const SizedBox(height: 16),
                  Text(card.text, style: const TextStyle(fontSize: 22), textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  Text(card.forAll ? 'Para todos' : 'Por turno'),
                  if (!card.forAll && players.isNotEmpty)
                    Text('Le toca a: ${players[index % players.length]}'),
                  const SizedBox(height: 16),
                  ElevatedButton(onPressed: _next, child: const Text('Siguiente')),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

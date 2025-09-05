import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Category {
  final String id;
  final String name;
  final Color color;
  final String emoji;
  Category(this.id, this.name, this.color, this.emoji);
}

final categories = [
  Category('yo-nunca', 'Yo Nunca', Colors.purple, '🙅'),
  Category('verdad-reto', 'Verdad o Reto', Colors.red, '❓'),
  Category('juegos', 'Juegos', Colors.blue, '🎮'),
  Category('simon-dice', 'Simón dice', Colors.green, '🗣️'),
  Category('mi-barquito', 'Mi Barquito', Colors.yellow, '⛵'),
];

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Categorías')),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16),
        children: [
          for (final c in categories)
            GestureDetector(
              onTap: () => context.go('/card/${c.id}'),
              child: Card(
                color: c.color,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [Text(c.emoji, style: const TextStyle(fontSize: 40)), const SizedBox(height: 8), Text(c.name)],
                  ),
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/create'),
        child: const Icon(Icons.add),
      ),
    );
  }
}

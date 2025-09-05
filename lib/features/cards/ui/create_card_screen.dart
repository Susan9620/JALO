import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../providers/cards_provider.dart';
import 'categories_screen.dart';

class CreateCardScreen extends StatefulWidget {
  const CreateCardScreen({super.key});

  @override
  State<CreateCardScreen> createState() => _CreateCardScreenState();
}

class _CreateCardScreenState extends State<CreateCardScreen> {
  final _formKey = GlobalKey<FormState>();
  String category = categories.first.id;
  String emoji = '🎲';
  String text = '';
  bool forAll = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crear carta')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                maxLength: 200,
                decoration: const InputDecoration(labelText: 'Texto'),
                validator: (v) => v == null || v.trim().split(' ').length < 1 ? 'Ingresa texto' : null,
                onSaved: (v) => text = v!.trim(),
              ),
              DropdownButtonFormField(
                value: category,
                items: [
                  for (final c in categories)
                    DropdownMenuItem(value: c.id, child: Text(c.name)),
                ],
                onChanged: (v) => setState(() => category = v as String),
                decoration: const InputDecoration(labelText: 'Categoría'),
              ),
              TextFormField(
                initialValue: emoji,
                decoration: const InputDecoration(labelText: 'Emoji'),
                onChanged: (v) => emoji = v,
              ),
              SwitchListTile(
                title: const Text('Para todos'),
                value: forAll,
                onChanged: (v) => setState(() => forAll = v),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    await context.read<CardsProvider>().addCard(
                          text: text,
                          category: category,
                          emoji: emoji,
                          forAll: forAll,
                        );
                    if (context.mounted) context.pop();
                  }
                },
                child: const Text('Guardar'),
              )
            ],
          ),
        ),
      ),
    );
  }
}

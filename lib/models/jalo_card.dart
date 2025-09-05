import 'dart:convert';

class JaloCard {
  final String id;
  final String text;
  final String category; // yo-nunca | verdad-reto | juegos | simon-dice | mi-barquito
  final String emoji;
  final bool isUser;
  final bool forAll;
  final DateTime createdAt;
  final String deviceId;
  final bool pendingSync;

  JaloCard({
    required this.id,
    required this.text,
    required this.category,
    required this.emoji,
    required this.isUser,
    required this.forAll,
    required this.createdAt,
    required this.deviceId,
    this.pendingSync = false,
  });

  JaloCard copyWith({
    String? id,
    String? text,
    String? category,
    String? emoji,
    bool? isUser,
    bool? forAll,
    DateTime? createdAt,
    String? deviceId,
    bool? pendingSync,
  }) {
    return JaloCard(
      id: id ?? this.id,
      text: text ?? this.text,
      category: category ?? this.category,
      emoji: emoji ?? this.emoji,
      isUser: isUser ?? this.isUser,
      forAll: forAll ?? this.forAll,
      createdAt: createdAt ?? this.createdAt,
      deviceId: deviceId ?? this.deviceId,
      pendingSync: pendingSync ?? this.pendingSync,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'category': category,
      'emoji': emoji,
      'isUser': isUser,
      'forAll': forAll,
      'createdAt': createdAt.toIso8601String(),
      'deviceId': deviceId,
      'pendingSync': pendingSync,
    };
  }

  factory JaloCard.fromMap(Map<String, dynamic> map) {
    return JaloCard(
      id: map['id'] as String,
      text: map['text'] as String,
      category: map['category'] as String,
      emoji: map['emoji'] as String,
      isUser: map['isUser'] as bool? ?? false,
      forAll: map['forAll'] as bool? ?? false,
      createdAt: DateTime.parse(map['createdAt'] as String),
      deviceId: map['deviceId'] as String? ?? '',
      pendingSync: map['pendingSync'] as bool? ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory JaloCard.fromJson(String source) => JaloCard.fromMap(json.decode(source));
}

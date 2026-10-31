
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum PlantCategory {
  tropical,
  succulent,
  flowering,
  foliage,
}

class Plant {
  final String id;
  final String name;
  final String subtitle;
  final PlantCategory category;
  final String? description;
  final String icon;
  final Color color;

  const Plant({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.category,
    required this.icon,
    required this.color,
    this.description,
  });

  // Получаем растение из документа Firestore.
  factory Plant.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data()!;

    return Plant(
      id: doc.id,
      name: data['name'] as String,
      subtitle: data['subtitle'] as String,
      category: PlantCategory.values.byName(
        data['category'] as String,
      ),
      description: data['description'] as String?,
      icon: data['icon'] as String,
      color: Color(
        int.parse('FF${data['color']}', radix: 16),
      ),
    );
  }

  // Подготавливаем растение для сохранения в Firestore.
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'subtitle': subtitle,
      'category': category.name,
      'description': description ?? '',
      'icon': icon,
      'color': color.toARGB32().toRadixString(16).substring(2).toUpperCase(),
    };
  }
}

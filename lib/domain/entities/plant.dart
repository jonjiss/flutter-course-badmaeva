
import 'package:flutter/material.dart';

enum PlantCategory {
  tropical,
  succulent,
  flowering,
  foliage,
}

class Plant {
  final int id;
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

  // Получаем растение из JSON, который пришёл с сервера.
  factory Plant.fromJson(Map<String, dynamic> json) {
    return Plant(
      id: int.parse(json['id'].toString()),
      name: json['name'] as String,
      subtitle: json['subtitle'] as String,
      category: PlantCategory.values.byName(json['category'] as String),
      description: json['description'] as String?,
      icon: json['icon'] as String,
      color: Color(
        int.parse('FF${json['color']}', radix: 16),
      ),
    );
  }

  // Подготавливаем растение для отправки на сервер.
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

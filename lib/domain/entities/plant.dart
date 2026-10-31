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
}
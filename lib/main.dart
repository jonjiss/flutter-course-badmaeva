import 'package:flutter/material.dart';

import 'ui/screens/catalog_screen.dart';

void main() {
  runApp(const PlantCatalogApp());
}

class PlantCatalogApp extends StatelessWidget {
  const PlantCatalogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Каталог растений',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
        ),
        useMaterial3: true,
      ),
      home: const CatalogScreen(),
    );
  }
}
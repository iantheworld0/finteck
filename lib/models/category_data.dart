import 'package:flutter/material.dart';


class CategoryItem {
  final String name;
  final IconData icon;
  final Color color; 

  CategoryItem(this.name, this.icon, this.color);
}

final List<CategoryItem> addCategories = [
  CategoryItem("Nourriture", Icons.fastfood, const Color(0xFFFFB74D)),
  CategoryItem("Transport", Icons.directions_bus, const Color(0xFF5C6BC0)),
  CategoryItem("Loyer", Icons.home, const Color(0xFFEF5350)),
  CategoryItem("Santé", Icons.local_hospital, const Color(0xFF26A69A)),
  CategoryItem("Loisirs", Icons.movie, const Color(0xFFAB47BC)),
  CategoryItem("Factures", Icons.receipt_long, const Color(0xFF78909C)),
  CategoryItem("Divers", Icons.category, const Color(0xFF8D6E63)),
];
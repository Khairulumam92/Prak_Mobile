import 'package:flutter/material.dart';

class Product {
  final String id;
  final String name;
  final int price;
  final String category;
  final Color color;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
    required this.color,
  });
}

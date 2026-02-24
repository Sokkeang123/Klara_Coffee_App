import 'package:flutter/material.dart';

class FavoriteItem {
  final String name;
  final String price;
  final String imagePath;

  FavoriteItem({
    required this.name,
    required this.price,
    required this.imagePath,
  });
}

class FavoriteProvider extends ChangeNotifier {
  final List<FavoriteItem> _items = [];

  List<FavoriteItem> get items => _items;

  bool isFavorite(String name) {
    return _items.any((e) => e.name == name);
  }

  void toggleFavorite(FavoriteItem item) {
    final exists = _items.any((e) => e.name == item.name);

    if (exists) {
      _items.removeWhere((e) => e.name == item.name);
    } else {
      _items.add(item);
    }

    notifyListeners();
  }
}

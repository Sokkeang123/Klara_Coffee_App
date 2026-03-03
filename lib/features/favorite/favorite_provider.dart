import 'package:flutter/material.dart';

class FavoriteItem {
  final int menuId; // ✅ CHANGED: add unique id
  final String name;
  final String price;
  final String imagePath;

  FavoriteItem({
    required this.menuId, // ✅ CHANGED
    required this.name,
    required this.price,
    required this.imagePath,
  });
}

class FavoriteProvider extends ChangeNotifier {
  final List<FavoriteItem> _items = [];

  List<FavoriteItem> get items => List.unmodifiable(_items); // ✅ CHANGED (safe)

  bool isFavorite(int menuId) { // ✅ CHANGED
    return _items.any((e) => e.menuId == menuId);
  }

  void toggleFavorite(FavoriteItem item) {
    final index = _items.indexWhere((e) => e.menuId == item.menuId); // ✅ CHANGED

    if (index != -1) {
      _items.removeAt(index);
    } else {
      _items.add(item);
    }

    notifyListeners();
  }

  void removeById(int menuId) { // ✅ NEW
    _items.removeWhere((e) => e.menuId == menuId);
    notifyListeners();
  }
}
// import 'package:flutter/foundation.dart';

// class CartItem {
//   final String name;
//   final String imagePath;
//   final double unitPrice;

//   // customizations
//   final String size; // small / medium / large
//   final String milk;
//   final bool whippedCream;
//   final String syrup;

//   int qty;

//   CartItem({
//     required this.name,
//     required this.imagePath,
//     required this.unitPrice,
//     required this.size,
//     required this.milk,
//     required this.whippedCream,
//     required this.syrup,
//     this.qty = 1,
//   });

//   double get total => unitPrice * qty;

//   /// used to merge same item (same drink + same options)
//   String get key =>
//       "$name|$size|$milk|$whippedCream|$syrup|$unitPrice|$imagePath";
// }

// class CartProvider extends ChangeNotifier {
//   final List<CartItem> _items = [];

//   List<CartItem> get items => List.unmodifiable(_items);

//   void addItem(CartItem item) {
//     final index = _items.indexWhere((x) => x.key == item.key);
//     if (index != -1) {
//       _items[index].qty += item.qty;
//     } else {
//       _items.add(item);
//     }
//     notifyListeners();
//   }

//   void increaseQty(int index) {
//     if (index < 0 || index >= _items.length) return;
//     _items[index].qty++;
//     notifyListeners();
//   }

//   void decreaseQty(int index) {
//     if (index < 0 || index >= _items.length) return;
//     if (_items[index].qty > 1) {
//       _items[index].qty--;
//       notifyListeners();
//     }
//   }

//   void removeAt(int index) {
//     if (index < 0 || index >= _items.length) return;
//     _items.removeAt(index);
//     notifyListeners();
//   }

//   void clear() {
//     _items.clear();
//     notifyListeners();
//   }

//   double get totalPrice {
//     double sum = 0;
//     for (final i in _items) {
//       sum += i.total;
//     }
//     return sum;
//   }
// }


import 'package:flutter/foundation.dart';

class CartItem {
  final int menuId;
  final String name;
  final String imagePath;
  final double unitPrice;

  final String size;
  final String milk;
  final bool whippedCream;
  final String syrup;

  int qty;

  CartItem({
    required this.menuId,
    required this.name,
    required this.imagePath,
    required this.unitPrice,
    required this.size,
    required this.milk,
    required this.whippedCream,
    required this.syrup,
    this.qty = 1,
  });

  double get total => unitPrice * qty;

  String get key =>
      "$menuId|$name|$size|$milk|$whippedCream|$syrup|$unitPrice|$imagePath";
}

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  void addItem(CartItem item) {
    final index = _items.indexWhere((x) => x.key == item.key);
    if (index != -1) {
      _items[index].qty += item.qty;
    } else {
      _items.add(item);
    }
    notifyListeners();
  }

  void increaseQty(int index) {
    if (index < 0 || index >= _items.length) return;
    _items[index].qty++;
    notifyListeners();
  }

  void decreaseQty(int index) {
    if (index < 0 || index >= _items.length) return;
    if (_items[index].qty > 1) {
      _items[index].qty--;
      notifyListeners();
    }
  }

  void removeAt(int index) {
    if (index < 0 || index >= _items.length) return;
    _items.removeAt(index);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }

  double get totalPrice {
    double sum = 0;
    for (final i in _items) {
      sum += i.total;
    }
    return sum;
  }

  // ✅ NEW CODE: total quantity (badge)
  int get totalQty {
    int q = 0;
    for (final i in _items) {
      q += i.qty;
    }
    return q;
  }

  // ✅ NEW CODE: convert cart to order items for NodeJS API
  List<Map<String, dynamic>> toOrderItems() {
    return _items
        .map((i) => {
              "menuId": i.menuId,
              "quantity": i.qty,
            })
        .toList();
  }

  // ✅ NEW CODE (optional): remove all items for one menuId
  void removeByMenuId(int menuId) {
    _items.removeWhere((x) => x.menuId == menuId);
    notifyListeners();
  }
}
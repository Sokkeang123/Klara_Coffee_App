// class MenuItemModel {
//   final int id;
//   final String name;
//   final String? description;
//   final double price;
//   final String? imageUrl;

//   MenuItemModel({
//     required this.id,
//     required this.name,
//     required this.price,
//     this.description,
//     this.imageUrl,
//   });

//   factory MenuItemModel.fromJson(Map<String, dynamic> json) {
//     return MenuItemModel(
//       id: (json["id"] as num).toInt(),
//       name: (json["name"] ?? "").toString(),
//       description: json["description"]?.toString(),
//       price: (json["price"] is num)
//           ? (json["price"] as num).toDouble()
//           : double.tryParse(json["price"].toString()) ?? 0.0,
//       imageUrl: json["imageUrl"]?.toString(),
//     );
//   }
// }


class MenuItemModel {
  final int id;
  final String name;
  final String? description;
  final double price;
  final String? imageUrl;

  MenuItemModel({
    required this.id,
    required this.name,
    required this.price,
    this.description,
    this.imageUrl,
  });

  static int _toInt(dynamic v) {
    if (v == null) return 0;
    if (v is int) return v;
    if (v is num) return v.toInt();
    return int.tryParse(v.toString()) ?? 0;
  }

  static double _toDouble(dynamic v) {
    if (v == null) return 0.0;
    if (v is double) return v;
    if (v is int) return v.toDouble();
    if (v is num) return v.toDouble();
    return double.tryParse(v.toString()) ?? 0.0;
  }

  factory MenuItemModel.fromJson(Map<String, dynamic> json) {
    return MenuItemModel(
      id: _toInt(json["id"]), // ✅ FIXED (no crash)
      name: (json["name"] ?? "").toString(),
      description: json["description"]?.toString(),
      price: _toDouble(json["price"]), // ✅ cleaner + safe
      imageUrl: json["imageUrl"]?.toString(),
    );
  }
}
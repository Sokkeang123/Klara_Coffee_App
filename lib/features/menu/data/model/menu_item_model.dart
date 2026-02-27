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

  factory MenuItemModel.fromJson(Map<String, dynamic> json) {
    return MenuItemModel(
      id: (json["id"] as num).toInt(),
      name: (json["name"] ?? "").toString(),
      description: json["description"]?.toString(),
      price: (json["price"] is num)
          ? (json["price"] as num).toDouble()
          : double.tryParse(json["price"].toString()) ?? 0.0,
      imageUrl: json["imageUrl"]?.toString(),
    );
  }
}
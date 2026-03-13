class OrderModel {
  final int id;
  final String status;
  final double totalCost;
  final DateTime createdAt;
  final List<OrderItemModel> items; // ✅ never null

  OrderModel({
    required this.id,
    required this.status,
    required this.totalCost,
    required this.createdAt,
    List<OrderItemModel>? items,
  }) : items = items ?? const [];

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    // ✅ accept many possible keys from sequelize
    final rawItems =
        json["items"] ?? json["OrderItems"] ?? json["orderItems"] ?? [];

    final items = (rawItems is List)
        ? rawItems
              .where((e) => e != null)
              .map((e) => OrderItemModel.fromJson(Map<String, dynamic>.from(e)))
              .toList()
        : <OrderItemModel>[];

    return OrderModel(
      id: (json["id"] as num).toInt(),
      status: (json["status"] ?? "").toString(),
      totalCost: _toDouble(json["totalCost"]),
      createdAt:
          DateTime.tryParse(json["createdAt"]?.toString() ?? "") ??
          DateTime.now(),
      items: items,
    );
  }

  static double _toDouble(dynamic v) {
    if (v is num) return v.toDouble();
    return double.tryParse(v?.toString() ?? "") ?? 0.0;
  }
}

class OrderItemModel {
  final int quantity;
  final MenuModel? menu;

  OrderItemModel({required this.quantity, this.menu});

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    final menuJson = json["menu"] ?? json["Menu"];
    return OrderItemModel(
      quantity: (json["quantity"] as num?)?.toInt() ?? 0,
      menu: (menuJson is Map)
          ? MenuModel.fromJson(Map<String, dynamic>.from(menuJson))
          : null,
    );
  }
}

class MenuModel {
  final String? imageUrl;

  MenuModel({this.imageUrl});

  factory MenuModel.fromJson(Map<String, dynamic> json) {
    return MenuModel(imageUrl: json["imageUrl"]?.toString());
  }
}

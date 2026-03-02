// class OrderModel {
//   final int id;
//   final String status;
//   final double totalCost;
//   final DateTime createdAt;

//   OrderModel({
//     required this.id,
//     required this.status,
//     required this.totalCost,
//     required this.createdAt,
//   });

//   factory OrderModel.fromJson(Map<String, dynamic> json) {
//     return OrderModel(
//       id: json["id"],
//       status: (json["status"] ?? "").toString(),
//       totalCost: (json["totalCost"] as num).toDouble(),
//       createdAt: DateTime.parse(json["createdAt"]),
//     );
//   }
// }

class OrderModel {
  final int id;
  final String status;
  final double totalCost;
  final DateTime createdAt;

  OrderModel({
    required this.id,
    required this.status,
    required this.totalCost,
    required this.createdAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json["id"],
      status: (json["status"] ?? "").toString(),
      totalCost: (json["totalCost"] as num).toDouble(),
      createdAt: DateTime.parse(json["createdAt"]),
    );
  }
}
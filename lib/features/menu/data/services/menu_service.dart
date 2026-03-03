// import '../../../../core/constants/api_endpoints.dart';
// import '../../../../core/network/api_client.dart';
// import '../model/menu_item_model.dart';

// class MenuService {
//   final ApiClient _client = ApiClient();

//   Future<List<MenuItemModel>> getMenus() async {
//     final res = await _client.get(ApiEndpoints.menus, auth: true);

//     if (res is List) {
//       return res
//           .map<MenuItemModel>(
//             (e) => MenuItemModel.fromJson(Map<String, dynamic>.from(e)),
//           )
//           .toList();
//     }

//     return [];
//   }
// }


import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/api_client.dart';
import '../model/menu_item_model.dart';

class MenuService {
  final ApiClient _client = ApiClient();

  Future<List<MenuItemModel>> getMenus() async {
    final res = await _client.get(ApiEndpoints.menus, auth: true);

    // ✅ case 1: API returns a list directly
    if (res is List) {
      return res
          .map((e) => MenuItemModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }

    // ✅ case 2: API returns {payload:[...]} or {data:[...]} or {items:[...]}
    if (res is Map) {
      final list = res["payload"] ?? res["data"] ?? res["items"];
      if (list is List) {
        return list
            .map((e) => MenuItemModel.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      }
    }

    return [];
  }
}
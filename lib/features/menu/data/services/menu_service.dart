import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/api_client.dart';
import '../model/menu_item_model.dart';

class MenuService {
  final ApiClient _client = ApiClient();

  Future<List<MenuItemModel>> getMenus() async {
    final res = await _client.get(ApiEndpoints.menus, auth: true);

    if (res is List) {
      return res
          .map<MenuItemModel>(
            (e) => MenuItemModel.fromJson(Map<String, dynamic>.from(e)),
          )
          .toList();
    }

    return [];
  }
}

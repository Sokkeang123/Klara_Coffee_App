import 'package:flutter/material.dart';
import '../data/model/menu_item_model.dart';
import '../data/services/menu_service.dart';

class MenuProvider extends ChangeNotifier {
  final MenuService _service = MenuService();

  bool loading = false;
  String? error;
  List<MenuItemModel> menus = [];

  Future<void> fetchMenus() async {
    loading = true;
    error = null;
    notifyListeners();

    try {
      menus = await _service.getMenus();
    } catch (e) {
      error = e.toString().replaceAll("Exception: ", "");
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}
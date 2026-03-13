// import 'package:flutter/material.dart';

// class MenuScreen extends StatelessWidget {
//   const MenuScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Menu')),
//       body: ListView(
//         padding: const EdgeInsets.all(16),
//         children: const [
//           MenuItem(name: 'Ice Milk Coffee', price: '\$1.5'),
//           MenuItem(name: 'Black Tea', price: '\$1.5'),
//           MenuItem(name: 'Ice Black', price: '\$1.5'),
//         ],
//       ),
//     );
//   }
// }

// class MenuItem extends StatelessWidget {
//   final String name;
//   final String price;

//   const MenuItem({required this.name, required this.price, super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: const EdgeInsets.symmetric(vertical: 8),
//       child: ListTile(
//         title: Text(name),
//         subtitle: Text(price),
//         trailing: IconButton(
//           icon: const Icon(Icons.add_circle_outline),
//           onPressed: () {},
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/menu/data/model/menu_item_model.dart';
import 'package:provider/provider.dart';

import 'package:flutter_application_1/features/cart/cart_provider.dart';
// import '../data/services/menu_service.dart';
// import '../data/model/menu_item_model.dart';
import 'data/services/menu_service.dart';

import '../../../../core/constants/api_endpoints.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class MenuCustomizeSheet extends StatefulWidget {
  final int menuId;
  final String name;
  final double unitPrice;
  final String imageUrl;

  const MenuCustomizeSheet({
    super.key,
    required this.menuId,
    required this.name,
    required this.unitPrice,
    required this.imageUrl,
  });

  @override
  State<MenuCustomizeSheet> createState() => _MenuCustomizeSheetState();
}

class _MenuCustomizeSheetState extends State<MenuCustomizeSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      color: Colors.white,
      child: const Center(child: Text("Customize Sheet")),
    );
  }
}

class _MenuScreenState extends State<MenuScreen> {
  final MenuService _menuService = MenuService();
  late Future<List<MenuItemModel>> _future;

  @override
  void initState() {
    super.initState();
    _future = _menuService.getMenus();
  }

  @override
  Widget build(BuildContext context) {
    final cartCount = context.watch<CartProvider>().items.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Menu"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 14),
            child: Center(child: Text("Cart: $cartCount")),
          ),
        ],
      ),
      body: FutureBuilder<List<MenuItemModel>>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(child: Text("Error: ${snap.error}"));
          }

          final menus = snap.data ?? [];
          if (menus.isEmpty) return const Center(child: Text("No menu items"));

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: menus.length,
            itemBuilder: (context, index) {
              final m = menus[index];

              // ✅ adjust field names if your model differs
              final int menuId = m.id; // must exist in MenuItemModel
              final String name = m.name;
              final double price = m.price.toDouble();

              // backend gives imageUrl like "/uploads/menus/xxx.jpg"
              final String imageUrl = (m.imageUrl ?? "");

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: SizedBox(
                      width: 52,
                      height: 52,
                      // child: imageUrl.isEmpty
                      //     ? const Icon(Icons.local_cafe)
                      //     : Image.network(
                      //         "${ApiEndpoints.baseUrl}$imageUrl",
                      //         fit: BoxFit.cover,
                      //         errorBuilder: (_, __, ___) => const Icon(Icons.local_cafe),
                      //       ),
                      child: imageUrl.isEmpty
                          ? const Icon(Icons.local_cafe)
                          : Image.network(
                              imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                                  const Icon(Icons.local_cafe),
                            ),
                    ),
                  ),
                  title: Text(name),
                  subtitle: Text("\$${price.toStringAsFixed(2)}"),
                  trailing: IconButton(
                    icon: const Icon(Icons.add_circle_outline),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (_) => MenuCustomizeSheet(
                          menuId: menuId,
                          name: name,
                          unitPrice: price,
                          imageUrl: imageUrl,
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

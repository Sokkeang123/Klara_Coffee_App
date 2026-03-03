import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/api_endpoints.dart';
import 'package:flutter_application_1/core/utils/safe_parse.dart';
import 'package:flutter_application_1/features/favorite/favorite_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/features/coffeeDetail/coffee_detail_screen.dart';
import 'package:flutter_application_1/features/cart/cart_screen.dart';
import 'package:flutter_application_1/features/cart/cart_provider.dart';
import 'package:flutter_application_1/components/bottom_nav_bar.dart';
import 'package:flutter_application_1/features/auth/screens/edit_profile_screen.dart';
import 'package:flutter_application_1/features/menu/provider/menu_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<MenuProvider>().fetchMenus());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDEBDB), // Warm Klara Café Background
      body: SafeArea(
        child: IndexedStack(
          index: _selectedIndex,
          children: [
            _buildHomeContent(),
            _buildMenuContent(), // Menu tab
            // const Center(child: Text('Favorites')),
            const FavoriteScreen(),
            const CartScreen(),
            const EditProfileScreen(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() => _selectedIndex = index);
        },
      ),
    );
  }

  // ✅ HOME TAB (UI SAME, DATA FROM API)
  Widget _buildHomeContent() {
    return Consumer<MenuProvider>(
      builder: (context, menuProv, _) {
        if (menuProv.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (menuProv.error != null) {
          return Center(child: Text(menuProv.error!));
        }

        if (menuProv.menus.isEmpty) {
          return const Center(child: Text("No menu items"));
        }

        // ✅ Convert DB menus -> your old UI Map (name/price/image)
        final apiItems = menuProv.menus.map<Map<String, dynamic>>((m) {
          final price = m.price.toStringAsFixed(2);
          return {
            "id": m.id,
            "name": m.name,
            "price": "\$$price",
            // keep old UI image (do not change UI)
            "image": "assets/images/matcha.png",
          };
        }).toList();

        // ✅ Split into 2 sections (keep UI same)
        final dailySpecials = apiItems.take(6).toList(); // horizontal list
        final favorites = apiItems; // vertical list

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Center(
                child: Text(
                  'Klara Kafé L’D',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Good Morning ☀️',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),

              // Search Bar (same)
              TextField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: 'Search your coffee...',
                  filled: true,
                  fillColor: const Color(0xFFEBE3D9),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Promo Banner (same) - if it fails on web, it’s internet permission/cors, UI still same
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  '../../../assets/images/promo_banner.png',
                  height: 190,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 190,
                    width: double.infinity,
                    alignment: Alignment.center,
                    color: const Color(0xFFEBE3D9),
                    child: const Text("Banner not available"),
                  ),
                ),
              ),

              const SizedBox(height: 25),
              const Text(
                'Daily Specials',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),

              // Horizontal List (same UI)
              SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: dailySpecials.length,
                  itemBuilder: (context, index) =>
                      _buildSpecialCard(dailySpecials[index]),
                ),
              ),

              const SizedBox(height: 25),
              const Text(
                'Customer Favorite',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),

              // Vertical List (same UI)
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: favorites.length,
                itemBuilder: (context, index) =>
                    _buildFavoriteItem(favorites[index]),
              ),
            ],
          ),
        );
      },
    );
  }

  // Horizontal Card with Navigation and Add to Cart (unchanged UI)
  Widget _buildSpecialCard(Map<String, dynamic> item) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 12, bottom: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFE6D2B5),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.black, width: 1.5),
      ),
      child: InkWell(
        onTap: () => _navigateToDetail(item),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(13),
                ),
                child: Image.asset(
                  item['image']!,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                item['name']!,
                maxLines: 1,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 4.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(item['price']!),
                  GestureDetector(
                    onTap: () => _addToCart(item),
                    child: const Icon(
                      Icons.add_circle,
                      size: 24,
                      color: Colors.brown,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Vertical Item with Navigation and Add to Cart (unchanged UI)
  Widget _buildFavoriteItem(Map<String, dynamic> item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFE6D2B5),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.black, width: 1),
      ),
      child: InkWell(
        onTap: () => _navigateToDetail(item),
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Image.asset(item['image']!, height: 60, width: 60),
              Image.network(
                item['image']!,
                height: 60,
                width: 60,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Image.asset(
                  "assets/images/matcha.png",
                  height: 60,
                  width: 60,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['name']!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      item['price']!,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.add_circle,
                  color: Colors.brown,
                  size: 30,
                ),
                onPressed: () => _addToCart(item),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ✅ MENU TAB (UI same, data from API)
  Widget _buildMenuContent() {
    return Consumer<MenuProvider>(
      builder: (context, menuProv, _) {
        if (menuProv.loading)
          return const Center(child: CircularProgressIndicator());
        if (menuProv.error != null) return Center(child: Text(menuProv.error!));
        if (menuProv.menus.isEmpty)
          return const Center(child: Text("No menu items"));

        final items = menuProv.menus.map<Map<String, dynamic>>((m) {
          final price = m.price.toStringAsFixed(2);
          return {
            "id": m.id,
            "name": m.name,
            "price": "\$$price",
            "image": m.imageUrl != null
                ? "${ApiEndpoints.baseUrl}${m.imageUrl}"
                : "assets/images/matcha.png", // keep UI
          };
        }).toList();

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: items.length,
          itemBuilder: (context, index) => _buildFavoriteItem(items[index]),
        );
      },
    );
  }

  // Helper: Navigation Logic (unchanged)
  void _navigateToDetail(Map<String, dynamic> item) {
    final int menuId = safeInt(item["id"]); // ✅ FIXED

    if (menuId == 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Menu ID missing")));
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CoffeeDetailScreen(
          menuId: menuId,
          name: item['name']!.toString(),
          price: item['price']!.toString(),
          imagePath: item['image']!.toString(),
        ),
      ),
    );
  }
  // void _navigateToDetail(Map<String, dynamic> item) {
  //   final int menuId = item["id"] as int;
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (_) => CoffeeDetailScreen(
  //         menuId: menuId,
  //         name: item['name']!,
  //         price: item['price']!,
  //         imagePath: item['image']!,
  //       ),
  //     ),
  //   );
  // }

  // Helper: Add to Cart Logic (unchanged)
  void _addToCart(Map<String, dynamic> item) {
    final price = double.tryParse(item['price']!.replaceAll('\$', '')) ?? 0.0;
    final menuId = safeInt(item["id"]); // ✅ FIXED

    if (menuId == 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Menu ID missing")));
      return;
    }

    context.read<CartProvider>().addItem(
      CartItem(
        menuId: menuId,
        name: item['name']!.toString(),
        imagePath: item['image']!.toString(),
        unitPrice: price,
        size: "medium",
        milk: "Regular",
        whippedCream: false,
        syrup: "None",
        qty: 1,
      ),
    );

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("${item['name']} added to cart!")));
  }
  // void _addToCart(Map<String, dynamic> item) {
  //   final price = double.tryParse(item['price']!.replaceAll('\$', '')) ?? 0.0;
  //   final menuId = item["id"] as int;
  //   context.read<CartProvider>().addItem(
  //     CartItem(
  //       menuId: menuId,
  //       name: item['name']!,
  //       imagePath: item['image']!,
  //       unitPrice: price,
  //       size: "medium",
  //       milk: "Regular",
  //       whippedCream: false,
  //       syrup: "None",
  //       qty: 1,
  //     ),
  //   );

  //   ScaffoldMessenger.of(
  //     context,
  //   ).showSnackBar(SnackBar(content: Text("${item['name']} added to cart!")));
  // }
}

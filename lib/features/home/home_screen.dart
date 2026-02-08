import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/features/coffeeDetail/coffee_detail_screen.dart';
import 'package:flutter_application_1/features/cart/cart_screen.dart';
import 'package:flutter_application_1/features/cart/cart_provider.dart';
import 'package:flutter_application_1/components/bottom_nav_bar.dart';
import 'package:flutter_application_1/features/auth/screens/edit_profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  
  int _selectedIndex = 0;

  final List<Map<String, String>> dailySpecials = [
    {'name': 'Ice Milk Coffee', 'price': '\$1.5', 'image': 'assets/images/matcha.png'},
    {'name': 'Hot Chocolate', 'price': '\$1.5', 'image': 'assets/images/hot_chocolate.png'},
    {'name': 'Coffee Shake', 'price': '\$2.0', 'image': 'assets/images/coffee_shake.png'},
    {'name': 'Cappuccino', 'price': '\$2.2', 'image': 'assets/images/cappuccino.png'},
    {'name': 'Mocha', 'price': '\$2.5', 'image': 'assets/images/mocha.png'},
    {'name': 'Espresso', 'price': '\$1.8', 'image': 'assets/images/espresso.png'},
    {'name': 'Americano', 'price': '\$2.0', 'image': 'assets/images/americano.png'},
    {'name': 'Macchiato', 'price': '\$2.3', 'image': 'assets/images/macchiato.png'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDEBDB), // Warm Klara Café Background
      body: SafeArea(
        child: IndexedStack(
          index: _selectedIndex,
          children: [
            _buildHomeContent(),
            _buildMenuContent(), // Now uses the menu content logic
            const Center(child: Text('Favorites')),
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

  Widget _buildHomeContent() {
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
          const Text('Good Morning ☀️', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),

          // Search Bar
          TextField(
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: 'Search your coffee...',
              filled: true,
              fillColor: const Color(0xFFEBE3D9),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(25), borderSide: BorderSide.none),
            ),
          ),
          const SizedBox(height: 20),

          // Promo Banner
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.network(
              'https://i.pinimg.com/1200x/38/8e/64/388e6440cb45dd4a9fd54f156b3e3c4f.jpg',
              height: 140, width: double.infinity, fit: BoxFit.cover,
            ),
          ),

          const SizedBox(height: 25),
          const Text('Daily Specials', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 15),

          // Horizontal List
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: dailySpecials.length,
              itemBuilder: (context, index) => _buildSpecialCard(dailySpecials[index]),
            ),
          ),

          const SizedBox(height: 25),
          const Text('Customer Favorite', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 15),

          // Vertical List
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: dailySpecials.length,
            itemBuilder: (context, index) => _buildFavoriteItem(dailySpecials[index]),
          ),
        ],
      ),
    );
  }

  // Horizontal Card with Navigation and Add to Cart
  Widget _buildSpecialCard(Map<String, String> item) {
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
                borderRadius: const BorderRadius.vertical(top: Radius.circular(13)),
                child: Image.asset(item['image']!, width: double.infinity, fit: BoxFit.cover),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(item['name']!, maxLines: 1, style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(item['price']!),
                  GestureDetector(
                    onTap: () => _addToCart(item),
                    child: const Icon(Icons.add_circle, size: 24, color: Colors.brown),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Vertical Item with Navigation and Add to Cart
  Widget _buildFavoriteItem(Map<String, String> item) {
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
              Image.asset(item['image']!, height: 60, width: 60),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item['name']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text(item['price']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle, color: Colors.brown, size: 30),
                onPressed: () => _addToCart(item),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuContent() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: dailySpecials.length,
      itemBuilder: (context, index) => _buildFavoriteItem(dailySpecials[index]),
    );
  }

  // Helper: Navigation Logic
  void _navigateToDetail(Map<String, String> item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CoffeeDetailScreen(
          name: item['name']!,
          price: item['price']!,
          imagePath: item['image']!,
        ),
      ),
    );
  }

  // Helper: Add to Cart Logic
  void _addToCart(Map<String, String> item) {
    final price = double.tryParse(item['price']!.replaceAll('\$', '')) ?? 0.0;
    context.read<CartProvider>().addItem(
      CartItem(
        name: item['name']!,
        imagePath: item['image']!,
        unitPrice: price,
        size: "medium",
        milk: "Regular",
        whippedCream: false,
        syrup: "None",
        qty: 1,
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("${item['name']} added to cart!")),
    );
  }
}
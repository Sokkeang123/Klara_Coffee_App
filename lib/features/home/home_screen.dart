import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/coffeeDetail/coffee_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Map<String, String>> dailySpecials = [
    {
      'name': 'Ice Milk Coffee',
      'price': '\$1.5',
      'image': 'assets/images/matcha.png',
    },
    {
      'name': 'Hot Chocolate',
      'price': '\$1.5',
      'image': 'assets/images/hot_chocolate.png',
    },
    {
      'name': 'Coffee Shake',
      'price': '\$2.0',
      'image': 'assets/images/coffee_shake.png',
    },
    {
      'name': 'Cappuccino',
      'price': '\$2.2',
      'image': 'assets/images/cappuccino.png',
    },
    {
      'name': 'Mocha',
      'price': '\$2.5',
      'image': 'assets/images/mocha.png',
    },
    {
      'name': 'Espresso',
      'price': '\$1.8',
      'image': 'assets/images/espresso.png',
    },
    {
      'name': 'Americano',
      'price': '\$2.0',
      'image': 'assets/images/americano.png',
    },
    {
      'name': 'Macchiato',
      'price': '\$2.3',
      'image': 'assets/images/macchiato.png',
    },
    {
      'name': 'Flat White',
      'price': '\$2.4',
      'image': 'assets/images/flat_white.png',
    },
    {
      'name': 'Affogato',
      'price': '\$2.6',
      'image': 'assets/images/affogato.png',
    },
    {
      'name': 'Irish Coffee',
      'price': '\$3.0',
      'image': 'assets/images/irish_coffee.png',
    },
    {
      'name': 'Green Tea',
      'price': '\$1.5',
      'image': 'assets/images/green_tea.png',
    },
    {
      'name': 'Matcha Latte',
      'price': '\$2.5',
      'image': 'assets/images/matcha_latte.png',
    },
    {
      'name': 'Chai Tea',
      'price': '\$2.0',
      'image': 'assets/images/chai_tea.png',
    },
    {
      'name': 'Hot Chocolate',
      'price': '\$2.2',
      'image': 'assets/images/hot_chocolate.png',
    },
    {
      'name': 'Vanilla Frappe',
      'price': '\$2.8',
      'image': 'assets/images/vanilla_frappe.png',
    },
    {
      'name': 'Caramel Frappe',
      'price': '\$2.8',
      'image': 'assets/images/caramel_frappe.png',
    },
    {
      'name': 'Strawberry Smoothie',
      'price': '\$3.0',
      'image': 'assets/images/strawberry_smoothie.png',
    },
    {
      'name': 'Mango Smoothie',
      'price': '\$3.0',
      'image': 'assets/images/mango_smoothie.png',
    },
    {
      'name': 'Iced Coffee',
      'price': '\$1.7',
      'image': 'assets/images/iced_coffee.png',
    },
    {
      'name': 'Lemon Tea',
      'price': '\$1.8',
      'image': 'assets/images/lemon_tea.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0E6),
      body: SafeArea(
        child: IndexedStack(
          index: _selectedIndex,
          children: [
            _buildHomeContent(),
            _buildMenuContent(),
            const Center(child: Text('Favorites')),
            const Center(child: Text('Cart')),
            const Center(child: Text('Profile')),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.brown[700],
        unselectedItemColor: Colors.grey,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: 'Menu'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorite'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
  Widget _buildHomeContent() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Good Morning ☀️',
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        TextField(
          decoration: InputDecoration(
            hintText: 'Search your coffee...',
            prefixIcon: const Icon(Icons.search),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Container(
          height: 150,
          decoration: BoxDecoration(
            color: Colors.brown[200],
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Center(
            child: Text(
              '☕ The Best Coffee',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Daily Specials',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        ...dailySpecials.map(
          (item) => _buildMenuItem(
            item['name']!,
            item['price']!,
            item['image']!,
          ),
        ),
      ],
    );
  }

  /// ---------------- MENU ----------------
  Widget _buildMenuContent() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: dailySpecials.length,
      itemBuilder: (context, index) {
        final item = dailySpecials[index];
        return _buildMenuItem(
          item['name']!,
          item['price']!,
          item['image']!,
        );
      },
    );
  }
  Widget _buildMenuItem(String name, String price, String imagePath) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CoffeeDetailScreen(
              name: name,
              price: price,
              imagePath: imagePath,
            ),
          ),
        );
      },

      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
              child: Image.asset(
                imagePath,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      price,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.brown[700],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add_circle, color: Colors.brown),
              onPressed: () {
                // optional: add to cart
              },
            ),
          ],
        ),
      ),
    );
  }
}
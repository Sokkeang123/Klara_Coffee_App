import 'package:flutter/material.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Menu')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          MenuItem(name: 'Ice Milk Coffee', price: '\$1.5'),
          MenuItem(name: 'Black Tea', price: '\$1.5'),
          MenuItem(name: 'Ice Black', price: '\$1.5'),
        ],
      ),
    );
  }
}

class MenuItem extends StatelessWidget {
  final String name;
  final String price;

  const MenuItem({required this.name, required this.price, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(name),
        subtitle: Text(price),
        trailing: IconButton(
          icon: const Icon(Icons.add_circle_outline),
          onPressed: () {},
        ),
      ),
    );
  }
}

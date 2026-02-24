import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'favorite_provider.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final fav = context.watch<FavoriteProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text("Favourite")),
      body: fav.items.isEmpty
          ? const Center(child: Text("No favourite items yet ❤️"))
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: fav.items.length,
        itemBuilder: (context, index) {
          final item = fav.items[index];
          return Card(
            child: ListTile(
              leading: Image.asset(item.imagePath, width: 50),
              title: Text(item.name),
              subtitle: Text(item.price),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => fav.toggleFavorite(item),
              ),
            ),
          );
        },
      ),
    );
  }
}

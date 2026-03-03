import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'favorite_provider.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  Widget _favImage(String path) {
    if (path.startsWith("http")) {
      return Image.network(path, width: 50, height: 50, fit: BoxFit.cover);
    }
    return Image.asset(path, width: 50, height: 50, fit: BoxFit.cover);
  }

  @override
  Widget build(BuildContext context) {
    final fav = context.watch<FavoriteProvider>();
      debugPrint("Favourite items length: ${fav.items.length}");

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
                    // leading: ClipRRect(
                    //   borderRadius: BorderRadius.circular(8),
                    //   child: _favImage(item.imagePath),
                    // ),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: item.imagePath.startsWith("http")
                          ? Image.network(
                              item.imagePath,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                                  const Icon(Icons.image_not_supported),
                            )
                          : Image.asset(
                              item.imagePath,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                    ),
                    title: Text(item.name),
                    subtitle: Text(item.price),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => fav.removeById(item.menuId),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

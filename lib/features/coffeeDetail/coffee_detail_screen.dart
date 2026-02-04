import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/features/cart/cart_provider.dart';
import 'package:flutter_application_1/features/cart/cart_screen.dart';
import 'package:flutter_application_1/features/coffeeDetail/customize_drink_screen.dart';

enum CoffeeSize { small, medium, large }

class CoffeeDetailScreen extends StatefulWidget {
  final String name;
  final String price;
  final String imagePath;

  const CoffeeDetailScreen({
    super.key,
    required this.name,
    required this.price,
    required this.imagePath,
  });

  @override
  State<CoffeeDetailScreen> createState() => _CoffeeDetailScreenState();
}

class _CoffeeDetailScreenState extends State<CoffeeDetailScreen> {
  int qty = 1;
  CoffeeSize selectedSize = CoffeeSize.medium;
  CustomizeDrinkResult? customize;

  double _priceToDouble(String p) {
    return double.tryParse(p.replaceAll('\$', '').trim()) ?? 0.0;
  }

  double get totalPrice {
    final base = _priceToDouble(widget.price);
    final multiplier = switch (selectedSize) {
      CoffeeSize.small => 0.9,
      CoffeeSize.medium => 1.0,
      CoffeeSize.large => 1.2,
    };
    return base * multiplier * qty;
  }

  String get sizeText {
    return switch (selectedSize) {
      CoffeeSize.small => "small",
      CoffeeSize.medium => "medium",
      CoffeeSize.large => "large",
    };
  }

  @override
  Widget build(BuildContext context) {
    const bgDark = Color(0xFF2A150A);
    const bgLight = Color(0xFFF6E6D5);
    const textDark = Color(0xFF1F120A);
    const line = Color(0xFFD9C4AE);

    return Scaffold(
      backgroundColor: bgLight,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: const [
                Expanded(flex: 46, child: ColoredBox(color: bgDark)),
                Expanded(flex: 54, child: ColoredBox(color: bgLight)),
              ],
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 14, 20, 8),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.white,
                        ),
                      ),
                      const Spacer(),
                      const Text(
                        "Klara Kafé L’D",
                        style: TextStyle(
                          color: Color(0xFFF2DFCC),
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const Spacer(),
                      const Icon(
                        Icons.favorite_border_rounded,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 240,
                  child: Center(
                    child: Image.asset(
                      widget.imagePath,
                      height: 230,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () {
                                if (qty > 1) setState(() => qty--);
                              },
                            ),
                            Text(
                              qty.toString(),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () => setState(() => qty++),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        Text(
                          widget.name,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "Size",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: CoffeeSize.values.map((s) {
                            final label =
                                s.name[0].toUpperCase() + s.name.substring(1);
                            return Expanded(
                              child: InkWell(
                                onTap: () => setState(() => selectedSize = s),
                                child: Container(
                                  height: 42,
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 4),
                                  decoration: BoxDecoration(
                                    color: selectedSize == s
                                        ? const Color(0xFFD6BFA6)
                                        : bgLight,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(color: textDark),
                                  ),
                                  child: Center(
                                    child: Text(
                                      label,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 22),
                        const Text(
                          "Customize your coffee",
                          style: TextStyle(fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 8),
                        Container(height: 1, color: line),
                        ListTile(
                          title: Text(
                            customize == null
                                ? "Customize drink"
                                : "${customize!.milk} • ${customize!.whippedCream ? 'with cream' : 'No cream'} • ${customize!.syrup}",
                          ),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () async {
                            final result =
                                await Navigator.push<CustomizeDrinkResult>(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const CartSheet(),
                              ),
                            );
                            if (result != null) {
                              setState(() => customize = result);
                            }
                          },
                        ),
                        Container(height: 1, color: line),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Text(
                              "Total Cost",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const Spacer(),
                            Text(
                              "\$${totalPrice.toStringAsFixed(2)}",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        SizedBox(
                          width: double.infinity,
                          height: 54,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFCDBAA5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            onPressed: () {
                              context.read<CartProvider>().addItem(
                                    CartItem(
                                      name: widget.name,
                                      imagePath: widget.imagePath,
                                      unitPrice: _priceToDouble(widget.price),
                                      size: sizeText,
                                      milk: customize?.milk ?? "Oat Milk",
                                      whippedCream:
                                          customize?.whippedCream ?? true,
                                      syrup: customize?.syrup ?? "Chocolate",
                                      qty: qty,
                                    ),
                                  );

                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                isDismissible: true,
                                enableDrag: true,
                                showDragHandle: false,
                                backgroundColor: Colors.transparent,

                                // ✅ IMPORTANT CHANGE HERE:
                                builder: (_) => const CartSheet(),
                              );
                            },
                            child: const Text(
                              "Buy",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

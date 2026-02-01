import 'package:flutter/material.dart';
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

  String get customizeSummary {
    if (customize == null) return "Customize drink";
    return "${customize!.milk} • ${customize!.whippedCream ? 'With cream' : 'No cream'} • ${customize!.syrup}";
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
            // Background split
            Column(
              children: const [
                Expanded(flex: 46, child: ColoredBox(color: bgDark)),
                Expanded(flex: 54, child: ColoredBox(color: bgLight)),
              ],
            ),

            // Content
            Column(
              children: [
                // Top bar + title
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 14, 20, 8),
                  child: Row(
                    children: [
                      _IconCircleButton(
                        icon: Icons.arrow_back_ios_new_rounded,
                        onTap: () => Navigator.pop(context),
                        iconColor: Colors.white,
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
                      _IconCircleButton(
                        icon: Icons.favorite_border_rounded,
                        onTap: () {},
                        iconColor: Colors.white,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Drink image
                SizedBox(
                  height: 240,
                  child: Center(
                    child: Image.asset(
                      widget.imagePath,
                      height: 230,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.local_cafe,
                        size: 90,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                // Bottom details
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Qty selector
                        _QtySelector(value: qty,
                          onMinus: () {
                            setState(() {
                              if (qty > 1) qty--;
                            });
                          },
                          onPlus: () => setState(() => qty++),
                        ),

                        const SizedBox(height: 18),

                        Text(
                          widget.name,
                          style: const TextStyle(
                            color: textDark,
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          "A Frappuccino is a cold, blended coffee drink\npopularized by Starbucks.",
                          style: TextStyle(
                            color: Color(0xFF3B2A1E),
                            fontSize: 14.5,
                            height: 1.35,
                          ),
                        ),

                        const SizedBox(height: 20),

                        const Text(
                          "Size",
                          style: TextStyle(
                            color: textDark,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 10),

                        Row(
                          children: [
                            _SizePill(
                              label: "Small",
                              selected: selectedSize == CoffeeSize.small,
                              onTap: () => setState(() => selectedSize = CoffeeSize.small),
                            ),
                            const SizedBox(width: 12),
                            _SizePill(
                              label: "Medium",
                              selected: selectedSize == CoffeeSize.medium,
                              onTap: () => setState(() => selectedSize = CoffeeSize.medium),
                            ),
                            const SizedBox(width: 12),
                            _SizePill(
                              label: "Large",
                              selected: selectedSize == CoffeeSize.large,
                              onTap: () => setState(() => selectedSize = CoffeeSize.large),
                            ),
                          ],
                        ),

                        const SizedBox(height: 22),

                        const Text(
                          "Customize your coffee",
                          style: TextStyle(
                            color: textDark,
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(height: 1, color: line),
                        _RowItem(
                          title: customizeSummary,
                          trailing: const Icon(Icons.chevron_right_rounded),
                          onTap: () async {
                            final result = await Navigator.push<CustomizeDrinkResult>(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CustomizeDrinkScreen(
                                  imagePath: widget.imagePath,
                                ),
                              ),
                            );

                            if (result != null) {
                              setState(() => customize = result);
                            }
                          },
                        ),

                        Container(height: 1, color: line),

                        _RowItem(title: "Total Cost",
                          trailingText: "\$${totalPrice.toStringAsFixed(2)}",
                        ),

                        const Spacer(),

                        SizedBox(
                          width: double.infinity,
                          height: 54,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFCDBAA5),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: const Text(
                              "Buy",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
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

class _IconCircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color iconColor;

  const _IconCircleButton({
    required this.icon,
    required this.onTap,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        width: 44,
        height: 44,
        child: Center(child: Icon(icon, color: iconColor)),
      ),
    );
  }
}

class _QtySelector extends StatelessWidget {
  final int value;
  final VoidCallback onMinus;
  final VoidCallback onPlus;

  const _QtySelector({
    required this.value,
    required this.onMinus,
    required this.onPlus,
  });

  @override
  Widget build(BuildContext context) {
    const border = Color(0xFF2A150A);
    return Container(
      width: 150,
      height: 44,
      decoration: BoxDecoration(
        color: const Color(0xFFEEDCC8),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border, width: 1.2),
      ),
      child: Row(
        children: [
          _QtyButton(icon: Icons.add, onTap: onPlus),
          Expanded(
            child: Center(
              child: Text(
                value.toString(),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1F120A),
                ),
              ),
            ),
          ),
          _QtyButton(icon: Icons.remove, onTap: onMinus),
        ],
      ),
    );
  }
}

class _QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _QtyButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        width: 48,
        height: 44,
        child: Icon(icon, size: 20, color: const Color(0xFF1F120A)),
      ),
    );
  }
}

class _SizePill extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _SizePill({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const border = Color(0xFF2A150A);

    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: 42,
          decoration: BoxDecoration(
            color: selected ? const Color(0xFFD6BFA6) : const Color(0xFFF6E6D5),
            borderRadius: BorderRadius.circular(16),border: Border.all(color: border, width: 1.2),
          ),
          child: Center(
            child: Text(
              label,
              style: const TextStyle(
                color: Color(0xFF1F120A),
                fontWeight: FontWeight.w800,
                fontSize: 15,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RowItem extends StatelessWidget {
  final String title;
  final Widget? trailing;
  final String? trailingText;
  final VoidCallback? onTap;

  const _RowItem({
    required this.title,
    this.trailing,
    this.trailingText,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final row = Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: const Color(0xFF3B2A1E),
                fontSize: 16,
                fontWeight: title == "Total Cost" ? FontWeight.w800 : FontWeight.w700,
              ),
            ),
          ),
          if (trailingText != null)
            Text(
              trailingText!,
              style: const TextStyle(
                color: Color(0xFF1F120A),
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            )
          else if (trailing != null)
            trailing!,
        ],
      ),
    );

    if (onTap == null) return row;
    return InkWell(onTap: onTap, child: row);
  }
}
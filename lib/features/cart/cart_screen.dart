import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/features/cart/cart_provider.dart';
import 'package:flutter_application_1/features/checkout/checkout_sheet.dart';

/// ✅ Use this for BottomNavigation "Cart" page (NO close button)
class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: _CartBody(showCloseButton: false),
    );
  }
}

/// ✅ Use this inside showModalBottomSheet (WITH close button)
class CartSheet extends StatelessWidget {
  const CartSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return const Material(
      color: Color(0xFFFFF1DF),
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(28),
        topRight: Radius.circular(28),
      ),
      child: SafeArea(
        top: false,
        child: _CartBody(showCloseButton: true),
      ),
    );
  }
}

class _CartBody extends StatelessWidget {
  final bool showCloseButton;

  const _CartBody({required this.showCloseButton});

  @override
  Widget build(BuildContext context) {
    const panel = Color(0xFFFFF1DF);
    const divider = Color(0xFFE7D7C8);

    final cart = context.watch<CartProvider>();

    return Container(
      color: panel,
      child: Column(
        children: [
          const SizedBox(height: 10),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              children: [
                SizedBox(
                  width: 48,
                  child: showCloseButton
                      ? IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close),
                        )
                      : null,
                ),
                const Expanded(
                  child: Center(
                    child: Text(
                      "My Cart",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF1F120A),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 48),
              ],
            ),
          ),

          const SizedBox(height: 8),
          Container(height: 1, color: divider),

          Expanded(
            child: cart.items.isEmpty
                ? const Center(
                    child: Text(
                      "Your cart is empty",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF3B2A1E),
                      ),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                    itemCount: cart.items.length,
                    separatorBuilder: (_, __) => Container(
                      margin: const EdgeInsets.symmetric(vertical: 14),
                      height: 1,
                      color: divider,
                    ),
                    itemBuilder: (context, index) {
                      final item = cart.items[index];

                      final subtitle =
                          "${item.size}, ${item.milk} • ${item.whippedCream ? 'with cream' : 'No cream'} • ${item.syrup}";

                      return _CartRow(
                        name: item.name,
                        subtitle: subtitle,
                        imagePath: item.imagePath,
                        qty: item.qty,
                        priceText: "\$${item.unitPrice.toStringAsFixed(2)}",
                        onMinus: () => cart.decreaseQty(index),
                        onPlus: () => cart.increaseQty(index),
                        onRemove: () => cart.removeAt(index),
                      );
                    },
                  ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 18),
            child: _CheckoutBar(
              enabled: cart.items.isNotEmpty,
              totalText: "\$${cart.totalPrice.toStringAsFixed(2)}",
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  showDragHandle: false,
                  builder: (_) => const CheckoutSheet(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _CartRow extends StatelessWidget {
  final String name;
  final String subtitle;
  final String imagePath;
  final int qty;
  final String priceText;
  final VoidCallback onMinus;
  final VoidCallback onPlus;
  final VoidCallback onRemove;

  const _CartRow({
    required this.name,
    required this.subtitle,
    required this.imagePath,
    required this.qty,
    required this.priceText,
    required this.onMinus,
    required this.onPlus,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    const title = Color(0xFF1F120A);
    const sub = Color(0xFF8B7A6B);
    const lightBtn = Color(0xFFF3E7DA);
    const plusGreen = Color(0xFF2E9E6F);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: SizedBox(
            width: 76,
            height: 76,
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: Colors.black12,
                child: const Icon(Icons.local_cafe),
              ),
            ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: title,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: onRemove,
                    borderRadius: BorderRadius.circular(18),
                    child: const Padding(
                      padding: EdgeInsets.all(6),
                      child: Icon(Icons.close, color: Colors.grey, size: 22),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 3),
              Text(
                subtitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  color: sub,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _QtyPillButton(
                    icon: Icons.remove,
                    background: lightBtn,
                    iconColor: Colors.grey,
                    onTap: onMinus,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    qty.toString(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: title,
                    ),
                  ),
                  const SizedBox(width: 12),
                  _QtyPillButton(
                    icon: Icons.add,
                    background: Colors.white,
                    iconColor: plusGreen,
                    borderColor: const Color(0xFFD9C4AE),
                    onTap: onPlus,
                  ),
                  const Spacer(),
                  Text(
                    priceText,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: title,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _QtyPillButton extends StatelessWidget {
  final IconData icon;
  final Color background;
  final Color iconColor;
  final Color? borderColor;
  final VoidCallback onTap;

  const _QtyPillButton({
    required this.icon,
    required this.background,
    required this.iconColor,
    this.borderColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        width: 54,
        height: 44,
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(18),
          border: borderColor == null
              ? null
              : Border.all(color: borderColor!, width: 1.2),
        ),
        child: Icon(icon, color: iconColor, size: 26),
      ),
    );
  }
}

class _CheckoutBar extends StatelessWidget {
  final String totalText;
  final VoidCallback onTap;
  final bool enabled;

  const _CheckoutBar({
    required this.totalText,
    required this.onTap,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFFD9CFC6);
    const pill = Color(0xFFBFB3A9);

    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(22),
      child: Opacity(
        opacity: enabled ? 1 : 0.6,
        child: Container(
          height: 64,
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(22),
          ),
          child: Row(
            children: [
              const SizedBox(width: 18),
              const Expanded(
                child: Center(
                  child: Text(
                    "Go to Checkout",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(right: 14),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: pill,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  totalText,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/features/cart/cart_provider.dart';
import 'package:flutter_application_1/features/delivery/delivery_method_screen.dart';

class CheckoutSheet extends StatefulWidget {
  const CheckoutSheet({super.key});

  @override
  State<CheckoutSheet> createState() => _CheckoutSheetState();
}

class _CheckoutSheetState extends State<CheckoutSheet> {
  DeliveryMethodResult? method;

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final total = cart.totalPrice;
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return Material(
      color: Colors.transparent,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          clipBehavior: Clip.antiAlias,
          child: Padding(
            padding: EdgeInsets.fromLTRB(18, 18, 18, 18 + bottomInset),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    const Text(
                      "Checkout",
                      style: TextStyle(fontSize: 34, fontWeight: FontWeight.w900),
                    ),
                    const Spacer(),
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      borderRadius: BorderRadius.circular(18),
                      child: const Padding(
                        padding: EdgeInsets.all(10),
                        child: Icon(Icons.close, size: 28),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),
                const _Line(),

                _Row(
                  left: "Delivery",
                  right: method == null
                      ? "Select Method"
                      : (method!.isPickup ? "Pick up" : "Delivery"),
                  onTap: () async {
                    final result = await Navigator.push<DeliveryMethodResult>(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DeliveryMethodScreen(initial: method),
                      ),
                    );
                    if (result != null) setState(() => method = result);
                  },
                ),
                const _Line(),

                _Row(
                  left: "Payment",
                  rightWidget: const Text("💳", style: TextStyle(fontSize: 22)),
                  onTap: () {},
                ),
                const _Line(),

                _Row(
                  left: "Promo Code",
                  right: "Pick discount",
                  onTap: () {},
                ),
                const _Line(),

                const SizedBox(height: 14),

                Row(
                  children: [
                    const Text(
                      "Total Cost",
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
                    ),
                    const Spacer(),
                    Text(
                      "\$${total.toStringAsFixed(2)}",
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "By placing an order you agree to our\nTerms And Conditions",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF6B6B6B),
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: cart.items.isEmpty ? null : () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFCDBAA5),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    child: const Text(
                      "Place Order",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String left;
  final String? right;
  final Widget? rightWidget;
  final VoidCallback onTap;

  const _Row({
    required this.left,
    this.right,
    this.rightWidget,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          children: [
            Expanded(
              child: Text(
                left,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF9BA3AF),
                ),
              ),
            ),
            if (rightWidget != null) rightWidget!,
            if (right != null)
              Text(
                right!,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
              ),
            const SizedBox(width: 10),
            const Icon(Icons.chevron_right_rounded, size: 30),
          ],
        ),
      ),
    );
  }
}

class _Line extends StatelessWidget {
  const _Line();

  @override
  Widget build(BuildContext context) {
    return Container(height: 1, color: const Color(0xFFE5E7EB));
  }
}
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/order/order_success_screen.dart';
import 'package:flutter_application_1/features/order/provider/order_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/features/cart/cart_provider.dart';
import 'package:flutter_application_1/features/delivery/delivery_method_screen.dart';
import 'package:flutter_application_1/features/order/data/services/order_service.dart';
// import 'package:flutter_application_1/features/order/provider/order_provider.dart';

class CheckoutSheet extends StatefulWidget {
  const CheckoutSheet({super.key});

  @override
  State<CheckoutSheet> createState() => _CheckoutSheetState();
}

class _CheckoutSheetState extends State<CheckoutSheet> {
  DeliveryMethodResult? method;

  final OrderService _orderService = OrderService();
  bool _placing = false;
  Future<bool> _showFakeQrPayment(double amount) async {
    if (!mounted) return false;

    int secondsLeft = 5;
    Timer? timer;

    final qrData =
        "ABA_FAKE_PAYMENT|amount=${amount.toStringAsFixed(2)}|currency=USD";

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            timer ??= Timer.periodic(const Duration(seconds: 1), (t) {
              if (!mounted) {
                t.cancel();
                return;
              }

              if (secondsLeft <= 1) {
                t.cancel();
                if (Navigator.of(dialogContext).canPop()) {
                  Navigator.of(dialogContext).pop();
                }
              } else {
                secondsLeft--;
                setDialogState(() {});
              }
            });

            return WillPopScope(
              onWillPop: () async => false,
              child: AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                title: const Center(
                  child: Text(
                    "ABA QR Payment",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Amount: \$${amount.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Image.network(
                      "https://api.qrserver.com/v1/create-qr-code/?size=220x220&data=$qrData",
                      width: 220,
                      height: 220,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) {
                        return Container(
                          width: 220,
                          height: 220,
                          color: Colors.grey.shade200,
                          child: const Center(
                            child: Icon(Icons.qr_code_2, size: 120),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      "Scan this QR to pay",
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Auto success in $secondsLeft s",
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const SizedBox(
                      width: 26,
                      height: 26,
                      child: CircularProgressIndicator(strokeWidth: 3),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    timer?.cancel();
    return true;
  }

  Future<void> _selectPayment() async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text("Cash"),
              onTap: () => Navigator.pop(context, "Cash"),
            ),
            ListTile(
              title: const Text("QRCode"),
              onTap: () => Navigator.pop(context, "QRCode"),
            ),
            ListTile(
              title: const Text("Card"),
              onTap: () => Navigator.pop(context, "Card"),
            ),
          ],
        ),
      ),
    );

    if (selected != null) {
      context.read<OrderProvider>().setPaymentMethod(selected);
    }
  }

  Future<void> _pickPayment() async {
    final prov = context.read<OrderProvider>();

    final result = await showModalBottomSheet<String>(
      context: context,
      builder: (_) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text("Cash"),
                trailing: prov.paymentMethod == "Cash"
                    ? const Icon(Icons.check)
                    : null,
                onTap: () => Navigator.pop(context, "Cash"),
              ),
              ListTile(
                title: const Text("Card"),
                trailing: prov.paymentMethod == "Card"
                    ? const Icon(Icons.check)
                    : null,
                onTap: () => Navigator.pop(context, "Card"),
              ),
              ListTile(
                title: const Text("QRCode"),
                trailing: prov.paymentMethod == "QRCode"
                    ? const Icon(Icons.check)
                    : null,
                onTap: () => Navigator.pop(context, "QRCode"),
              ),
            ],
          ),
        );
      },
    );

    if (result != null) {
      prov.setPaymentMethod(result);
    }
  }

  Future<void> _placeOrder() async {
    final cart = context.read<CartProvider>();
    final orderProvider = context.read<OrderProvider>();

    if (cart.items.isEmpty) return;

    final items = cart.toOrderItems();
    final totalCost = cart.totalPrice;

    if (orderProvider.paymentMethod == "QRCode") {
      final paid = await _showFakeQrPayment(totalCost);
      if (!paid) return;
    }

    setState(() => _placing = true);

    final tempOrder = orderProvider.createLocalPendingOrder(
      totalCost: totalCost,
      paymentMethod: orderProvider.paymentMethod,
      isPickup: method?.isPickup ?? true,
    );
    orderProvider.addOrder(tempOrder);

    try {
      final newOrder = await _orderService.createOrder(
        items: items,
        totalCost: totalCost,
      );

      orderProvider.replaceTempOrder(tempOrder, newOrder);

      if (!mounted) return;

      cart.clear();

      // close checkout sheet first
      Navigator.pop(context);

      // go to success screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => OrderSuccessScreen(amount: totalCost),
        ),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Order failed: $e")));
      }
    } finally {
      if (mounted) {
        setState(() => _placing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final orderProvider = context.watch<OrderProvider>();
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
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.w900,
                      ),
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
                  right: orderProvider.paymentMethod,
                  onTap: _pickPayment,
                ),
                const _Line(),

                _Row(left: "Promo Code", right: "Pick discount", onTap: () {}),
                const _Line(),

                const SizedBox(height: 14),

                Row(
                  children: [
                    const Text(
                      "Total Cost",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      "\$${total.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                      ),
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
                    onPressed: (cart.items.isEmpty || _placing)
                        ? null
                        : _placeOrder,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFCDBAA5),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    child: _placing
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text(
                            "Place Order",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                            ),
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
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                ),
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

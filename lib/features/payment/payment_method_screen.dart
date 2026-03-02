import 'package:flutter/material.dart';

class PaymentMethodResult {
  final String method; // "QR" | "Card" | "Cash"

  const PaymentMethodResult(this.method);
}

class PaymentMethodScreen extends StatelessWidget {
  final PaymentMethodResult? initial;

  const PaymentMethodScreen({super.key, this.initial});

  @override
  Widget build(BuildContext context) {
    final selected = initial?.method;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Payment Method"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _MethodTile(
            title: "QR Payment",
            subtitle: "Scan QR to pay",
            icon: Icons.qr_code_2,
            selected: selected == "QR",
            onTap: () => Navigator.pop(context, const PaymentMethodResult("QR")),
          ),
          const SizedBox(height: 12),
          _MethodTile(
            title: "Card",
            subtitle: "Visa / MasterCard",
            icon: Icons.credit_card,
            selected: selected == "Card",
            onTap: () => Navigator.pop(context, const PaymentMethodResult("Card")),
          ),
          const SizedBox(height: 12),
          _MethodTile(
            title: "Cash",
            subtitle: "Pay when receive / pickup",
            icon: Icons.payments,
            selected: selected == "Cash",
            onTap: () => Navigator.pop(context, const PaymentMethodResult("Cash")),
          ),
        ],
      ),
    );
  }
}

class _MethodTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _MethodTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? const Color(0xFFEFE6DB) : Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: selected ? const Color(0xFFCDBAA5) : const Color(0xFFE5E7EB),
              width: 1.2,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                        )),
                    const SizedBox(height: 3),
                    Text(subtitle,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                          fontWeight: FontWeight.w600,
                        )),
                  ],
                ),
              ),
              if (selected)
                const Icon(Icons.check_circle, color: Color(0xFF2E9E6F))
              else
                const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}
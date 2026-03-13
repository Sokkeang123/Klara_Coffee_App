import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'provider/order_provider.dart';

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<OrderProvider>().fetchMyOrders());
  }

  Color _statusColor(String s) {
    switch (s) {
      case "Pending":
        return Colors.orange;
      case "Processing":
        return Colors.blue;
      case "Completed":
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<OrderProvider>();

    if (prov.loading) return const Center(child: CircularProgressIndicator());
    if (prov.error != null) return Center(child: Text("Error: ${prov.error}"));
    if (prov.orders.isEmpty) return const Center(child: Text("No orders yet"));

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: prov.orders.length,
      itemBuilder: (_, i) {
        final o = prov.orders[i];
        final c = _statusColor(o.status);

        return Card(
          child: ListTile(
            title: Text(
              "${o.displayName}  •  \$${o.totalCost.toStringAsFixed(2)}",
            ),
            subtitle: Text("Created: ${o.createdAt.toLocal()}"),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: c.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: c),
              ),
              child: Text(
                o.status,
                style: TextStyle(color: c, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'features/cart/cart_provider.dart';
import 'app.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => CartProvider(),
      child: const MyApp(),
    ),
  );
}

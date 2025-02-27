// lib/screens/tax_returns/tax_returns_screen.dart
import 'package:flutter/material.dart';

class TaxReturnsScreen extends StatelessWidget {
  static const String routeName = '/tax-returns';

  const TaxReturnsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tax Returns'),
      ),
      body: const Center(
        child: Text('Tax Returns Screen - To be implemented'),
      ),
    );
  }
}

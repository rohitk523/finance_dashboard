// lib/screens/tax_returns/tax_calculation_screen.dart
import 'package:flutter/material.dart';

class TaxCalculationScreen extends StatelessWidget {
  static const String routeName = '/tax-returns/calculate';

  const TaxCalculationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tax Calculation'),
      ),
      body: const Center(
        child: Text('Tax Calculation Screen - To be implemented'),
      ),
    );
  }
}

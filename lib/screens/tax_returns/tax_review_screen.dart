// lib/screens/tax_returns/tax_review_screen.dart
import 'package:flutter/material.dart';

class TaxReviewScreen extends StatelessWidget {
  static const String routeName = '/tax-returns/review';

  const TaxReviewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Review Tax Return'),
      ),
      body: const Center(
        child: Text('Tax Review Screen - To be implemented'),
      ),
    );
  }
}

// lib/screens/investments/investment_detail_screen.dart
import 'package:flutter/material.dart';

class InvestmentDetailScreen extends StatelessWidget {
  static const String routeName = '/investments/detail';
  final String? investmentId;

  const InvestmentDetailScreen({Key? key, this.investmentId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Investment Details'),
      ),
      body: Center(
        child: Text('Investment Detail Screen - ID: ${investmentId ?? "None"}'),
      ),
    );
  }
}

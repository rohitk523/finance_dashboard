// lib/screens/investments/investments_screen.dart
import 'package:flutter/material.dart';

class InvestmentsScreen extends StatelessWidget {
  static const String routeName = '/investments';

  const InvestmentsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Investments'),
      ),
      body: const Center(
        child: Text('Investments Screen - To be implemented'),
      ),
    );
  }
}

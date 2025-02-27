// lib/screens/investments/add_investment_screen.dart
import 'package:flutter/material.dart';

class AddInvestmentScreen extends StatelessWidget {
  static const String routeName = '/investments/add';
  final bool isEditing;
  final dynamic investment;

  const AddInvestmentScreen({
    Key? key,
    this.isEditing = false,
    this.investment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Investment' : 'Add Investment'),
      ),
      body: Center(
        child: Text(isEditing
            ? 'Edit Investment Screen - To be implemented'
            : 'Add Investment Screen - To be implemented'),
      ),
    );
  }
}

// lib/screens/transactions/add_transaction_screen.dart
import 'package:flutter/material.dart';

class AddTransactionScreen extends StatelessWidget {
  static const String routeName = '/transactions/add';
  final bool isEditing;
  final dynamic transaction;

  const AddTransactionScreen({
    Key? key,
    this.isEditing = false,
    this.transaction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Transaction' : 'Add Transaction'),
      ),
      body: Center(
        child: Text(isEditing
            ? 'Edit Transaction Screen - To be implemented'
            : 'Add Transaction Screen - To be implemented'),
      ),
    );
  }
}

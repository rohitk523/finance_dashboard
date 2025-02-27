// lib/screens/tax_returns/document_upload_screen.dart
import 'package:flutter/material.dart';

class DocumentUploadScreen extends StatelessWidget {
  static const String routeName = '/tax-returns/upload';

  const DocumentUploadScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Documents'),
      ),
      body: const Center(
        child: Text('Document Upload Screen - To be implemented'),
      ),
    );
  }
}

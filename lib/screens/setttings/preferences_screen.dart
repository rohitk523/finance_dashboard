// lib/screens/settings/preferences_screen.dart
import 'package:flutter/material.dart';

class PreferencesScreen extends StatelessWidget {
  static const String routeName = '/preferences';

  const PreferencesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preferences'),
      ),
      body: const Center(
        child: Text('Preferences Screen - To be implemented'),
      ),
    );
  }
}

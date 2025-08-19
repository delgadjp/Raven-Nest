import 'package:flutter/material.dart';
import '../widgets/navigation.dart';

/// Basic reset of Settings screen while retaining hamburger navigation.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const NavigationWidget(),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.settings_outlined, size: 72, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  const Text(
                    'Settings',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Settings screen placeholder.',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.tune),
                    label: const Text('Configure'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

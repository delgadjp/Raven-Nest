import 'package:flutter/material.dart';
import '../widgets/navigation.dart';

/// Basic reset of Guest Logs screen retaining the hamburger menu.
class GuestLogsScreen extends StatelessWidget {
  const GuestLogsScreen({super.key});

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
                  Icon(Icons.list_alt, size: 72, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  const Text(
                    'Guest Logs',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'No guest log entries yet.',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.add),
                    label: const Text('Add First Log'),
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

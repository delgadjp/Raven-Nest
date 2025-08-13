import 'package:flutter/material.dart';
import '../widgets/navigation.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Column(
        children: [
          const NavigationWidget(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Section: Notification Stats
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildStatCard('Total Notifications', '8', 'All notifications',
                          Colors.blue),
                      _buildStatCard('Unread', '4', 'Need attention', Colors.red),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildStatCard('Today', '0', 'Recent activity', Colors.green),
                      _buildStatCard('High Priority', '2', 'Urgent items', Colors.pink),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Section: Recent Notifications Title
                  const Text(
                    'Recent Notifications',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'All your property notifications',
                    style: TextStyle(color: Color(0xFF4B5563)),
                  ),
                  const SizedBox(height: 10),

                  // Light red notification label
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Color(0xFFFEE2E2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Notifications',
                      style: TextStyle(color: Color(0xFFB91C1C), fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(height: 10),

                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('Mark Read'),
                  ),
                  const SizedBox(height: 16),

                  // Notifications List
                  _buildNotificationCard(
                    title: 'New Booking Confirmed',
                    description:
                        'Sarah Johnson has booked Room 305 for Dec 20–25, 2024',
                    priority: 'high',
                    priorityColor: Colors.red,
                    date: '12/14/2024',
                    source: 'Airbnb',
                    price: '\$750',
                    read: false,
                  ),
                  const SizedBox(height: 10),
                  _buildNotificationCard(
                    title: 'Guest Check-in Tomorrow',
                    description:
                        'John Smith is scheduled to check into Room 201 at 3:00 PM',
                    priority: 'medium',
                    priorityColor: Colors.orange,
                    date: '12/14/2024',
                    source: 'System',
                    price: '',
                    read: false,
                  ),
                  const SizedBox(height: 10),
                  _buildNotificationCard(
                    title: 'Booking Cancelled',
                    description:
                        'Robert Johnson cancelled booking for Room 412 (Dec 18–20)',
                    priority: 'medium',
                    priorityColor: Colors.orange,
                    date: '12/11/2024',
                    source: 'Direct',
                    price: '',
                    read: false,
                  ),

                  const SizedBox(height: 20),

                  // Notification Settings + Quick Stats Section
                  _buildSettingsSection(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
      String title, String value, String subtitle, Color color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(4),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black87),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: TextStyle(color: Colors.grey.shade700),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationCard({
    required String title,
    required String description,
    required String priority,
    required Color priorityColor,
    required String date,
    required String source,
    required String price,
    required bool read,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title + status dot
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
                Icon(Icons.circle,
                    size: 10, color: read ? Colors.grey : Colors.blue),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              description,
              style: const TextStyle(color: Colors.black87),
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: priorityColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                priority,
                style: TextStyle(color: _darken(priorityColor, 0.2), fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Text(date, style: TextStyle(color: Colors.grey.shade700)),
                const SizedBox(width: 8),
                Text('• $source', style: TextStyle(color: Colors.grey.shade700)),
                if (price.isNotEmpty) ...[
                  const SizedBox(width: 8),
                  Text('• $price', style: TextStyle(color: Colors.green.shade700, fontWeight: FontWeight.w600)),
                ],
              ],
            ),
            const SizedBox(height: 6),
            TextButton(
              onPressed: () {},
              child: const Text('Read'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsSection() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Notification Settings',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
      const Text('Customize your alerts',
        style: TextStyle(color: Color(0xFF4B5563))),
            const SizedBox(height: 16),
            _buildSettingItem('New Bookings',
                'Get notified of new reservations', Colors.blue),
            _buildSettingItem('Check-in Reminders',
                'Guest check-in notifications', Colors.green),
            _buildSettingItem(
                'Inventory Alerts', 'Low stock notifications', Colors.red),
            _buildSettingItem(
                'Payment Updates', 'Payment confirmations', Colors.green),
            _buildSettingItem(
                'Reviews & Ratings', 'New guest reviews', Colors.blue),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            const Text(
              'Quick Stats',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
      const Text('This week: 12 notifications', style: TextStyle(color: Colors.black87)),
      const Text('Last month: 48 notifications', style: TextStyle(color: Colors.black87)),
      const Text('Most active: Booking alerts', style: TextStyle(color: Colors.black87)),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem(String title, String subtitle, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(Icons.circle, color: color, size: 14),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(subtitle, style: TextStyle(color: Colors.grey.shade700)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _darken(Color color, [double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(color);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }
}

import 'package:flutter/material.dart';
import '../widgets/navigation.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool newBookings = true;
  bool checkInReminders = true;
  bool inventoryAlerts = true;
  bool maintenanceUpdates = false;
  bool paymentNotifications = true;
  bool reviewNotifications = true;

  // Add state variables for the other switches
  bool twoFactorAuth = false;
  bool loginAlerts = true;
  bool darkMode = false;
  bool autoSyncData = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const NavigationWidget(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Notification Preferences Section
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.notifications_outlined,
                                color: Color(0xFF6B7280),
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Notification Preferences',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF1F2937),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Choose which notifications you want to receive',
                            style: TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
                          ),
                          const SizedBox(height: 24),

                          // Notification toggles
                          _buildNotificationTile(
                            'New Bookings',
                            'Get notified when new reservations are made',
                            newBookings,
                            (value) => setState(() => newBookings = value),
                          ),
                          _buildNotificationTile(
                            'Check-in Reminders',
                            'Reminders for upcoming guest check-ins',
                            checkInReminders,
                            (value) => setState(() => checkInReminders = value),
                          ),
                          _buildNotificationTile(
                            'Inventory Alerts',
                            'Low stock and restocking alerts',
                            inventoryAlerts,
                            (value) => setState(() => inventoryAlerts = value),
                          ),
                          _buildNotificationTile(
                            'Maintenance Updates',
                            'Housekeeping and maintenance task updates',
                            maintenanceUpdates,
                            (value) => setState(() => maintenanceUpdates = value),
                          ),
                          _buildNotificationTile(
                            'Payment Notifications',
                            'Payment confirmations and updates',
                            paymentNotifications,
                            (value) => setState(() => paymentNotifications = value),
                          ),
                          _buildNotificationTile(
                            'Review Notifications',
                            'New guest reviews and ratings',
                            reviewNotifications,
                            (value) => setState(() => reviewNotifications = value),
                            isLast: true,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Platform Integrations Section
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.language,
                                color: Color(0xFF6B7280),
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Platform Integrations',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF1F2937),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Connect and manage your booking platform integrations',
                            style: TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
                          ),
                          const SizedBox(height: 24),

                          // Platform integration tiles
                          _buildPlatformTile(
                            'Airbnb',
                            'Connected • Last sync 2 hours ago',
                            'A',
                            Colors.red,
                            true,
                          ),
                          const SizedBox(height: 16),
                          _buildPlatformTile(
                            'Booking.com',
                            'Connected • Last sync 1 hour ago',
                            'B',
                            Colors.blue,
                            true,
                          ),
                          const SizedBox(height: 16),
                          _buildPlatformTile(
                            'VRBO',
                            'Not connected',
                            'V',
                            Colors.grey,
                            false,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Two-Factor Authentication & Login Alerts Section
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Two-Factor Authentication
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Two-Factor Authentication',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF1F2937),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    const Text(
                                      'Add extra security to your account',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Color(0xFF6B7280),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Switch(
                                value: twoFactorAuth,
                                onChanged: (value) {
                                  setState(() {
                                    twoFactorAuth = value;
                                  });
                                },
                                activeColor: Colors.black,
                                activeTrackColor: Colors.black.withOpacity(0.3),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Divider(color: const Color(0xFFE5E7EB), height: 1),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Login Alerts',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF1F2937),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    const Text(
                                      'Get notified of new sign-ins',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Color(0xFF6B7280),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Switch(
                                value: loginAlerts,
                                onChanged: (value) {
                                  setState(() {
                                    loginAlerts = value;
                                  });
                                },
                                activeColor: Colors.black,
                                activeTrackColor: Colors.black.withOpacity(0.3),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // App Preferences Section
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.smartphone,
                                color: Color(0xFF6B7280),
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'App Preferences',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF1F2937),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Customize your app experience',
                            style: TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
                          ),
                          const SizedBox(height: 24),

                          _buildPreferenceTile('Time Zone', 'UTC-5 (Eastern Time)'),
                          const SizedBox(height: 20),
                          _buildPreferenceTile('Default Currency', 'USD (\$)'),
                          const SizedBox(height: 20),
                          _buildPreferenceTile('Date Format', 'MM/DD/YYYY'),
                          const SizedBox(height: 20),

                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Dark Mode',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF1F2937),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    const Text(
                                      'Switch to dark theme',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Color(0xFF6B7280),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Switch(
                                value: darkMode,
                                onChanged: (value) {
                                  setState(() {
                                    darkMode = value;
                                  });
                                },
                                activeColor: Colors.black,
                                activeTrackColor: Colors.black.withOpacity(0.3),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Divider(color: const Color(0xFFE5E7EB), height: 1),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Auto-sync Data',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF1F2937),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    const Text(
                                      'Sync with booking platforms hourly',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Color(0xFF6B7280),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Switch(
                                value: autoSyncData,
                                onChanged: (value) {
                                  setState(() {
                                    autoSyncData = value;
                                  });
                                },
                                activeColor: Colors.black,
                                activeTrackColor: Colors.black.withOpacity(0.3),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Data Management Section
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.storage,
                                color: Color(0xFF6B7280),
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Data Management',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF1F2937),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Export or delete your data',
                            style: TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
                          ),
                          const SizedBox(height: 24),

                          _buildDataManagementButton('Export All Data'),
                          const SizedBox(height: 12),
                          _buildDataManagementButton('Download Reports'),
                          const SizedBox(height: 20),

                          // Delete Account Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFEF4444),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                'Delete Account',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Account deletion is permanent and cannot be undone.',
                            style: TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreferenceTile(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xFF1F2937),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Text(
            value,
            style: const TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
          ),
        ),
      ],
    );
  }

  Widget _buildDataManagementButton(String title) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () {},
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF1F2937),
          side: const BorderSide(color: Color(0xFFE5E7EB)),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  Widget _buildNotificationTile(
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged, {
    bool isLast = false,
  }) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ),
            Switch(
              value: value,
              onChanged: onChanged,
              activeColor: Colors.black,
              activeTrackColor: Colors.black.withOpacity(0.3),
            ),
          ],
        ),
        if (!isLast) ...[
          const SizedBox(height: 20),
          Divider(color: const Color(0xFFE5E7EB), height: 1),
          const SizedBox(height: 20),
        ],
      ],
    );
  }

  Widget _buildPlatformTile(
    String title,
    String subtitle,
    String initial,
    Color color,
    bool isConnected,
  ) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              initial,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1F2937),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        if (isConnected) ...[
          TextButton(
            onPressed: () {},
            child: const Text(
              'Sync Now',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 8),
          TextButton(
            onPressed: () {},
            child: const Text(
              'Configure',
              style: TextStyle(
                color: Color(0xFF6B7280),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ] else
          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              side: const BorderSide(color: Color(0xFFE5E7EB)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Connect'),
          ),
      ],
    );
  }
}

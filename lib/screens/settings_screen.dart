import 'package:flutter/material.dart';
import '../widgets/navigation.dart';

/// Settings screen with notification preferences, platform integrations, app preferences, and data management.
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Notification preferences state
  bool newBookingsNotification = true;
  bool checkinRemindersNotification = true;
  bool inventoryAlertsNotification = true;
  bool maintenanceUpdatesNotification = false;
  bool paymentNotifications = true;
  bool reviewNotifications = true;

  // App preferences state
  bool darkMode = false;
  bool autoSyncData = true;
  String timezone = 'UTC-5 (Eastern Time)';
  String currency = 'USD (\$)';
  String dateFormat = 'MM/DD/YYYY';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFF8FAFC), // slate-50
              Color(0xFFF9FAFB), // gray-50
              Color(0xFFFAFAFA), // zinc-50
            ],
          ),
        ),
        child: Column(
          children: [
            const NavigationWidget(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade600,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.settings,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Settings',
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF111827),
                                  ),
                                ),
                                Text(
                                  'Manage your account and application preferences',
                                  style: const TextStyle(
                                    color: Color(0xFF6B7280),
                                    fontSize: 14,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Notification Preferences
                    _buildNotificationPreferences(),
                    const SizedBox(height: 24),

                    // Platform Integrations
                    _buildPlatformIntegrations(),
                    const SizedBox(height: 24),

                    // App Preferences
                    _buildAppPreferences(),
                    const SizedBox(height: 24),

                    // Data Management
                    _buildDataManagement(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationPreferences() {
    return _buildCard(
      icon: Icons.notifications_outlined,
      title: 'Notification Preferences',
      subtitle: 'Choose which notifications you want to receive',
      child: Column(
        children: [
          _buildSwitchListTile(
            title: 'New Bookings',
            subtitle: 'Get notified when new reservations are made',
            value: newBookingsNotification,
            onChanged: (value) => setState(() => newBookingsNotification = value),
          ),
          _buildSwitchListTile(
            title: 'Check-in Reminders',
            subtitle: 'Reminders for upcoming guest check-ins',
            value: checkinRemindersNotification,
            onChanged: (value) => setState(() => checkinRemindersNotification = value),
          ),
          _buildSwitchListTile(
            title: 'Inventory Alerts',
            subtitle: 'Low stock and restocking alerts',
            value: inventoryAlertsNotification,
            onChanged: (value) => setState(() => inventoryAlertsNotification = value),
          ),
          _buildSwitchListTile(
            title: 'Maintenance Updates',
            subtitle: 'Housekeeping and maintenance task updates',
            value: maintenanceUpdatesNotification,
            onChanged: (value) => setState(() => maintenanceUpdatesNotification = value),
          ),
          _buildSwitchListTile(
            title: 'Payment Notifications',
            subtitle: 'Payment confirmations and updates',
            value: paymentNotifications,
            onChanged: (value) => setState(() => paymentNotifications = value),
          ),
          _buildSwitchListTile(
            title: 'Review Notifications',
            subtitle: 'New guest reviews and ratings',
            value: reviewNotifications,
            onChanged: (value) => setState(() => reviewNotifications = value),
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildPlatformIntegrations() {
    return _buildCard(
      icon: Icons.language,
      title: 'Platform Integrations',
      subtitle: 'Connect and manage your booking platform integrations',
      child: Column(
        children: [
          _buildPlatformTile(
            name: 'Airbnb',
            initial: 'A',
            color: Colors.red,
            status: 'Connected • Last sync: 2 hours ago',
            isConnected: true,
          ),
          const SizedBox(height: 16),
          _buildPlatformTile(
            name: 'Booking.com',
            initial: 'B',
            color: Colors.blue,
            status: 'Connected • Last sync: 1 hour ago',
            isConnected: true,
          ),
        ],
      ),
    );
  }

  Widget _buildAppPreferences() {
    return _buildCard(
      icon: Icons.smartphone,
      title: 'App Preferences',
      subtitle: 'Customize your app experience',
      child: Column(
        children: [
          _buildInputField(
            label: 'Time Zone',
            value: timezone,
            onChanged: (value) => setState(() => timezone = value),
          ),
          const SizedBox(height: 16),
          _buildInputField(
            label: 'Default Currency',
            value: currency,
            onChanged: (value) => setState(() => currency = value),
          ),
          const SizedBox(height: 16),
          _buildInputField(
            label: 'Date Format',
            value: dateFormat,
            onChanged: (value) => setState(() => dateFormat = value),
          ),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 16),
          _buildSwitchListTile(
            title: 'Dark Mode',
            subtitle: 'Switch to dark theme',
            value: darkMode,
            onChanged: (value) => setState(() => darkMode = value),
          ),
          const SizedBox(height: 16),
          _buildSwitchListTile(
            title: 'Auto-sync Data',
            subtitle: 'Sync with booking platforms hourly',
            value: autoSyncData,
            onChanged: (value) => setState(() => autoSyncData = value),
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildDataManagement() {
    return _buildCard(
      icon: Icons.storage,
      title: 'Data Management',
      subtitle: 'Export or delete your data',
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                // Export all data functionality
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Exporting all data...')),
                );
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                side: const BorderSide(color: Colors.black),
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              child: const Text('Export All Data', style: TextStyle(fontWeight: FontWeight.w500)),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                // Download reports functionality
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Downloading reports...')),
                );
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                side: const BorderSide(color: Colors.black),
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              child: const Text('Download Reports', style: TextStyle(fontWeight: FontWeight.w500)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Widget child,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 20, color: const Color(0xFF374151)),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF111827),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF6B7280),
              ),
            ),
            const SizedBox(height: 20),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchListTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    bool isLast = false,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: isLast ? 0 : 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF111827),
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF6B7280),
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Transform.scale(
            scale: 1.1,
            child: Switch(
              value: value,
              onChanged: onChanged,
              activeColor: Colors.black,
              activeTrackColor: Colors.grey.shade300,
              inactiveThumbColor: Colors.grey.shade400,
              inactiveTrackColor: Colors.grey.shade200,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlatformTile({
    required String name,
    required String initial,
    required Color color,
    required String status,
    required bool isConnected,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: color.withOpacity(0.2)),
            ),
            child: Center(
              child: Text(
                initial,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
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
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF111827),
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: isConnected ? const Color(0xFF10B981) : Colors.grey.shade400,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        status,
                        style: TextStyle(
                          fontSize: 13,
                          color: isConnected ? const Color(0xFF059669) : Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          if (isConnected) ...[
            _buildActionButton(
              text: 'Sync',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Syncing $name...')),
                );
              },
              isPrimary: true,
            ),
            const SizedBox(width: 8),
            _buildActionButton(
              text: 'Config',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Configuring $name...')),
                );
              },
              isPrimary: false,
            ),
          ] else
            _buildActionButton(
              text: 'Connect',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Connecting to $name...')),
                );
              },
              isPrimary: true,
            ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String text,
    required VoidCallback onPressed,
    required bool isPrimary,
  }) {
    return Container(
      height: 32,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary ? Colors.black : Colors.white,
          foregroundColor: isPrimary ? Colors.white : Colors.black,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          side: isPrimary ? null : const BorderSide(color: Colors.black),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          minimumSize: Size.zero,
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required String value,
    required ValueChanged<String> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            color: Color(0xFF374151),
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          initialValue: value,
          onChanged: onChanged,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(color: Color(0xFF3B82F6)),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          ),
        ),
      ],
    );
}
}
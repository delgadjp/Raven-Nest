import 'package:flutter/material.dart';
import '../widgets/navigation.dart';
import '../widgets/section_header.dart';
import '../widgets/settings_card.dart';
import '../widgets/settings_switch_tile.dart';
import '../widgets/platform_tile.dart';
import '../widgets/settings_input_field.dart';
import '../widgets/action_button.dart';

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
                    SectionHeader(
                      title: 'Settings',
                      subtitle: 'Manage your account and application preferences',
                      icon: Icons.settings,
                      iconColor: Colors.grey.shade600,
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
    return SettingsCard(
      icon: Icons.notifications_outlined,
      title: 'Notification Preferences',
      subtitle: 'Choose which notifications you want to receive',
      child: Column(
        children: [
          SettingsSwitchTile(
            title: 'New Bookings',
            subtitle: 'Get notified when new reservations are made',
            value: newBookingsNotification,
            onChanged: (value) => setState(() => newBookingsNotification = value),
          ),
          SettingsSwitchTile(
            title: 'Check-in Reminders',
            subtitle: 'Reminders for upcoming guest check-ins',
            value: checkinRemindersNotification,
            onChanged: (value) => setState(() => checkinRemindersNotification = value),
          ),
          SettingsSwitchTile(
            title: 'Inventory Alerts',
            subtitle: 'Low stock and restocking alerts',
            value: inventoryAlertsNotification,
            onChanged: (value) => setState(() => inventoryAlertsNotification = value),
          ),
          SettingsSwitchTile(
            title: 'Maintenance Updates',
            subtitle: 'Housekeeping and maintenance task updates',
            value: maintenanceUpdatesNotification,
            onChanged: (value) => setState(() => maintenanceUpdatesNotification = value),
          ),
          SettingsSwitchTile(
            title: 'Payment Notifications',
            subtitle: 'Payment confirmations and updates',
            value: paymentNotifications,
            onChanged: (value) => setState(() => paymentNotifications = value),
          ),
          SettingsSwitchTile(
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
    return SettingsCard(
      icon: Icons.language,
      title: 'Platform Integrations',
      subtitle: 'Connect and manage your booking platform integrations',
      child: Column(
        children: [
          PlatformTile(
            name: 'Airbnb',
            initial: 'A',
            color: Colors.red,
            status: 'Connected • Last sync: 2 hours ago',
            isConnected: true,
            onSync: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Syncing Airbnb...')),
              );
            },
            onConfig: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Configuring Airbnb...')),
              );
            },
          ),
          const SizedBox(height: 16),
          PlatformTile(
            name: 'Booking.com',
            initial: 'B',
            color: Colors.blue,
            status: 'Connected • Last sync: 1 hour ago',
            isConnected: true,
            onSync: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Syncing Booking.com...')),
              );
            },
            onConfig: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Configuring Booking.com...')),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAppPreferences() {
    return SettingsCard(
      icon: Icons.smartphone,
      title: 'App Preferences',
      subtitle: 'Customize your app experience',
      child: Column(
        children: [
          SettingsInputField(
            label: 'Time Zone',
            value: timezone,
            onChanged: (value) => setState(() => timezone = value),
          ),
          const SizedBox(height: 16),
          SettingsInputField(
            label: 'Default Currency',
            value: currency,
            onChanged: (value) => setState(() => currency = value),
          ),
          const SizedBox(height: 16),
          SettingsInputField(
            label: 'Date Format',
            value: dateFormat,
            onChanged: (value) => setState(() => dateFormat = value),
          ),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 16),
          SettingsSwitchTile(
            title: 'Dark Mode',
            subtitle: 'Switch to dark theme',
            value: darkMode,
            onChanged: (value) => setState(() => darkMode = value),
          ),
          const SizedBox(height: 16),
          SettingsSwitchTile(
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
    return SettingsCard(
      icon: Icons.storage,
      title: 'Data Management',
      subtitle: 'Export or delete your data',
      child: Column(
        children: [
          ActionButton(
            text: 'Export All Data',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Exporting all data...')),
              );
            },
            isOutlined: true,
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
          const SizedBox(height: 16),
          ActionButton(
            text: 'Download Reports',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Downloading reports...')),
              );
            },
            isOutlined: true,
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
        ],
      ),
    );
  }
}
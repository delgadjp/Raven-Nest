import 'dart:async';

import '../constants/app_exports.dart';

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
  Timer? _autoSyncTimer;
  bool _isSyncInProgress = false;
  bool _isExportInProgress = false;
  static const Duration _autoSyncInterval = Duration(hours: 1);
  final List<String> timezoneOptions = const [
    'UTC+8 (Philippine Time)',
    'UTC+9 (Japan Standard Time)',
    'UTC (Coordinated Universal Time)',
    'UTC-5 (Eastern Time)',
    'UTC+1 (Central European Time)',
  ];

  final List<String> currencyOptions = const [
    'PHP (₱)',
    'USD (\$)',
    'EUR (€)',
    'JPY (¥)',
    'AUD (\$)',
  ];

  final List<String> dateFormatOptions = const [
    'DD/MM/YYYY',
    'MM/DD/YYYY',
    'YYYY-MM-DD',
    'MMMM D, YYYY',
  ];

  String timezone = 'UTC+8 (Philippine Time)';
  String currency = 'PHP (₱)';
  String dateFormat = 'DD/MM/YYYY';

  @override
  void initState() {
    super.initState();
    if (autoSyncData) {
      // Kick off auto-sync after the first frame to ensure context is ready for snackbars.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _startAutoSync(immediate: false);
        }
      });
    }
  }

  @override
  void dispose() {
    _autoSyncTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      colors: const [
        Color(0xFFF8FAFC), // slate-50
        Color(0xFFF9FAFB), // gray-50
        Color(0xFFFAFAFA), // zinc-50
      ],
      child: Column(
        children: [
          const NavigationWidget(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
          SettingsDropdownField(
            label: 'Time Zone',
            value: timezone,
            options: timezoneOptions,
            onChanged: (value) => setState(() => timezone = value),
          ),
          const SizedBox(height: 16),
          SettingsDropdownField(
            label: 'Default Currency',
            value: currency,
            options: currencyOptions,
            onChanged: (value) => setState(() => currency = value),
          ),
          const SizedBox(height: 16),
          SettingsDropdownField(
            label: 'Date Format',
            value: dateFormat,
            options: dateFormatOptions,
            onChanged: (value) => setState(() => dateFormat = value),
            helperText: 'Common formats based on popular booking channels',
          ),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 16),
          SettingsSwitchTile(
            title: 'Auto-sync Data',
            subtitle: 'Sync with booking platforms hourly',
            value: autoSyncData,
            onChanged: _toggleAutoSync,
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
            onPressed: _onExportButtonPressed,
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

  void _toggleAutoSync(bool value) {
    if (value == autoSyncData) {
      return;
    }

    setState(() => autoSyncData = value);

    if (value) {
      _startAutoSync();
    } else {
      _stopAutoSync();
    }
  }

  void _startAutoSync({bool immediate = true}) {
    _autoSyncTimer?.cancel();

    if (immediate) {
      _performAutoSync();
    }

    _autoSyncTimer = Timer.periodic(_autoSyncInterval, (_) {
      _performAutoSync(showFeedback: false);
    });

    _showSnackBar('Auto-sync enabled. We\'ll refresh every hour.');
  }

  void _stopAutoSync({bool showFeedback = true}) {
    _autoSyncTimer?.cancel();
    _autoSyncTimer = null;

    if (showFeedback) {
      _showSnackBar('Auto-sync disabled. You can re-enable it anytime.');
    }
  }

  Future<void> _performAutoSync({bool showFeedback = true}) async {
    if (_isSyncInProgress || !mounted) {
      return;
    }

    setState(() => _isSyncInProgress = true);

    try {
      final calendarUrls = await CalendarImportService.getStoredCalendarUrls();

      if (calendarUrls.isEmpty) {
        if (showFeedback) {
          _showSnackBar('Auto-sync skipped. Add calendar URLs to get started.');
        }
        return;
      }

      final results = await CalendarImportService.syncMultipleCalendars(calendarUrls);

      if (showFeedback) {
        final total = results.length;
        final successes = results.values.where((result) => result.success).length;
        final failures = total - successes;
        _showSnackBar('Auto-sync complete: $successes success, $failures failed.');
      }
    } catch (e) {
      if (showFeedback) {
        _showSnackBar('Auto-sync failed: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isSyncInProgress = false);
      }
    }
  }

  void _showSnackBar(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  // --- Data Export helpers ---
  Future<void> _onExportButtonPressed() async {
    if (!mounted) return;
    if (_isExportInProgress) {
      _showSnackBar('An export is already in progress…');
      return;
    }

    final range = await _pickExportRange();
    if (range == null) return;

    final format = await _pickExportFormat();
    if (format == null) return;

    await _exportData(range, format);
  }

  Future<ExportRange?> _pickExportRange() async {
    return showModalBottomSheet<ExportRange>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.today_outlined),
                title: const Text('Today'),
                onTap: () => Navigator.of(ctx).pop(ExportRange.today),
              ),
              ListTile(
                leading: const Icon(Icons.view_week_outlined),
                title: const Text('This Week'),
                onTap: () => Navigator.of(ctx).pop(ExportRange.week),
              ),
              ListTile(
                leading: const Icon(Icons.calendar_view_month_outlined),
                title: const Text('This Month'),
                onTap: () => Navigator.of(ctx).pop(ExportRange.month),
              ),
              ListTile(
                leading: const Icon(Icons.calendar_today_outlined),
                title: const Text('This Year'),
                onTap: () => Navigator.of(ctx).pop(ExportRange.year),
              ),
              const Divider(height: 8),
              ListTile(
                leading: const Icon(Icons.all_inbox_outlined),
                title: const Text('All Data'),
                onTap: () => Navigator.of(ctx).pop(ExportRange.all),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _exportData(ExportRange range, ExportFormat format) async {
    if (!mounted) return;
    if (_isExportInProgress) return;

    setState(() => _isExportInProgress = true);
    _showSnackBar('Exporting ${_exportLabel(range)} as ${format.name.toUpperCase()}…');

    try {
      final result = await DataExportService.exportAllData(range, format: format);
      final suffix = result.fileName != null ? ' (${result.fileName})' : '';
      _showSnackBar(result.message + suffix);
    } catch (e) {
      _showSnackBar('Export failed: $e');
    } finally {
      if (mounted) {
        setState(() => _isExportInProgress = false);
      }
    }
  }

  Future<ExportFormat?> _pickExportFormat() {
    return showModalBottomSheet<ExportFormat>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const ListTile(
                title: Text('Choose export format'),
                subtitle: Text('Select how you want to export your data'),
              ),
              ListTile(
                leading: const Icon(Icons.grid_on_outlined),
                title: const Text('CSV (Spreadsheet)'),
                onTap: () => Navigator.of(ctx).pop(ExportFormat.csv),
              ),
              ListTile(
                leading: const Icon(Icons.picture_as_pdf_outlined),
                title: const Text('PDF (Printable)'),
                onTap: () => Navigator.of(ctx).pop(ExportFormat.pdf),
              ),
            ],
          ),
        );
      },
    );
  }

  String _exportLabel(ExportRange range) {
    switch (range) {
      case ExportRange.today:
        return 'Today';
      case ExportRange.week:
        return 'This Week';
      case ExportRange.month:
        return 'This Month';
      case ExportRange.year:
        return 'This Year';
      case ExportRange.all:
        return 'All Data';
    }
  }
}
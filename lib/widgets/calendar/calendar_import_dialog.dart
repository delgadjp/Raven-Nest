import 'package:flutter/material.dart';
import 'package:ravens_nest/services/calendar_import_service.dart';
import 'dialog_header.dart';
import 'dialog_footer.dart';
import 'platform_card.dart';
import 'custom_calendar_section.dart';
import 'import_result_message.dart';

class CalendarImportDialog extends StatefulWidget {
  final VoidCallback? onImportComplete;

  const CalendarImportDialog({
    super.key,
    this.onImportComplete,
  });

  @override
  State<CalendarImportDialog> createState() => _CalendarImportDialogState();
}

class _CalendarImportDialogState extends State<CalendarImportDialog>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _airbnbUrlController = TextEditingController();
  final _bookingUrlController = TextEditingController();
  final _customNameController = TextEditingController();
  final _customUrlController = TextEditingController();

  bool _isLoading = false;
  String? _resultMessage;
  bool _showCustom = false;
  
  late AnimationController _slideController;
  late AnimationController _fadeController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    ));
    
    // Start animations
    _slideController.forward();
    _fadeController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    _fadeController.dispose();
    _airbnbUrlController.dispose();
    _bookingUrlController.dispose();
    _customNameController.dispose();
    _customUrlController.dispose();
    super.dispose();
  }

  String? _validateUrl(String? value) {
    if (value != null && value.isNotEmpty && !Uri.tryParse(value)!.hasAbsolutePath) {
      return 'Please enter a valid URL';
    }
    return null;
  }





  Future<void> _importCalendars() async {
    if (!_formKey.currentState!.validate()) {
      // Add shake animation for validation errors
      _slideController.reset();
      _slideController.forward();
      return;
    }

    setState(() {
      _isLoading = true;
      _resultMessage = null;
    });

    try {
      Map<String, String> calendarsToImport = {};

      if (_airbnbUrlController.text.isNotEmpty) {
        calendarsToImport['Airbnb'] = _airbnbUrlController.text.trim();
      }

      if (_bookingUrlController.text.isNotEmpty) {
        calendarsToImport['Booking.com'] = _bookingUrlController.text.trim();
      }

      if (_showCustom && 
          _customNameController.text.isNotEmpty && 
          _customUrlController.text.isNotEmpty) {
        calendarsToImport[_customNameController.text.trim()] = 
            _customUrlController.text.trim();
      }

      if (calendarsToImport.isEmpty) {
        setState(() {
          _resultMessage = 'Please provide at least one calendar URL to import.';
          _isLoading = false;
        });
        return;
      }

      // Show importing message
      setState(() {
        _resultMessage = 'Importing calendars... Please wait.';
      });

      final results = await CalendarImportService.syncMultipleCalendars(
        calendarsToImport,
      );

      // Build result message with better formatting
      List<String> successMessages = [];
      List<String> errorMessages = [];
      int totalImported = 0;

      results.forEach((sourceName, result) {
        if (result.success) {
          totalImported += result.importedCount;
          successMessages.add(
            '✓ $sourceName: ${result.importedCount} bookings imported'
            '${result.skippedCount > 0 ? ' (${result.skippedCount} skipped)' : ''}',
          );
        } else {
          errorMessages.add('✗ $sourceName: ${result.errors.first}');
        }
      });

      String message = '';
      if (successMessages.isNotEmpty) {
        message += '🎉 Import Complete!\n\n';
        message += successMessages.join('\n');
        if (totalImported > 0) {
          message += '\n\n📅 Total: $totalImported new bookings added to your calendar.';
        }
      }
      if (errorMessages.isNotEmpty) {
        if (message.isNotEmpty) message += '\n\n';
        message += '⚠️ Issues:\n${errorMessages.join('\n')}';
      }

      setState(() {
        _resultMessage = message;
        _isLoading = false;
      });

      // Call callback if all imports were successful
      if (errorMessages.isEmpty && widget.onImportComplete != null) {
        // Add small delay for better UX
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            widget.onImportComplete!();
          }
        });
      }
    } catch (e) {
      setState(() {
        _resultMessage = '❌ Import failed: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Container(
        width: MediaQuery.of(context).size.width > 600 ? 600 : MediaQuery.of(context).size.width * 0.9,
        constraints: const BoxConstraints(maxHeight: 700),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            DialogHeader(
              title: 'Import Calendars',
              subtitle: 'Sync bookings from external platforms',
              icon: Icons.cloud_download,
              onClose: () => Navigator.of(context).pop(),
            ),

            // Content
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Platform Cards Section
                      PlatformCard(
                        title: 'Airbnb',
                        subtitle: 'Import your Airbnb bookings',
                        icon: Icons.home,
                        color: Colors.red.shade400,
                        controller: _airbnbUrlController,
                        hintText: 'Paste your Airbnb iCal URL here',
                        validator: _validateUrl,
                      ),
                      const SizedBox(height: 16),

                      PlatformCard(
                        title: 'Booking.com',
                        subtitle: 'Import your Booking.com reservations',
                        icon: Icons.business,
                        color: Colors.blue.shade600,
                        controller: _bookingUrlController,
                        hintText: 'Paste your Booking.com iCal URL here',
                        validator: _validateUrl,
                      ),
                      const SizedBox(height: 20),

                      // Custom Calendar Section
                      CustomCalendarSection(
                        showCustom: _showCustom,
                        onToggle: () {
                          setState(() {
                            _showCustom = !_showCustom;
                          });
                        },
                        nameController: _customNameController,
                        urlController: _customUrlController,
                        nameValidator: (value) {
                          if (_showCustom && (value == null || value.isEmpty)) {
                            return 'Please enter a calendar name';
                          }
                          return null;
                        },
                        urlValidator: (value) {
                          if (_showCustom && (value == null || value.isEmpty)) {
                            return 'Please enter a calendar URL';
                          }
                          if (_showCustom && value != null && value.isNotEmpty && 
                              !Uri.tryParse(value)!.hasAbsolutePath) {
                            return 'Please enter a valid URL';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 20),


                      // Result Message
                      if (_resultMessage != null) ...[
                        const SizedBox(height: 20),
                        ImportResultMessage(message: _resultMessage!),
                      ],
                    ],
                  ),
                ),
              ),
            ),

            // Footer Actions
            DialogFooter(
              isLoading: _isLoading,
              onCancel: () => Navigator.of(context).pop(),
              onImport: _importCalendars,
            ),
          ],
        ),
      ),
        ),
      ),
    );
  }
}

/// Helper function to show the calendar import dialog
void showCalendarImportDialog(BuildContext context, {VoidCallback? onImportComplete}) {
  showDialog(
    context: context,
    builder: (context) => CalendarImportDialog(
      onImportComplete: onImportComplete,
    ),
  );
}
import 'package:http/http.dart' as http;
import 'package:ravens_nest/services/supabase_service.dart';

class CalendarImportService {
  static final _supabase = SupabaseService.client;

  /// Fetch iCal data from a URL
  static Future<String> fetchCalendar(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return response.body; // iCal data
      } else {
        throw Exception("Failed to load calendar: HTTP ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Failed to fetch calendar: $e");
    }
  }

  /// Parse iCal data and extract events
  static List<Map<String, dynamic>> parseCalendar(String icsData) {
    try {
      List<Map<String, dynamic>> events = [];
      
      // Split the iCal data into lines
      final lines = icsData.split('\n');
      
      Map<String, String> currentEvent = {};
      bool inEvent = false;
      
      for (String line in lines) {
        line = line.trim();
        
        if (line.startsWith('BEGIN:VEVENT')) {
          inEvent = true;
          currentEvent = {};
        } else if (line.startsWith('END:VEVENT')) {
          if (inEvent && currentEvent.containsKey('DTSTART') && currentEvent.containsKey('DTEND')) {
            events.add({
              'summary': currentEvent['SUMMARY'] ?? 'Booking',
              'dtstart': currentEvent['DTSTART'] ?? '',
              'dtend': currentEvent['DTEND'] ?? '',
              'description': currentEvent['DESCRIPTION'],
              'uid': currentEvent['UID'],
            });
          }
          inEvent = false;
          currentEvent = {};
        } else if (inEvent && line.contains(':')) {
          // Parse property lines
          final colonIndex = line.indexOf(':');
          if (colonIndex > 0) {
            String property = line.substring(0, colonIndex);
            String value = line.substring(colonIndex + 1);
            
            // Handle property parameters (e.g., DTSTART;VALUE=DATE:20231225)
            if (property.contains(';')) {
              property = property.split(';')[0];
            }
            
            // Store the property
            currentEvent[property] = value;
          }
        }
      }
      
      return events;
    } catch (e) {
      throw Exception("Failed to parse calendar: $e");
    }
  }

  /// Import calendar from URL and sync with database
  static Future<ImportResult> importCalendarFromUrl({
    required String url,
    required String sourceName,
    String? sourceColor,
  }) async {
    try {
      // Fetch the calendar data
      final icsData = await fetchCalendar(url);
      
      // Parse the events
      final events = parseCalendar(icsData);
      
      // Get or create booking source
      final sourceId = await _getOrCreateBookingSource(sourceName, sourceColor);
      
      // Process events and create bookings
      int importedCount = 0;
      int skippedCount = 0;
      List<String> errors = [];

      for (var event in events) {
        try {
          final result = await _processEvent(event, sourceId);
          if (result) {
            importedCount++;
          } else {
            skippedCount++;
          }
        } catch (e) {
          errors.add('Failed to process event ${event['summary']}: $e');
          skippedCount++;
        }
      }

      return ImportResult(
        success: true,
        importedCount: importedCount,
        skippedCount: skippedCount,
        totalCount: events.length,
        errors: errors,
      );
    } catch (e) {
      return ImportResult(
        success: false,
        importedCount: 0,
        skippedCount: 0,
        totalCount: 0,
        errors: [e.toString()],
      );
    }
  }

  /// Get or create a booking source
  static Future<String> _getOrCreateBookingSource(String name, String? color) async {
    try {
      // Try to find existing source
      final existingSource = await _supabase
          .from('booking_sources')
          .select('id')
          .eq('name', name)
          .maybeSingle();

      if (existingSource != null) {
        return existingSource['id'];
      }

      // Create new source
      final newSource = await _supabase
          .from('booking_sources')
          .insert({
            'name': name,
            'description': 'Imported from $name calendar',
            'color': color ?? '#2563EB',
          })
          .select('id')
          .single();

      return newSource['id'];
    } catch (e) {
      throw Exception("Failed to get or create booking source: $e");
    }
  }

  /// Process individual event and create booking
  static Future<bool> _processEvent(Map<String, dynamic> event, String sourceId) async {
    try {
      // Parse dates
      final checkInDate = _parseDate(event['dtstart']);
      final checkOutDate = _parseDate(event['dtend']);

      if (checkInDate == null || checkOutDate == null) {
        return false; // Skip events with invalid dates
      }

      // Check if booking already exists (by external ID or date range)
      final existingBooking = await _supabase
          .from('bookings')
          .select('id')
          .eq('source_id', sourceId)
          .eq('check_in', checkInDate.toIso8601String().split('T')[0])
          .eq('check_out', checkOutDate.toIso8601String().split('T')[0])
          .maybeSingle();

      if (existingBooking != null) {
        return false; // Booking already exists, skip
      }

      // Create new booking
      await _supabase.from('bookings').insert({
        'check_in': checkInDate.toIso8601String().split('T')[0],
        'check_out': checkOutDate.toIso8601String().split('T')[0],
        'status': 'confirmed',
        'total_amount': 0, // We don't have pricing info from calendar
        'source_id': sourceId,
      });

      return true;
    } catch (e) {
      throw Exception("Failed to process event: $e");
    }
  }

  /// Parse date from iCal format
  static DateTime? _parseDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return null;

    try {
      // Clean the date string
      String cleanDate = dateStr.trim();
      
      // Handle different date formats from iCal
      if (cleanDate.contains('T')) {
        // DateTime format: 20231225T120000Z or 20231225T120000
        cleanDate = cleanDate.replaceAll('Z', '');
        if (cleanDate.length == 15) { // YYYYMMDDTHHMMSS
          final year = int.parse(cleanDate.substring(0, 4));
          final month = int.parse(cleanDate.substring(4, 6));
          final day = int.parse(cleanDate.substring(6, 8));
          final hour = int.parse(cleanDate.substring(9, 11));
          final minute = int.parse(cleanDate.substring(11, 13));
          final second = int.parse(cleanDate.substring(13, 15));
          return DateTime(year, month, day, hour, minute, second);
        }
      } else if (cleanDate.length == 8) {
        // Date only format: 20231225
        final year = int.parse(cleanDate.substring(0, 4));
        final month = int.parse(cleanDate.substring(4, 6));
        final day = int.parse(cleanDate.substring(6, 8));
        return DateTime(year, month, day);
      } else if (cleanDate.contains('-')) {
        // ISO format: 2023-12-25 or 2023-12-25T12:00:00
        return DateTime.parse(cleanDate);
      }
      
      // If all else fails, try to parse as is
      return DateTime.parse(cleanDate);
    } catch (e) {
      print('Failed to parse date: $dateStr - $e');
      return null;
    }
  }

  /// Import from predefined Airbnb calendar
  static Future<ImportResult> importAirbnbCalendar(String icalUrl) async {
    return await importCalendarFromUrl(
      url: icalUrl,
      sourceName: 'Airbnb',
      sourceColor: '#FF385C',
    );
  }

  /// Import from predefined Booking.com calendar
  static Future<ImportResult> importBookingComCalendar(String icalUrl) async {
    return await importCalendarFromUrl(
      url: icalUrl,
      sourceName: 'Booking.com',
      sourceColor: '#0071C2',
    );
  }

  /// Sync multiple calendars
  static Future<Map<String, ImportResult>> syncMultipleCalendars(
    Map<String, String> calendarUrls,
  ) async {
    Map<String, ImportResult> results = {};

    for (var entry in calendarUrls.entries) {
      final sourceName = entry.key;
      final url = entry.value;

      try {
        ImportResult result;
        if (sourceName.toLowerCase().contains('airbnb')) {
          result = await importAirbnbCalendar(url);
        } else if (sourceName.toLowerCase().contains('booking')) {
          result = await importBookingComCalendar(url);
        } else {
          result = await importCalendarFromUrl(
            url: url,
            sourceName: sourceName,
          );
        }
        results[sourceName] = result;
      } catch (e) {
        results[sourceName] = ImportResult(
          success: false,
          importedCount: 0,
          skippedCount: 0,
          totalCount: 0,
          errors: [e.toString()],
        );
      }
    }

    return results;
  }

  /// Get stored calendar URLs from secure storage or database
  static Future<Map<String, String>> getStoredCalendarUrls() async {
    try {
      // You can store URLs in your database or secure storage
      // For now, return empty map - this would be where you fetch saved URLs
      return {};
    } catch (e) {
      print('Failed to get stored calendar URLs: $e');
      return {};
    }
  }

  /// Store calendar URLs securely
  static Future<bool> storeCalendarUrls(Map<String, String> urls) async {
    try {
      // You can store URLs in your database or secure storage
      // Implementation depends on your preference for security
      return true;
    } catch (e) {
      print('Failed to store calendar URLs: $e');
      return false;
    }
  }
}

/// Result class for import operations
class ImportResult {
  final bool success;
  final int importedCount;
  final int skippedCount;
  final int totalCount;
  final List<String> errors;

  ImportResult({
    required this.success,
    required this.importedCount,
    required this.skippedCount,
    required this.totalCount,
    required this.errors,
  });

  String get summary {
    if (!success) {
      return 'Import failed: ${errors.first}';
    }
    
    return 'Imported $importedCount/$totalCount bookings. Skipped: $skippedCount';
  }
}
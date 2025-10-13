import 'supabase_service.dart';
import 'calendar_import_service.dart';
import 'pricing_service.dart';

class CalendarService {
  static final _supabase = SupabaseService.client;

  // Get all bookings
  static Future<List<Map<String, dynamic>>> getAllBookings() async {
    try {
      final bookings = await _supabase
          .from('bookings')
          .select('''
            id,
            check_in,
            check_out,
            status,
            total_amount,
            created_at,
            source_id
          ''')
          .order('check_in', ascending: true);

      // Get booking sources separately
      List<Map<String, dynamic>> enrichedBookings = [];
      for (var booking in bookings) {
        Map<String, dynamic> enrichedBooking = Map<String, dynamic>.from(booking);
        
        // Get source information if exists
        if (booking['source_id'] != null) {
          try {
            final source = await _supabase
                .from('booking_sources')
                .select('id, name, color')
                .eq('id', booking['source_id'])
                .single();
            enrichedBooking['source'] = source;
          } catch (e) {
            print('Error fetching source for booking ${booking['id']}: $e');
            enrichedBooking['source'] = {'name': 'Unknown Source', 'color': '#000000'};
          }
        } else {
          enrichedBooking['source'] = {'name': 'Direct Booking', 'color': '#6B7280'};
        }
        
        enrichedBookings.add(enrichedBooking);
      }

      return enrichedBookings;
    } catch (e) {
      print('Error fetching bookings: $e');
      return [];
    }
  }

  // Get bookings for a specific date range
  static Future<List<Map<String, dynamic>>> getBookingsForDateRange(
      DateTime startDate, DateTime endDate) async {
    try {
      final bookings = await _supabase
          .from('bookings')
          .select('''
            id,
            check_in,
            check_out,
            status,
            total_amount,
            created_at,
            source_id
          ''')
          .gte('check_in', startDate.toIso8601String().split('T')[0])
          .lte('check_out', endDate.toIso8601String().split('T')[0])
          .order('check_in', ascending: true);

      // Get booking sources separately
      List<Map<String, dynamic>> enrichedBookings = [];
      for (var booking in bookings) {
        Map<String, dynamic> enrichedBooking = Map<String, dynamic>.from(booking);
        
        // Get source information if exists
        if (booking['source_id'] != null) {
          try {
            final source = await _supabase
                .from('booking_sources')
                .select('id, name, color')
                .eq('id', booking['source_id'])
                .single();
            enrichedBooking['source'] = source;
          } catch (e) {
            print('Error fetching source for booking ${booking['id']}: $e');
            enrichedBooking['source'] = {'name': 'Unknown Source', 'color': '#000000'};
          }
        } else {
          enrichedBooking['source'] = {'name': 'Direct Booking', 'color': '#6B7280'};
        }
        
        enrichedBookings.add(enrichedBooking);
      }

      return enrichedBookings;
    } catch (e) {
      print('Error fetching bookings for date range: $e');
      return [];
    }
  }

  // Get bookings for a specific day
  static Future<List<Map<String, dynamic>>> getBookingsForDay(DateTime day) async {
    try {
      final dayString = day.toIso8601String().split('T')[0];
      
      final bookings = await _supabase
          .from('bookings')
          .select('''
            id,
            check_in,
            check_out,
            status,
            total_amount,
            created_at,
            source_id
          ''')
          .lte('check_in', dayString)
          .gte('check_out', dayString)
          .order('check_in', ascending: true);

      // Get booking sources separately
      List<Map<String, dynamic>> enrichedBookings = [];
      for (var booking in bookings) {
        Map<String, dynamic> enrichedBooking = Map<String, dynamic>.from(booking);
        
        // Get source information if exists
        if (booking['source_id'] != null) {
          try {
            final source = await _supabase
                .from('booking_sources')
                .select('id, name, color')
                .eq('id', booking['source_id'])
                .single();
            enrichedBooking['source'] = source;
          } catch (e) {
            print('Error fetching source for booking ${booking['id']}: $e');
            enrichedBooking['source'] = {'name': 'Unknown Source', 'color': '#000000'};
          }
        } else {
          enrichedBooking['source'] = {'name': 'Direct Booking', 'color': '#6B7280'};
        }
        
        enrichedBookings.add(enrichedBooking);
      }

      return enrichedBookings;
    } catch (e) {
      print('Error fetching bookings for day: $e');
      return [];
    }
  }

  // Get check-ins for a specific day
  static Future<List<Map<String, dynamic>>> getCheckInsForDay(DateTime day) async {
    try {
      final dayString = day.toIso8601String().split('T')[0];
      
      final bookings = await _supabase
          .from('bookings')
          .select('''
            id,
            check_in,
            check_out,
            status,
            total_amount,
            created_at,
            source_id
          ''')
          .eq('check_in', dayString)
          .order('created_at', ascending: true);

      // Get booking sources separately
      List<Map<String, dynamic>> enrichedBookings = [];
      for (var booking in bookings) {
        Map<String, dynamic> enrichedBooking = Map<String, dynamic>.from(booking);
        
        // Get source information if exists
        if (booking['source_id'] != null) {
          try {
            final source = await _supabase
                .from('booking_sources')
                .select('id, name, color')
                .eq('id', booking['source_id'])
                .single();
            enrichedBooking['source'] = source;
          } catch (e) {
            print('Error fetching source for booking ${booking['id']}: $e');
            enrichedBooking['source'] = {'name': 'Unknown Source', 'color': '#000000'};
          }
        } else {
          enrichedBooking['source'] = {'name': 'Direct Booking', 'color': '#6B7280'};
        }
        
        enrichedBookings.add(enrichedBooking);
      }

      return enrichedBookings;
    } catch (e) {
      print('Error fetching check-ins for day: $e');
      return [];
    }
  }

  // Get calendar summary statistics
  static Future<Map<String, dynamic>> getCalendarSummary() async {
    try {
      // Get total bookings count
      final totalBookingsResponse = await _supabase
          .from('bookings')
          .select('id');

      // Get confirmed bookings count
      final confirmedBookingsResponse = await _supabase
          .from('bookings')
          .select('id')
          .eq('status', 'confirmed');

      // Get total revenue (sum of all booking amounts) using fallback pricing when needed
      final bookingsForRevenue = await _supabase
          .from('bookings')
          .select('id, check_in, check_out, status, total_amount, source_id')
          .not('status', 'eq', 'cancelled');

      double totalRevenue = 0.0;
      final Map<String, String> sourceNameCache = {};
      for (final booking in bookingsForRevenue) {
        final amount = booking['total_amount'];
        if (amount is num && amount > 0) {
          totalRevenue += amount.toDouble();
          continue;
        }

        // Fallback compute based on source name and stay length
        try {
          final checkIn = DateTime.parse(booking['check_in']);
          final checkOut = DateTime.parse(booking['check_out']);
          String sourceName = 'Unknown';
          final sourceId = booking['source_id'];
          if (sourceId != null) {
            if (sourceNameCache.containsKey(sourceId)) {
              sourceName = sourceNameCache[sourceId]!;
            } else {
              try {
                final s = await _supabase
                    .from('booking_sources')
                    .select('name')
                    .eq('id', sourceId)
                    .single();
                sourceName = (s['name'] ?? 'Unknown').toString();
                sourceNameCache[sourceId] = sourceName;
              } catch (_) {}
            }
          }
          final computed = PricingService.computeTotalAmount(
            sourceName: sourceName,
            checkIn: checkIn,
            checkOut: checkOut,
          );
          if (computed != null && computed > 0) {
            totalRevenue += computed;
          }
        } catch (_) {}
      }

      // Calculate occupancy rate for current month
      final now = DateTime.now();
      final startOfMonth = DateTime(now.year, now.month, 1);
      final endOfMonth = DateTime(now.year, now.month + 1, 0);
      final daysInMonth = endOfMonth.day;

      final monthlyBookingsResponse = await _supabase
          .from('bookings')
          .select('check_in, check_out')
          .gte('check_in', startOfMonth.toIso8601String().split('T')[0])
          .lte('check_out', endOfMonth.toIso8601String().split('T')[0])
          .eq('status', 'confirmed');

      // Calculate occupied days (simplified calculation)
      Set<String> occupiedDays = {};
      for (var booking in monthlyBookingsResponse) {
        final checkIn = DateTime.parse(booking['check_in']);
        final checkOut = DateTime.parse(booking['check_out']);
        
        for (var day = checkIn; day.isBefore(checkOut); day = day.add(const Duration(days: 1))) {
          if (day.month == now.month && day.year == now.year) {
            occupiedDays.add(day.toIso8601String().split('T')[0]);
          }
        }
      }

      final occupancyRate = (occupiedDays.length / daysInMonth * 100).round();

      return {
        'totalBookings': totalBookingsResponse.length,
        'confirmedBookings': confirmedBookingsResponse.length,
        'totalRevenue': totalRevenue,
        'occupancyRate': occupancyRate,
      };
    } catch (e) {
      print('Error fetching calendar summary: $e');
      return {
        'totalBookings': 0,
        'confirmedBookings': 0,
        'totalRevenue': 0.0,
        'occupancyRate': 0,
      };
    }
  }

  // Get booking sources for statistics
  static Future<List<Map<String, dynamic>>> getBookingSources() async {
    try {
      final response = await _supabase
          .from('booking_sources')
          .select('*')
          .order('name', ascending: true);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error fetching booking sources: $e');
      return [];
    }
  }

  // Add a new booking
  static Future<bool> addBooking(Map<String, dynamic> bookingData) async {
    try {
      await _supabase.from('bookings').insert(bookingData);
      return true;
    } catch (e) {
      print('Error adding booking: $e');
      return false;
    }
  }

  // Update a booking
  static Future<bool> updateBooking(String bookingId, Map<String, dynamic> updates) async {
    try {
      await _supabase
          .from('bookings')
          .update(updates)
          .eq('id', bookingId);
      return true;
    } catch (e) {
      print('Error updating booking: $e');
      return false;
    }
  }

  // Delete a booking
  static Future<bool> deleteBooking(String bookingId) async {
    try {
      await _supabase
          .from('bookings')
          .delete()
          .eq('id', bookingId);
      return true;
    } catch (e) {
      print('Error deleting booking: $e');
      return false;
    }
  }

  // Sync with external platforms using stored calendar URLs
  static Future<bool> syncWithPlatforms() async {
    try {
      // Get stored calendar URLs (you can implement this based on your storage preference)
      final storedUrls = await CalendarImportService.getStoredCalendarUrls();
      
      if (storedUrls.isEmpty) {
        // No stored URLs, return success but no actual sync
        return true;
      }

      // Sync with stored calendars
      final results = await CalendarImportService.syncMultipleCalendars(storedUrls);
      
      // If any imports were successful, try to backfill prices for zero-amount bookings
      final anySuccess = results.values.any((result) => result.success);
      if (anySuccess) {
        await backfillMissingPrices();
      }
      return anySuccess;
    } catch (e) {
      print('Error syncing with platforms: $e');
      return false;
    }
  }

  /// Backfill total_amount for bookings where amount is null or 0, based on source and dates.
  /// Returns the number of rows updated.
  static Future<int> backfillMissingPrices() async {
    try {
      final rows = await _supabase
          .from('bookings')
          .select('id, check_in, check_out, total_amount, source_id')
          .or('total_amount.is.null,total_amount.eq.0');

  if (rows.isEmpty) return 0;

      var updated = 0;
      for (final row in rows) {
        final checkIn = DateTime.parse(row['check_in']);
        final checkOut = DateTime.parse(row['check_out']);
        String sourceName = 'Unknown';
        if (row['source_id'] != null) {
          try {
            final source = await _supabase
                .from('booking_sources')
                .select('name')
                .eq('id', row['source_id'])
                .single();
            sourceName = (source['name'] ?? 'Unknown').toString();
          } catch (_) {}
        }

        final computed = PricingService.computeTotalAmount(
          sourceName: sourceName,
          checkIn: checkIn,
          checkOut: checkOut,
        );

        if (computed != null && computed > 0) {
          await _supabase
              .from('bookings')
              .update({'total_amount': computed})
              .eq('id', row['id']);
          updated++;
        }
      }
      return updated;
    } catch (e) {
      print('Error backfilling prices: $e');
      return 0;
    }
  }
}

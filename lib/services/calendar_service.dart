import 'supabase_service.dart';

class CalendarService {
  static final _supabase = SupabaseService.client;

  // Get all bookings
  static Future<List<Map<String, dynamic>>> getAllBookings() async {
    try {
      final response = await _supabase
          .from('bookings')
          .select('''
            id,
            check_in,
            check_out,
            status,
            total_amount,
            created_at,
            source_id,
            booking_sources!inner(
              id,
              name,
              color
            )
          ''')
          .order('check_in', ascending: true);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error fetching bookings: $e');
      return [];
    }
  }

  // Get bookings for a specific date range
  static Future<List<Map<String, dynamic>>> getBookingsForDateRange(
      DateTime startDate, DateTime endDate) async {
    try {
      final response = await _supabase
          .from('bookings')
          .select('''
            id,
            check_in,
            check_out,
            status,
            total_amount,
            created_at,
            source_id,
            booking_sources!inner(
              id,
              name,
              color
            )
          ''')
          .gte('check_in', startDate.toIso8601String().split('T')[0])
          .lte('check_out', endDate.toIso8601String().split('T')[0])
          .order('check_in', ascending: true);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error fetching bookings for date range: $e');
      return [];
    }
  }

  // Get bookings for a specific day
  static Future<List<Map<String, dynamic>>> getBookingsForDay(DateTime day) async {
    try {
      final dayString = day.toIso8601String().split('T')[0];
      
      final response = await _supabase
          .from('bookings')
          .select('''
            id,
            check_in,
            check_out,
            status,
            total_amount,
            created_at,
            source_id,
            booking_sources!inner(
              id,
              name,
              color
            )
          ''')
          .lte('check_in', dayString)
          .gte('check_out', dayString)
          .order('check_in', ascending: true);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error fetching bookings for day: $e');
      return [];
    }
  }

  // Get check-ins for a specific day
  static Future<List<Map<String, dynamic>>> getCheckInsForDay(DateTime day) async {
    try {
      final dayString = day.toIso8601String().split('T')[0];
      
      final response = await _supabase
          .from('bookings')
          .select('''
            id,
            check_in,
            check_out,
            status,
            total_amount,
            created_at,
            source_id,
            booking_sources!inner(
              id,
              name,
              color
            )
          ''')
          .eq('check_in', dayString)
          .order('created_at', ascending: true);

      return List<Map<String, dynamic>>.from(response);
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

      // Get total revenue (sum of all booking amounts)
      final revenueResponse = await _supabase
          .from('bookings')
          .select('total_amount')
          .not('status', 'eq', 'cancelled');

      double totalRevenue = 0.0;
      if (revenueResponse.isNotEmpty) {
        for (var booking in revenueResponse) {
          if (booking['total_amount'] != null) {
            totalRevenue += (booking['total_amount'] as num).toDouble();
          }
        }
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

  // Sync with external platforms (placeholder for future implementation)
  static Future<bool> syncWithPlatforms() async {
    try {
      // This would integrate with Airbnb, Booking.com APIs
      // For now, just return success
      await Future.delayed(const Duration(seconds: 2)); // Simulate API call
      return true;
    } catch (e) {
      print('Error syncing with platforms: $e');
      return false;
    }
  }
}

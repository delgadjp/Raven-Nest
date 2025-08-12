import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../widgets/navigation.dart';

class Booking {
  final int id;
  final String guestName;
  final DateTime checkIn;
  final DateTime checkOut;
  final String room;
  final String source;
  final String status;
  final int nights;
  final double amount;

  Booking({
    required this.id,
    required this.guestName,
    required this.checkIn,
    required this.checkOut,
    required this.room,
    required this.source,
    required this.status,
    required this.nights,
    required this.amount,
  });
}

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late DateTime _focusedDay;
  DateTime? _selectedDay;

  final List<Booking> bookings = [
    Booking(
      id: 1,
      guestName: "John Smith",
      checkIn: DateTime(2024, 12, 15),
      checkOut: DateTime(2024, 12, 18),
      room: "201",
      source: "Airbnb",
      status: "confirmed",
      nights: 3,
      amount: 450,
    ),
    Booking(
      id: 2,
      guestName: "Sarah Johnson",
      checkIn: DateTime(2024, 12, 20),
      checkOut: DateTime(2024, 12, 25),
      room: "305",
      source: "Booking.com",
      status: "confirmed",
      nights: 5,
      amount: 750,
    ),
    Booking(
      id: 3,
      guestName: "Mike Davis",
      checkIn: DateTime(2024, 12, 28),
      checkOut: DateTime(2024, 12, 30),
      room: "201",
      source: "Airbnb",
      status: "pending",
      nights: 2,
      amount: 300,
    ),
    Booking(
      id: 4,
      guestName: "Emma Wilson",
      checkIn: DateTime(2025, 1, 5),
      checkOut: DateTime(2025, 1, 12),
      room: "305",
      source: "Direct",
      status: "confirmed",
      nights: 7,
      amount: 1050,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    _selectedDay = DateTime.now();
  }

  List<Booking> _getBookingsForDay(DateTime day) {
    return bookings.where((booking) {
      return day.isAfter(booking.checkIn.subtract(const Duration(days: 1))) &&
          day.isBefore(booking.checkOut);
    }).toList();
  }

  Booking? _getCheckInForDay(DateTime day) {
    for (var booking in bookings) {
      if (isSameDay(booking.checkIn, day)) {
        return booking;
      }
    }
    return null;
  }

  bool _isBookedDay(DateTime day) {
    return _getBookingsForDay(day).isNotEmpty;
  }

  List<Booking> get upcomingBookings {
    final now = DateTime.now();
    return bookings
        .where((booking) => booking.checkIn.isAfter(now))
        .toList()
      ..sort((a, b) => a.checkIn.compareTo(b.checkIn));
  }

  double get totalRevenue {
    return bookings.fold(0, (sum, booking) => sum + booking.amount);
  }

  int get confirmedBookings {
    return bookings.where((booking) => booking.status == 'confirmed').length;
  }

  Color _getSourceColor(String source) {
    switch (source) {
      case 'Airbnb':
        return Colors.red.shade100;
      case 'Booking.com':
        return Colors.blue.shade100;
      case 'Direct':
        return Colors.green.shade100;
      default:
        return Colors.grey.shade100;
    }
  }

  Color _getSourceTextColor(String source) {
    switch (source) {
      case 'Airbnb':
        return Colors.red.shade800;
      case 'Booking.com':
        return Colors.blue.shade800;
      case 'Direct':
        return Colors.green.shade800;
      default:
        return Colors.grey.shade800;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'confirmed':
        return Colors.green.shade100;
      case 'pending':
        return Colors.yellow.shade100;
      case 'cancelled':
        return Colors.red.shade100;
      default:
        return Colors.grey.shade100;
    }
  }

  Color _getStatusTextColor(String status) {
    switch (status) {
      case 'confirmed':
        return Colors.green.shade800;
      case 'pending':
        return Colors.yellow.shade800;
      case 'cancelled':
        return Colors.red.shade800;
      default:
        return Colors.grey.shade800;
    }
  }

  Widget _summaryCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
  }) {
    return Card(
      elevation: 0,
      color: Colors.white.withOpacity(0.8),
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.black54)),
            const SizedBox(height: 8),
            Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: iconColor)),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(icon, size: 12, color: Colors.black38),
                const SizedBox(width: 4),
                Text(subtitle, style: const TextStyle(fontSize: 11, color: Colors.black45)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryGradientCard({
    required String title,
    required String value,
    required String subtitle,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2563EB), Color(0xFF0EA5E9)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.white70)),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.location_on, size: 12, color: Colors.white70),
              const SizedBox(width: 4),
              Text(subtitle, style: const TextStyle(fontSize: 11, color: Colors.white70)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBookingCard(Booking booking) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: Colors.grey.shade50.withOpacity(0.5),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        booking.guestName,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        'Room ${booking.room}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getSourceColor(booking.source),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        booking.source,
                        style: TextStyle(
                          fontSize: 10,
                          color: _getSourceTextColor(booking.source),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getStatusColor(booking.status),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        booking.status,
                        style: TextStyle(
                          fontSize: 10,
                          color: _getStatusTextColor(booking.status),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Check-in:',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    Text(
                      DateFormat('MMM dd, yyyy').format(booking.checkIn),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Check-out:',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    Text(
                      DateFormat('MMM dd, yyyy').format(booking.checkOut),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Nights:',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    Text(
                      '${booking.nights}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const Divider(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total:',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    Text(
                      '\$${booking.amount.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const NavigationWidget(),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFF8FAFC),
                    Color(0xFFDDEAFF),
                    Color(0xFFE0E7FF),
                  ],
                ),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2563EB),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.calendar_today,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Calendar & Bookings',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              'Manage your property reservations',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Summary Cards
                    LayoutBuilder(
                      builder: (context, constraints) {
                        return Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: [
                            SizedBox(
                              width: constraints.maxWidth >= 600 
                                ? (constraints.maxWidth - 12) / 2 // 2 columns with spacing
                                : constraints.maxWidth, // 1 column
                              child: _summaryCard(
                                title: 'Total Bookings',
                                value: '${bookings.length}',
                                subtitle: 'All time',
                                icon: Icons.calendar_today,
                                iconColor: const Color(0xFF2563EB),
                              ),
                            ),
                            SizedBox(
                              width: constraints.maxWidth >= 600 
                                ? (constraints.maxWidth - 12) / 2 // 2 columns with spacing
                                : constraints.maxWidth, // 1 column
                              child: _summaryCard(
                                title: 'Confirmed',
                                value: '$confirmedBookings',
                                subtitle: 'Ready to host',
                                icon: Icons.person,
                                iconColor: Colors.green.shade600,
                              ),
                            ),
                            SizedBox(
                              width: constraints.maxWidth >= 600 
                                ? (constraints.maxWidth - 12) / 2 // 2 columns with spacing
                                : constraints.maxWidth, // 1 column
                              child: _summaryCard(
                                title: 'Total Revenue',
                                value: '\$${totalRevenue.toStringAsFixed(0)}',
                                subtitle: 'Expected income',
                                icon: Icons.access_time,
                                iconColor: Colors.purple.shade600,
                              ),
                            ),
                            SizedBox(
                              width: constraints.maxWidth >= 600 
                                ? (constraints.maxWidth - 12) / 2 // 2 columns with spacing
                                : constraints.maxWidth, // 1 column
                              child: _summaryGradientCard(
                                title: 'Occupancy',
                                value: '78%',
                                subtitle: 'This month',
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 24),

                    // Calendar and Upcoming Bookings
                    LayoutBuilder(
                      builder: (context, constraints) {
                        if (constraints.maxWidth > 800) {
                          // Desktop layout - side by side
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 2,
                                child: _buildCalendarCard(),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                flex: 1,
                                child: _buildUpcomingBookingsCard(),
                              ),
                            ],
                          );
                        } else {
                          // Mobile layout - stacked
                          return Column(
                            children: [
                              _buildCalendarCard(),
                              const SizedBox(height: 16),
                              _buildUpcomingBookingsCard(),
                            ],
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarCard() {
    return Card(
      elevation: 0,
      color: Colors.white.withOpacity(0.8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.calendar_today,
                  size: 20,
                  color: Color(0xFF2563EB),
                ),
                const SizedBox(width: 8),
                Text(
                  DateFormat('MMMM yyyy').format(_focusedDay),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            const Text(
              'Track check-ins, check-outs, and availability',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            TableCalendar<Booking>(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              eventLoader: _getBookingsForDay,
              calendarFormat: CalendarFormat.month,
              startingDayOfWeek: StartingDayOfWeek.sunday,
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              onPageChanged: (focusedDay) {
                setState(() {
                  _focusedDay = focusedDay;
                });
              },
              calendarStyle: CalendarStyle(
                outsideDaysVisible: false,
                weekendTextStyle: const TextStyle(color: Colors.black87),
                holidayTextStyle: const TextStyle(color: Colors.black87),
                selectedDecoration: BoxDecoration(
                  color: const Color(0xFF2563EB),
                  shape: BoxShape.circle,
                ),
                todayDecoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.blue.shade200),
                ),
                markerDecoration: BoxDecoration(
                  color: Colors.green.shade400,
                  shape: BoxShape.circle,
                ),
                markersMaxCount: 1,
              ),
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                leftChevronIcon: Icon(
                  Icons.chevron_left,
                  color: Color(0xFF2563EB),
                ),
                rightChevronIcon: Icon(
                  Icons.chevron_right,
                  color: Color(0xFF2563EB),
                ),
              ),
              calendarBuilders: CalendarBuilders(
                markerBuilder: (context, day, events) {
                  final checkIn = _getCheckInForDay(day);
                  if (checkIn != null) {
                    return Positioned(
                      bottom: 2,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 1),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Check-in',
                          style: TextStyle(
                            fontSize: 8,
                            color: Colors.blue.shade800,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    );
                  } else if (_isBookedDay(day)) {
                    return Positioned(
                      bottom: 2,
                      child: Container(
                        width: 24,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.green.shade400,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    );
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildLegendItem(
                    Colors.green.shade400, 'Occupied', isCircle: false),
                const SizedBox(width: 16),
                _buildLegendItem(Colors.blue.shade100, 'Check-in'),
                const SizedBox(width: 16),
                _buildLegendItem(Colors.blue.shade50, 'Today'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label, {bool isCircle = true}) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
            borderRadius: isCircle ? null : BorderRadius.circular(2),
            border: label == 'Today'
                ? Border.all(color: Colors.blue.shade200)
                : null,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 10),
        ),
      ],
    );
  }

  Widget _buildUpcomingBookingsCard() {
    return Card(
      elevation: 0,
      color: Colors.white.withOpacity(0.8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Upcoming Bookings',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Text(
              'Next reservations and check-ins',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            if (upcomingBookings.isEmpty)
              Container(
                padding: const EdgeInsets.all(32),
                child: Column(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 48,
                      color: Colors.grey.shade300,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'No upcoming bookings',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              )
            else
              ...upcomingBookings.take(3).map((booking) => _buildBookingCard(booking)),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  // Handle sync functionality
                },
                child: const Text('Sync with Airbnb & Booking.com'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

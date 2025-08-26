import '/constants/app_exports.dart';
import 'package:intl/intl.dart';

// Utility function to check if two dates are the same day
bool isSameDay(DateTime a, DateTime b) {
  return a.year == b.year && a.month == b.month && a.day == b.day;
}

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
                    // Summary Cards using ResponsiveCardGrid
                    ResponsiveCardGrid(
                      children: [
                        SummaryCard(
                          title: 'Total Bookings',
                          value: '${bookings.length}',
                          subtitle: 'All time',
                          icon: Icons.calendar_today,
                          iconColor: const Color(0xFF2563EB),
                        ),
                        SummaryCard(
                          title: 'Confirmed',
                          value: '$confirmedBookings',
                          subtitle: 'Ready to host',
                          icon: Icons.person,
                          iconColor: Colors.green.shade600,
                        ),
                        SummaryCard(
                          title: 'Total Revenue',
                          value: '\$${totalRevenue.toStringAsFixed(0)}',
                          subtitle: 'Expected income',
                          icon: Icons.access_time,
                          iconColor: Colors.purple.shade600,
                        ),
                        SummaryGradientCard(
                          title: 'Occupancy',
                          value: '78%',
                          subtitle: 'This month',
                          gradientColors: const [Color(0xFF2563EB), Color(0xFF0EA5E9)],
                        ),
                      ],
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
    return ReusableCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 20,
                          color: Colors.grey.shade700,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          DateFormat('MMMM yyyy').format(_focusedDay),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade900,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: IconButton(
                            onPressed: () {
                              setState(() {
                                _focusedDay = DateTime(_focusedDay.year, _focusedDay.month - 1);
                              });
                            },
                            icon: Icon(
                              Icons.chevron_left,
                              size: 16,
                              color: Colors.grey.shade600,
                            ),
                            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                            padding: EdgeInsets.zero,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: IconButton(
                            onPressed: () {
                              setState(() {
                                _focusedDay = DateTime(_focusedDay.year, _focusedDay.month + 1);
                              });
                            },
                            icon: Icon(
                              Icons.chevron_right,
                              size: 16,
                              color: Colors.grey.shade600,
                            ),
                            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                            padding: EdgeInsets.zero,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Track check-ins, check-outs, and availability',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          
          // Card Content
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              children: [
                // Custom Calendar Grid
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade200),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      // Calendar Grid
                      _buildCustomCalendarGrid(),
                    ],
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Legend using CalendarLegend widget
                CalendarLegend(
                  items: [
                    CalendarLegendItem(
                      color: Colors.green.shade400,
                      label: 'Occupied',
                      isCircle: false,
                    ),
                    CalendarLegendItem(
                      color: Colors.blue.shade100,
                      label: 'Check-in',
                    ),
                    CalendarLegendItem(
                      color: Colors.blue.shade50,
                      label: 'Today',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomCalendarGrid() {
    final daysInMonth = DateTime(_focusedDay.year, _focusedDay.month + 1, 0).day;
    final firstDayOfMonth = DateTime(_focusedDay.year, _focusedDay.month, 1).weekday;
    final adjustedFirstDay = firstDayOfMonth == 7 ? 0 : firstDayOfMonth; // Sunday = 0
    
    final dayNames = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    final today = DateTime.now();
    
    List<Widget> calendarCells = [];
    
    // Day headers
    for (String dayName in dayNames) {
      calendarCells.add(
        Container(
          height: 40,
          alignment: Alignment.center,
          child: Text(
            dayName,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade500,
            ),
          ),
        ),
      );
    }
    
    // Empty cells before month starts
    for (int i = 0; i < adjustedFirstDay; i++) {
      calendarCells.add(Container(
        height: 80,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade100, width: 0.5),
        ),
      ));
    }
    
    // Days of the month
    for (int day = 1; day <= daysInMonth; day++) {
      final currentDate = DateTime(_focusedDay.year, _focusedDay.month, day);
      final isToday = isSameDay(currentDate, today);
      final bookingsForDay = _getBookingsForDay(currentDate);
      final checkInBooking = _getCheckInForDay(currentDate);
      final hasBookings = bookingsForDay.isNotEmpty;
      
      calendarCells.add(
        Container(
          height: 80,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade100, width: 0.5),
            color: isToday 
                ? Colors.blue.shade50 
                : hasBookings 
                    ? Colors.green.shade50 
                    : Colors.transparent,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$day',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isToday ? Colors.blue.shade600 : Colors.grey.shade900,
                  ),
                ),
                if (checkInBooking != null) ...[
                  const SizedBox(height: 4),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade100,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'Check-in: ${checkInBooking.guestName}',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.blue.shade800,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ] else if (hasBookings && checkInBooking == null) ...[
                  const Spacer(),
                  Container(
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: Colors.green.shade400,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      );
    }
    
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 7,
      childAspectRatio: 1.0,
      children: calendarCells,
    );
  }

  Widget _buildUpcomingBookingsCard() {
    return ReusableCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card Header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Upcoming Bookings',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Next reservations and check-ins',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          
          // Card Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
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
                        Text(
                          'No upcoming bookings',
                          style: TextStyle(color: Colors.grey.shade500),
                        ),
                      ],
                    ),
                  )
                else
                  Column(
                    children: upcomingBookings.take(3).map((booking) => BookingCard(
                      guestName: booking.guestName,
                      checkIn: booking.checkIn,
                      checkOut: booking.checkOut,
                      room: booking.room,
                      source: booking.source,
                      status: booking.status,
                      nights: booking.nights,
                      amount: booking.amount,
                    )).toList(),
                  ),
                
                const SizedBox(height: 16),
                
                // Sync button with border-t equivalent
                Container(
                  padding: const EdgeInsets.only(top: 16),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Colors.grey.shade200),
                    ),
                  ),
                  child: ActionButton(
                    text: 'Sync with Airbnb & Booking.com',
                    icon: Icons.sync,
                    onPressed: () {
                      // Handle sync functionality
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

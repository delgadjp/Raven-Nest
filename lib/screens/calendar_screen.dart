import '/constants/app_exports.dart';
import 'package:intl/intl.dart';

// Utility function to check if two dates are the same day
bool isSameDay(DateTime a, DateTime b) {
  return a.year == b.year && a.month == b.month && a.day == b.day;
}

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late DateTime _focusedDay;
  List<Map<String, dynamic>> bookings = [];
  Map<String, dynamic> summaryData = {};
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    _loadCalendarData();
  }

  Future<void> _loadCalendarData() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final results = await Future.wait([
        CalendarService.getAllBookings(),
        CalendarService.getCalendarSummary(),
      ]);

      setState(() {
        bookings = results[0] as List<Map<String, dynamic>>;
        summaryData = results[1] as Map<String, dynamic>;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Failed to load calendar data: $e';
      });
    }
  }

  List<Map<String, dynamic>> _getBookingsForDay(DateTime day) {
    return bookings.where((booking) {
      final checkIn = DateTime.parse(booking['check_in']);
      final checkOut = DateTime.parse(booking['check_out']);
      return day.isAfter(checkIn.subtract(const Duration(days: 1))) &&
          day.isBefore(checkOut);
    }).toList();
  }

  Map<String, dynamic>? _getCheckInForDay(DateTime day) {
    for (var booking in bookings) {
      final checkIn = DateTime.parse(booking['check_in']);
      if (isSameDay(checkIn, day)) {
        return booking;
      }
    }
    return null;
  }

  double get totalRevenue => summaryData['totalRevenue']?.toDouble() ?? 0.0;
  int get totalBookings => summaryData['totalBookings'] ?? 0;
  int get confirmedBookings => summaryData['confirmedBookings'] ?? 0;
  int get occupancyRate => summaryData['occupancyRate'] ?? 0;

  Future<void> _syncWithPlatforms() async {
    try {
      final success = await CalendarService.syncWithPlatforms();
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Successfully synced with platforms'),
            backgroundColor: Colors.green,
          ),
        );
        _loadCalendarData(); // Reload data after sync
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Sync failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: Column(
        children: [
          const NavigationWidget(),
          if (isLoading)
            const Expanded(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          else if (errorMessage != null)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red.shade400,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error loading calendar data',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.red.shade700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      errorMessage!,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _loadCalendarData,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            )
          else
            Expanded(
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
                          value: '$totalBookings',
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
                          icon: Icons.attach_money,
                          iconColor: Colors.purple.shade600,
                        ),
                        SummaryGradientCard(
                          title: 'Occupancy',
                          value: '$occupancyRate%',
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
                        'Check-in: ${checkInBooking['source']?['name'] ?? 'Guest'}',
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
          // Card Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Sync button
                ActionButton(
                  text: 'Sync with Airbnb & Booking.com',
                  icon: Icons.sync,
                  onPressed: _syncWithPlatforms,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

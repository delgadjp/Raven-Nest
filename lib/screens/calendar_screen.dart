import '/constants/app_exports.dart';
import 'package:intl/intl.dart';
import 'package:ravens_nest/services/pricing_service.dart';

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
  final NumberFormat _pesoFormat = NumberFormat.currency(
    locale: 'en_PH',
    symbol: '₱',
    decimalDigits: 0,
  );

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

  Color _parseSourceColor(String? hexColor) {
    if (hexColor == null || hexColor.isEmpty) {
      return const Color(0xFF6B7280);
    }

    var sanitized = hexColor.trim();
    if (sanitized.startsWith('#')) {
      sanitized = sanitized.substring(1);
    }

    if (sanitized.length == 6) {
      sanitized = 'FF$sanitized';
    }

    try {
      final value = int.parse(sanitized, radix: 16);
      return Color(value);
    } catch (_) {
      return const Color(0xFF6B7280);
    }
  }

  Color _getBookingSourceColor(Map<String, dynamic> booking) {
    final source = booking['source'] as Map<String, dynamic>?;
    return _parseSourceColor(source?['color'] as String?);
  }

  String _getBookingSourceName(Map<String, dynamic> booking) {
    final source = booking['source'] as Map<String, dynamic>?;
    final name = source?['name']?.toString().trim();
    if (name == null || name.isEmpty) {
      return 'Unknown';
    }
    return name;
  }

  String _getSourceDisplayLabel(Map<String, dynamic> booking) {
    final name = _getBookingSourceName(booking);
    final parts = name.split(' ').where((part) => part.isNotEmpty).toList();
    if (parts.isEmpty) {
      return name;
    }
    return parts.first.length > 8 ? parts.first.substring(0, 8) : parts.first;
  }

  Map<String, Color> _aggregateSources(List<Map<String, dynamic>> sourceBookings) {
    final Map<String, Color> result = {};
    for (final booking in sourceBookings) {
      final name = _getBookingSourceName(booking);
      result.putIfAbsent(name, () => _getBookingSourceColor(booking));
    }
    return result;
  }

  Map<String, Color> get _calendarSourceLegend {
    return _aggregateSources(bookings);
  }

  Widget _buildSourceDots(Map<String, Color> sources) {
    if (sources.isEmpty) {
      return const SizedBox.shrink();
    }

    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: sources.entries
          .map(
            (entry) => Tooltip(
              message: entry.key,
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: entry.value,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withOpacity(0.8),
                    width: 0.5,
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildStayIndicator(Map<String, Color> sources) {
    if (sources.isEmpty) {
      return const SizedBox.shrink();
    }

    final colors = sources.values.toList();

    return Container(
      height: 3,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(1),
        color: colors.length == 1 ? colors.first.withOpacity(0.6) : null,
        gradient: colors.length > 1
            ? LinearGradient(
                colors: colors
                    .map((color) => color.withOpacity(0.65))
                    .toList(),
              )
            : null,
      ),
    );
  }

  Widget _buildCompactSourceIndicator(List<Map<String, dynamic>> bookingsForDay) {
    final sources = _aggregateSources(bookingsForDay);
    if (sources.isEmpty) {
      return const SizedBox.shrink();
    }

    final colors = sources.values.toList();
    return Container(
      height: 3,
      width: double.infinity,
      margin: const EdgeInsets.only(top: 1),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(1),
        color: colors.length == 1 ? colors.first : null,
        gradient: colors.length > 1
            ? LinearGradient(
                colors: colors,
              )
            : null,
      ),
    );
  }

  Widget _buildCheckIndicator(
    Map<String, dynamic> booking, {
    required bool isCheckIn,
  }) {
    final sourceColor = _getBookingSourceColor(booking);
    final chipBackground = sourceColor.withOpacity(0.12);
    final borderColor = sourceColor.withOpacity(0.45);
    final textColor = sourceColor.withOpacity(0.9);
    final label = isCheckIn ? 'IN' : 'OUT';
    final displayName = _getSourceDisplayLabel(booking);

    return Tooltip(
      message: '${isCheckIn ? 'Check-in' : 'Check-out'} • ${_getBookingSourceName(booking)}',
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 2),
        padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 2),
        decoration: BoxDecoration(
          color: chipBackground,
          borderRadius: BorderRadius.circular(3),
          border: Border.all(color: borderColor, width: 0.5),
        ),
        child: Text(
          '$label $displayName',
          style: TextStyle(
            fontSize: 8,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
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

  Future<void> _recalculatePrices() async {
    try {
      final updated = await CalendarService.backfillMissingPrices();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Recalculated prices for $updated booking(s).'),
          backgroundColor: Colors.green,
        ),
      );
      await _loadCalendarData();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to recalculate prices: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showImportDialog() {
    showCalendarImportDialog(
      context,
      onImportComplete: () {
        _loadCalendarData(); // Reload calendar data after import
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Calendar import completed'),
              backgroundColor: Colors.green,
            ),
          );
        }
      },
    );
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
                          value: _pesoFormat.format(totalRevenue),
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
                        if (constraints.maxWidth > 900) {
                          // Desktop layout - side by side
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 3,
                                child: _buildCalendarCard(),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                flex: 2,
                                child: _buildUpcomingBookingsCard(),
                              ),
                            ],
                          );
                        } else {
                          // Mobile/Tablet layout - stacked
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
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2563EB).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.calendar_today,
                            size: 20,
                            color: const Color(0xFF2563EB),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              DateFormat('MMMM yyyy').format(_focusedDay),
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Colors.grey.shade900,
                              ),
                            ),
                            Text(
                              'Booking Calendar Overview',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        _buildNavigationButton(
                          icon: Icons.chevron_left,
                          onPressed: () {
                            setState(() {
                              _focusedDay = DateTime(_focusedDay.year, _focusedDay.month - 1);
                            });
                          },
                        ),
                        const SizedBox(width: 8),
                        _buildNavigationButton(
                          icon: Icons.today,
                          onPressed: () {
                            setState(() {
                              _focusedDay = DateTime.now();
                            });
                          },
                        ),
                        const SizedBox(width: 8),
                        _buildNavigationButton(
                          icon: Icons.chevron_right,
                          onPressed: () {
                            setState(() {
                              _focusedDay = DateTime(_focusedDay.year, _focusedDay.month + 1);
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Card Content
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              children: [
                // Enhanced Calendar Grid
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade100),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.02),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Column(
                      children: [
                        _buildCalendarHeader(),
                        _buildEnhancedCalendarGrid(),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Enhanced Legend
                _buildEnhancedLegend(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onPressed,
          child: Container(
            padding: const EdgeInsets.all(8),
            child: Icon(
              icon,
              size: 16,
              color: Colors.grey.shade700,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCalendarHeader() {
    const dayNames = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade100),
        ),
      ),
      child: Row(
        children: dayNames.map((dayName) => Expanded(
          child: Container(
            height: 48,
            alignment: Alignment.center,
            child: Text(
              dayName,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade600,
                letterSpacing: 0.5,
              ),
            ),
          ),
        )).toList(),
      ),
    );
  }

  Widget _buildEnhancedCalendarGrid() {
    final daysInMonth = DateTime(_focusedDay.year, _focusedDay.month + 1, 0).day;
    final firstDayOfMonth = DateTime(_focusedDay.year, _focusedDay.month, 1).weekday;
    final adjustedFirstDay = firstDayOfMonth == 7 ? 0 : firstDayOfMonth; // Sunday = 0
    
    final today = DateTime.now();
    final startOfToday = DateTime(today.year, today.month, today.day);
    
    List<Widget> calendarCells = [];
    
    // Empty cells before month starts
    for (int i = 0; i < adjustedFirstDay; i++) {
      calendarCells.add(_buildEmptyCalendarCell());
    }
    
    // Days of the month
    for (int day = 1; day <= daysInMonth; day++) {
      final currentDate = DateTime(_focusedDay.year, _focusedDay.month, day);
      calendarCells.add(_buildCalendarDayCell(currentDate, startOfToday));
    }
    
    // Calculate remaining empty cells to complete the grid
    final totalCells = calendarCells.length;
    final remainingCells = (7 - (totalCells % 7)) % 7;
    for (int i = 0; i < remainingCells; i++) {
      calendarCells.add(_buildEmptyCalendarCell());
    }
    
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate appropriate aspect ratio based on available space
        final cellWidth = constraints.maxWidth / 7;
        final aspectRatio = cellWidth > 60 ? 0.9 : 0.75;
        
        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 7,
          childAspectRatio: aspectRatio,
          mainAxisSpacing: 0.5,
          crossAxisSpacing: 0.5,
          children: calendarCells,
        );
      },
    );
  }

  Widget _buildEmptyCalendarCell() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        border: Border.all(color: Colors.grey.shade100, width: 0.5),
      ),
    );
  }

  Widget _buildCalendarDayCell(DateTime date, DateTime today) {
    final bookingsForDay = _getBookingsForDay(date);
    final checkInBookings = bookings.where((booking) {
      final checkIn = DateTime.parse(booking['check_in']);
      return isSameDay(checkIn, date);
    }).toList();
    
    final checkOutBookings = bookings.where((booking) {
      final checkOut = DateTime.parse(booking['check_out']);
      return isSameDay(checkOut, date);
    }).toList();

    final isToday = isSameDay(date, today);
    final isPast = date.isBefore(today);
    final hasBookings = bookingsForDay.isNotEmpty;
    final hasCheckIn = checkInBookings.isNotEmpty;
    final hasCheckOut = checkOutBookings.isNotEmpty;

    // Determine cell state and colors
    Color backgroundColor = Colors.white;
    Color borderColor = Colors.grey.shade100;
    Color textColor = Colors.grey.shade900;
    
    if (isPast && !hasBookings) {
      backgroundColor = Colors.grey.shade50;
      textColor = Colors.grey.shade400;
    } else if (isToday) {
      backgroundColor = const Color(0xFF2563EB).withOpacity(0.1);
      borderColor = const Color(0xFF2563EB).withOpacity(0.3);
      textColor = const Color(0xFF2563EB);
    } else if (hasBookings) {
      backgroundColor = Colors.green.shade50;
      borderColor = Colors.green.shade200;
    }

    final sourceMap = _aggregateSources(bookingsForDay);

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: borderColor, width: 0.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(3),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isSmallCell = constraints.maxWidth < 50 || constraints.maxHeight < 60;
            
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Date number with indicators
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: isSmallCell ? 18 : 22,
                      height: isSmallCell ? 18 : 22,
                      decoration: BoxDecoration(
                        color: isToday 
                            ? const Color(0xFF2563EB) 
                            : Colors.transparent,
                        shape: BoxShape.circle,
                        border: isToday 
                            ? null 
                            : isPast && !hasBookings 
                                ? Border.all(color: Colors.grey.shade300, width: 0.5)
                                : null,
                      ),
                      child: Center(
                        child: Text(
                          '${date.day}',
                          style: TextStyle(
                            fontSize: isSmallCell ? 10 : 11,
                            fontWeight: FontWeight.w600,
                            color: isToday 
                                ? Colors.white 
                                : isPast && !hasBookings 
                                    ? Colors.grey.shade400
                                    : textColor,
                          ),
                        ),
                      ),
                    ),
                    // Status indicators - only show if there's space
                    if (!isSmallCell && (hasCheckIn || hasCheckOut)) 
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (hasCheckIn)
                            Container(
                              width: 5,
                              height: 5,
                              decoration: BoxDecoration(
                                color: Colors.blue.shade600,
                                shape: BoxShape.circle,
                              ),
                            ),
                          if (hasCheckIn && hasCheckOut) const SizedBox(width: 1),
                          if (hasCheckOut)
                            Container(
                              width: 5,
                              height: 5,
                              decoration: BoxDecoration(
                                color: Colors.orange.shade600,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                  ],
                ),
                
                // Flexible content area
                if (constraints.maxHeight > 40) ...[
                  const SizedBox(height: 2),
                  Expanded(
                    child: _buildCellContent(
                      hasCheckIn: hasCheckIn,
                      hasCheckOut: hasCheckOut,
                      hasBookings: hasBookings,
                      checkInBookings: checkInBookings,
                      checkOutBookings: checkOutBookings,
                      isSmallCell: isSmallCell,
                      bookingsForDay: bookingsForDay,
                      sourceMap: sourceMap,
                    ),
                  ),
                ] else ...[
                  // For very small cells, just show a simple indicator
                  if (hasBookings)
                    _buildCompactSourceIndicator(bookingsForDay),
                ],
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildCellContent({
    required bool hasCheckIn,
    required bool hasCheckOut,
    required bool hasBookings,
    required List<Map<String, dynamic>> checkInBookings,
    required List<Map<String, dynamic>> checkOutBookings,
    required bool isSmallCell,
    required List<Map<String, dynamic>> bookingsForDay,
    required Map<String, Color> sourceMap,
  }) {
    if (isSmallCell) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (hasBookings) _buildCompactSourceIndicator(bookingsForDay),
        ],
      );
    }

    final children = <Widget>[];

    if (checkInBookings.isNotEmpty) {
      children.addAll(
        checkInBookings
            .map((booking) => _buildCheckIndicator(booking, isCheckIn: true))
            .toList(),
      );
    }

    if (checkOutBookings.isNotEmpty) {
      children.addAll(
        checkOutBookings
            .map((booking) => _buildCheckIndicator(booking, isCheckIn: false))
            .toList(),
      );
    }

    if (hasBookings) {
      if (children.isNotEmpty) {
        children.add(const SizedBox(height: 2));
      }
      children.add(_buildStayIndicator(sourceMap));
      children.add(const SizedBox(height: 2));
      children.add(_buildSourceDots(sourceMap));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: children,
    );
  }

  String _getGuestDisplayName(Map<String, dynamic> booking) {
    final source = booking['source'];
    if (source != null && source['name'] != null) {
      return source['name'].toString().split(' ').first;
    }
    return 'Guest';
  }

  double _getDisplayAmount(Map<String, dynamic> booking) {
    final dynamic raw = booking['total_amount'];
    double current = 0;
    if (raw is num) current = raw.toDouble();
    if (current > 0) return current;

    // Fallback compute using PricingService if DB amount is missing/zero
    try {
      final sourceName = _getBookingSourceName(booking);
      final checkIn = DateTime.parse(booking['check_in']);
      final checkOut = DateTime.parse(booking['check_out']);
      final computed = PricingService.computeTotalAmount(
        sourceName: sourceName,
        checkIn: checkIn,
        checkOut: checkOut,
      );
      return (computed ?? 0).toDouble();
    } catch (_) {
      return 0;
    }
  }

  Widget _buildEnhancedLegend() {
    final sourceLegend = _calendarSourceLegend;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Calendar Legend',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: [
              _buildLegendItem(
                color: const Color(0xFF2563EB),
                label: 'Today',
                isCircle: true,
              ),
              _buildLegendItem(
                color: Colors.blue.shade600,
                label: 'Check-in',
                isCircle: true,
                size: 6,
              ),
              _buildLegendItem(
                color: Colors.orange.shade600,
                label: 'Check-out',
                isCircle: true,
                size: 6,
              ),
              _buildLegendItem(
                color: Colors.green.shade400,
                label: 'Occupied',
                isCircle: false,
                height: 4,
              ),
              _buildLegendItem(
                color: Colors.grey.shade300,
                label: 'Past/Unavailable',
                isCircle: false,
              ),
            ],
          ),
          if (sourceLegend.isNotEmpty) ...[
            const SizedBox(height: 12),
            Divider(color: Colors.grey.shade200, height: 1),
            const SizedBox(height: 12),
            Text(
              'Booking Sources',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 16,
              runSpacing: 8,
              children: sourceLegend.entries
                  .map(
                    (entry) => _buildLegendItem(
                      color: entry.value,
                      label: entry.key,
                      isCircle: true,
                    ),
                  )
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLegendItem({
    required Color color,
    required String label,
    bool isCircle = false,
    double? size,
    double? height,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size ?? 12,
          height: height ?? size ?? 12,
          decoration: BoxDecoration(
            color: color,
            shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
            borderRadius: isCircle ? null : BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey.shade700,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildUpcomingBookingsCard() {
    final upcomingBookings = _getUpcomingBookings();
    final todayBookings = _getTodayBookings();
    
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
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.event_available,
                        size: 20,
                        color: Colors.green.shade600,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Upcoming Events',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Colors.grey.shade900,
                            ),
                          ),
                          Text(
                            'Check-ins, check-outs & sync options',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Today's Activities
          if (todayBookings.isNotEmpty) ...[
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF2563EB).withOpacity(0.05),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: const Color(0xFF2563EB).withOpacity(0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.today,
                        size: 16,
                        color: const Color(0xFF2563EB),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Today\'s Activity',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF2563EB),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ...todayBookings.map((booking) => _buildTodayBookingItem(booking)),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
          
          // Upcoming Bookings List
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Next 7 Days',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 12),
                if (upcomingBookings.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.calendar_today_outlined,
                            size: 32,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'No upcoming bookings',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  ...upcomingBookings.take(3).map((booking) => _buildUpcomingBookingItem(booking)),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Sync Section
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Calendar Sync',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: ActionButton(
                        text: 'Import',
                        icon: Icons.cloud_download,
                        onPressed: _showImportDialog,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ActionButton(
                        text: 'Sync',
                        icon: Icons.sync,
                        onPressed: _syncWithPlatforms,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ActionButton(
                        text: 'Recalculate',
                        icon: Icons.calculate,
                        onPressed: _recalculatePrices,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getUpcomingBookings() {
    final now = DateTime.now();
    final nextWeek = now.add(const Duration(days: 7));
    
    return bookings.where((booking) {
      final checkIn = DateTime.parse(booking['check_in']);
      final checkOut = DateTime.parse(booking['check_out']);
      return (checkIn.isAfter(now) && checkIn.isBefore(nextWeek)) ||
             (checkOut.isAfter(now) && checkOut.isBefore(nextWeek));
    }).toList()
      ..sort((a, b) {
        final aDate = DateTime.parse(a['check_in']);
        final bDate = DateTime.parse(b['check_in']);
        return aDate.compareTo(bDate);
      });
  }

  List<Map<String, dynamic>> _getTodayBookings() {
    final today = DateTime.now();
    
    return bookings.where((booking) {
      final checkIn = DateTime.parse(booking['check_in']);
      final checkOut = DateTime.parse(booking['check_out']);
      return isSameDay(checkIn, today) || isSameDay(checkOut, today);
    }).toList();
  }

  Widget _buildTodayBookingItem(Map<String, dynamic> booking) {
    final checkIn = DateTime.parse(booking['check_in']);
    final checkOut = DateTime.parse(booking['check_out']);
    final today = DateTime.now();
    final sourceName = _getBookingSourceName(booking);
    final sourceColor = _getBookingSourceColor(booking);
    
    final isCheckIn = isSameDay(checkIn, today);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: isCheckIn ? Colors.blue.shade100 : Colors.orange.shade100,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              isCheckIn ? Icons.login : Icons.logout,
              size: 16,
              color: isCheckIn ? Colors.blue.shade600 : Colors.orange.shade600,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${isCheckIn ? "Check-in" : "Check-out"}: ${_getGuestDisplayName(booking)}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  DateFormat('h:mm a').format(isCheckIn ? checkIn : checkOut),
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Tooltip(
                      message: sourceName,
                      child: Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: sourceColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        sourceName,
                        style: TextStyle(
                          fontSize: 9,
                          color: Colors.grey.shade600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          StatusBadge(
            text: booking['status'] ?? 'pending',
            backgroundColor: BookingStatusHelper.getStatusColor(booking['status'] ?? 'pending'),
            textColor: BookingStatusHelper.getStatusTextColor(booking['status'] ?? 'pending'),
            fontSize: 9,
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingBookingItem(Map<String, dynamic> booking) {
    final checkIn = DateTime.parse(booking['check_in']);
    final checkOut = DateTime.parse(booking['check_out']);
    final duration = checkOut.difference(checkIn).inDays;
    final sourceName = _getBookingSourceName(booking);
    final sourceColor = _getBookingSourceColor(booking);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  _getGuestDisplayName(booking),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              StatusBadge(
                text: booking['status'] ?? 'pending',
                backgroundColor: BookingStatusHelper.getStatusColor(booking['status'] ?? 'pending'),
                textColor: BookingStatusHelper.getStatusTextColor(booking['status'] ?? 'pending'),
                fontSize: 10,
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(
                Icons.calendar_today,
                size: 12,
                color: Colors.grey.shade500,
              ),
              const SizedBox(width: 4),
              Text(
                '${DateFormat('MMM d').format(checkIn)} - ${DateFormat('MMM d').format(checkOut)} ($duration nights)',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade600,
                ),
              ),
              const Spacer(),
              Text(
                _pesoFormat.format(_getDisplayAmount(booking)),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.green.shade600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Tooltip(
                message: sourceName,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: sourceColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  sourceName,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

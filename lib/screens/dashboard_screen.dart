import '/constants/app_exports.dart';
import 'package:intl/intl.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final DashboardService _dashboardService = DashboardService();
  final NumberFormat _pesoFormat = NumberFormat.currency(locale: 'en_PH', symbol: '₱', decimalDigits: 0);
  
  // Time range filter
  TimeRange _selectedRange = TimeRange.month;
  DateTimeRange? _currentRange;
  
  // Data state
  Map<String, dynamic>? summaryData;
  List<Map<String, dynamic>> monthlyRevenueData = [];
  List<Map<String, dynamic>> bookingSourcesData = [];
  List<Map<String, dynamic>> recentActivityData = [];
  
  // Loading states
  bool isLoadingSummary = true;
  bool isLoadingCharts = true;
  bool isLoadingActivity = true;
  
  // Error states
  String? summaryError;
  String? chartsError;
  String? activityError;

  @override
  void initState() {
    super.initState();
    _currentRange = _computeRange(_selectedRange);
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    // Load all dashboard data concurrently
    await Future.wait([
      _loadSummaryData(),
      _loadChartsData(),
      _loadActivityData(),
    ]);
  }

  Future<void> _loadSummaryData() async {
    try {
      setState(() {
        isLoadingSummary = true;
        summaryError = null;
      });
      
      final data = await _dashboardService.getSummaryData(range: _effectiveRange());
      
      if (mounted) {
        setState(() {
          summaryData = data;
          isLoadingSummary = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          summaryError = e.toString();
          isLoadingSummary = false;
        });
      }
    }
  }

  Future<void> _loadChartsData() async {
    try {
      setState(() {
        isLoadingCharts = true;
        chartsError = null;
      });
      
      // Determine year for revenue chart (based on selected range start, fallback to current year)
      final range = _effectiveRange();
      final int year = (range?.start.year) ?? DateTime.now().year;

      final results = await Future.wait([
        _dashboardService.getMonthlyRevenueData(year: year),
        _dashboardService.getBookingSourcesData(range: range),
      ]);
      
      if (mounted) {
        setState(() {
          monthlyRevenueData = results[0];
          bookingSourcesData = results[1];
          isLoadingCharts = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          chartsError = e.toString();
          isLoadingCharts = false;
        });
      }
    }
  }

  Future<void> _loadActivityData() async {
    try {
      setState(() {
        isLoadingActivity = true;
        activityError = null;
      });
      
      final data = await _dashboardService.getRecentActivityData(limit: 3, range: _effectiveRange());
      
      if (mounted) {
        setState(() {
          recentActivityData = data;
          isLoadingActivity = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          activityError = e.toString();
          isLoadingActivity = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: Column(
        children: [
          const NavigationWidget(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildFilterBar(),
                      const SizedBox(height: 16),
                      // Summary Cards Section
                      _buildSummaryCards(),
                      const SizedBox(height: 32),

                      // Analytics Charts Section
                      _buildChartsSection(),
                      const SizedBox(height: 32),

                      // Recent Activity Section
                      _buildRecentActivitySection(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // UI: Time range filter bar
  Widget _buildFilterBar() {
    return Align(
      alignment: Alignment.centerRight,
      child: PopupMenuButton<TimeRange>(
        tooltip: 'Filter dashboard data',
        onSelected: (r) async {
          setState(() {
            _selectedRange = r;
            _currentRange = _computeRange(_selectedRange);
          });
          await _loadDashboardData();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.black12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.filter_list, size: 18),
              const SizedBox(width: 6),
              Text(
                'Filter: ${_rangeTitle(_selectedRange)}',
                style: TextStyle(
                  color: Colors.grey.shade800,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        itemBuilder: (context) {
          final theme = Theme.of(context);
          return [
            for (final r in TimeRange.values)
              PopupMenuItem<TimeRange>(
                value: r,
                child: Row(
                  children: [
                    if (_selectedRange == r)
                      Icon(Icons.check, size: 16, color: theme.colorScheme.primary),
                    if (_selectedRange == r) const SizedBox(width: 8),
                    Text(_rangeTitle(r)),
                  ],
                ),
              ),
          ];
        },
      ),
    );
  }

  Widget _buildSummaryCards() {
    if (isLoadingSummary) {
      return _buildLoadingSummaryCards();
    }

    if (summaryError != null) {
      return _buildErrorCard('Failed to load summary data: $summaryError');
    }

    if (summaryData == null) {
      return _buildErrorCard('No summary data available');
    }

    final data = summaryData!;
    
    return Column(
      children: [
        // First row of cards
        Row(
          children: [
            Expanded(
              child: SummaryCard(
                title: 'Monthly Expenses',
                value: '\$${(data['monthlyExpenses'] ?? 0.0).toStringAsFixed(0)}',
                subtitle: 'Costs • ${_rangeLabel(_selectedRange)}',
                icon: Icons.attach_money,
                iconColor: const Color(0xFF16A34A),
                onTap: () => context.go(AppRoutes.expenses),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: SummaryCard(
                title: 'Active Bookings',
                value: '${data['activeBookings'] ?? 0}',
                subtitle: _rangeLabel(_selectedRange),
                icon: Icons.calendar_today,
                iconColor: const Color(0xFF2563EB),
                onTap: () => context.go(AppRoutes.calendar),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        
        // Second row of cards
        Row(
          children: [
            Expanded(
              child: SummaryCard(
                title: 'Inventory Items',
                value: '${data['inventoryItems'] ?? 0}',
                subtitle: 'Supplies & washables',
                icon: Icons.inventory,
                iconColor: const Color(0xFF7C3AED),
                onTap: () => context.go(AppRoutes.inventory),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: SummaryCard(
                title: 'Pending Tasks',
                value: '${data['pendingTasks'] ?? 0}',
                subtitle: 'Housekeeping items',
                icon: Icons.check_circle,
                iconColor: const Color(0xFFEA580C),
                onTap: () => context.go(AppRoutes.housekeeping),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Third row of cards
        Row(
          children: [
            Expanded(
              child: SummaryCard(
                title: 'Total Revenue',
                value: _pesoFormat.format((data['totalRevenue'] ?? 0.0) as num),
                subtitle: _selectedRange == TimeRange.all ? 'All time' : _rangeLabel(_selectedRange),
                icon: Icons.attach_money,
                iconColor: const Color(0xFF10B981),
                onTap: () => context.go(AppRoutes.dashboard),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: SummaryCard(
                title: 'Unread Notifications',
                value: '${data['unreadNotifications'] ?? 0}',
                subtitle: 'Require attention',
                icon: Icons.notifications,
                iconColor: const Color(0xFFEF4444),
                onTap: () => context.go(AppRoutes.notifications),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLoadingSummaryCards() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildLoadingCard()),
            const SizedBox(width: 16),
            Expanded(child: _buildLoadingCard()),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _buildLoadingCard()),
            const SizedBox(width: 16),
            Expanded(child: _buildLoadingCard()),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _buildLoadingCard()),
            const SizedBox(width: 16),
            Expanded(child: _buildLoadingCard()),
          ],
        ),
      ],
    );
  }

  Widget _buildLoadingCard() {
    return Card(
      elevation: 0,
      color: Colors.white.withValues(alpha: 0.8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        height: 120,
        padding: const EdgeInsets.all(16),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  Widget _buildChartsSection() {
    if (isLoadingCharts) {
      return _buildLoadingChartsSection();
    }

    if (chartsError != null) {
      return _buildErrorCard('Failed to load charts: $chartsError');
    }

    // Filter monthly revenue data based on selected range (client-side; data is monthly granularity)
    final filteredRevenueData = _filterMonthlyRevenueForRange(monthlyRevenueData);

    return ResponsiveChartsLayout(
      charts: [
        ChartContainer(
          title: 'Monthly Revenue',
          subtitle: _selectedRange == TimeRange.year
              ? 'Revenue and booking trends • ${_effectiveRange()?.start.year ?? DateTime.now().year}'
              : 'Revenue filtered • ${_rangeLabel(_selectedRange)}',
          headerActions: [
            Tooltip(
              message: 'Refresh',
              child: IconButton(
                icon: const Icon(Icons.refresh, size: 20),
                color: Colors.grey.shade700,
                splashRadius: 18,
                onPressed: () async {
                  await _loadChartsData();
                },
              ),
            ),
          ],
          chart: filteredRevenueData.isEmpty 
            ? _buildEmptyChart('No revenue data available')
            : RevenueLineChart(data: filteredRevenueData),
        ),
        ChartContainer(
          title: 'Booking Sources',
          subtitle: 'Distribution by platform • ${_rangeLabel(_selectedRange)}',
          chart: bookingSourcesData.isEmpty
            ? _buildEmptyChart('No booking sources data available')
            : BookingSourcesPieChart(data: bookingSourcesData),
        ),
      ],
    );
  }

  Widget _buildLoadingChartsSection() {
    return ResponsiveChartsLayout(
      charts: [
        ChartContainer(
          title: 'Monthly Revenue',
          subtitle: 'Loading...',
          headerActions: [
            Tooltip(
              message: 'Refresh',
              child: IconButton(
                icon: const Icon(Icons.refresh, size: 20),
                color: Colors.grey.shade700,
                splashRadius: 18,
                onPressed: () async {
                  await _loadChartsData();
                },
              ),
            ),
          ],
          chart: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
        ChartContainer(
          title: 'Booking Sources',
          subtitle: 'Loading...',
          chart: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyChart(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.bar_chart,
            size: 48,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivitySection() {
    if (isLoadingActivity) {
      return _buildLoadingActivityCard();
    }

    if (activityError != null) {
      return _buildErrorCard('Failed to load recent activity: $activityError');
    }

    if (recentActivityData.isEmpty) {
      return _buildEmptyActivityCard();
    }

    // Convert data to ActivityData objects
    final activities = recentActivityData.map((item) {
      final style = _dashboardService.getActivityStyle(item['type'] ?? '');
      return ActivityData(
        dotColor: style['dotColor'],
        backgroundColor: style['backgroundColor'],
        borderColor: style['borderColor'],
        title: item['title'] ?? 'Unknown Activity',
        subtitle: item['message'] ?? '',
        timeAgo: item['created_at'] != null 
          ? _dashboardService.formatTimeAgo(DateTime.parse(item['created_at']))
          : 'Unknown time',
      );
    }).toList();

    return RecentActivityCard(
      activities: activities,
      viewAllRoute: AppRoutes.notifications,
    );
  }

  Widget _buildLoadingActivityCard() {
    return Card(
      elevation: 0,
      color: Colors.white.withValues(alpha: 0.8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        height: 200,
        padding: const EdgeInsets.all(16),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  Widget _buildEmptyActivityCard() {
    return RecentActivityCard(
      activities: const [],
      viewAllRoute: AppRoutes.notifications,
    );
  }

  Widget _buildErrorCard(String message) {
    return Card(
      elevation: 0,
      color: Colors.red.shade50,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(
              Icons.error_outline,
              color: Colors.red.shade600,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              'Error',
              style: TextStyle(
                color: Colors.red.shade800,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: TextStyle(
                color: Colors.red.shade600,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadDashboardData,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade600,
                foregroundColor: Colors.white,
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  // Helpers
  DateTimeRange? _effectiveRange() {
    if (_selectedRange == TimeRange.all) return null;
    return _currentRange;
  }

  DateTimeRange _computeRange(TimeRange range) {
    final now = DateTime.now();
    switch (range) {
      case TimeRange.today:
        final start = DateTime(now.year, now.month, now.day);
        return DateTimeRange(start: start, end: start.add(const Duration(days: 1)));
      case TimeRange.week:
        // Start on Monday of this week
        final int weekday = now.weekday; // Mon=1..Sun=7
        final start = DateTime(now.year, now.month, now.day).subtract(Duration(days: weekday - 1));
        return DateTimeRange(start: start, end: start.add(const Duration(days: 7)));
      case TimeRange.month:
        final start = DateTime(now.year, now.month, 1);
        final end = DateTime(now.year, now.month + 1, 1);
        return DateTimeRange(start: start, end: end);
      case TimeRange.year:
        final start = DateTime(now.year, 1, 1);
        final end = DateTime(now.year + 1, 1, 1);
        return DateTimeRange(start: start, end: end);
      case TimeRange.all:
        // Not used; represented by null in _effectiveRange
        final start = DateTime(1970, 1, 1);
        final end = DateTime(now.year + 10, 1, 1);
        return DateTimeRange(start: start, end: end);
    }
  }

  String _rangeTitle(TimeRange r) {
    switch (r) {
      case TimeRange.today:
        return 'Today';
      case TimeRange.week:
        return 'Week';
      case TimeRange.month:
        return 'Month';
      case TimeRange.year:
        return 'Year';
      case TimeRange.all:
        return 'All';
    }
  }

  String _rangeLabel(TimeRange r) {
    switch (r) {
      case TimeRange.today:
        return 'Today';
      case TimeRange.week:
        return 'This week';
      case TimeRange.month:
        return 'This month';
      case TimeRange.year:
        return 'This year';
      case TimeRange.all:
        return 'All time';
    }
  }

  List<Map<String, dynamic>> _filterMonthlyRevenueForRange(List<Map<String, dynamic>> data) {
    if (data.isEmpty) return data;
    final range = _effectiveRange();
    if (range == null) return data; // all time -> current year shown

    // Keep months that intersect range's months
    final startMonth = range.start.month;
    final endMonth = range.end.subtract(const Duration(days: 1)).month;
    final startIdx = startMonth;
    final endIdx = endMonth;

    return data.where((m) {
      final monthName = m['month']?.toString() ?? '';
      final monthIndex = _monthIndex(monthName);
      if (monthIndex == null) return false;
      if (startIdx <= endIdx) {
        return monthIndex >= startIdx && monthIndex <= endIdx;
      } else {
        // Range wraps year end (Dec..Jan) -> include if month >= start or month <= end
        return monthIndex >= startIdx || monthIndex <= endIdx;
      }
    }).toList();
  }

  int? _monthIndex(String name) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final idx = months.indexOf(name);
    return idx == -1 ? null : idx + 1;
  }
}

enum TimeRange { today, week, month, year, all }

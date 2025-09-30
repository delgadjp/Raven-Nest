import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../constants/app_routes.dart';

class NavigationWidget extends StatelessWidget {
  const NavigationWidget({super.key});

  // Function to get page info based on current route
  Map<String, dynamic> _getPageInfo(String currentLocation) {
    switch (currentLocation) {
      case AppRoutes.dashboard:
        return {
          'title': 'Condo Manager',
          'icon': Icons.home,
          'color': const Color(0xFF2563EB),
        };
      case AppRoutes.expenses:
        return {
          'title': 'Expenses',
          'icon': Icons.attach_money,
          'color': const Color(0xFF16A34A),
        };
      case AppRoutes.inventory:
        return {
          'title': 'Inventory',
          'icon': Icons.inventory_2,
          'color': const Color(0xFF7C3AED),
        };
      case AppRoutes.calendar:
        return {
          'title': 'Calendar & Bookings',
          'icon': Icons.calendar_today,
          'color': const Color(0xFF2563EB),
        };
      case AppRoutes.housekeeping:
        return {
          'title': 'Housekeeping',
          'icon': Icons.people_alt_rounded,
          'color': Colors.teal.shade600,
        };
      case AppRoutes.notifications:
        return {
          'title': 'Notifications',
          'icon': Icons.notifications,
          'color': Colors.red.shade600,
        };
      case AppRoutes.settings:
        return {
          'title': 'Settings',
          'icon': Icons.settings,
          'color': Colors.grey.shade600,
        };
      default:
        return {
          'title': 'Condo Manager',
          'icon': Icons.home,
          'color': const Color(0xFF2563EB),
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentLocation = GoRouterState.of(context).uri.toString();
    final pageInfo = _getPageInfo(currentLocation);
    
    final width = MediaQuery.of(context).size.width;
    final bool isDesktop = width > 1024; // closer to React lg breakpoint

    return Container(
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      child: SafeArea(
        child: Container(
          height: 64,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: const BoxDecoration(
            color: Colors.transparent,
          ),
          child: Row(
            children: [
              // Logo and Title
              GestureDetector(
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: pageInfo['color'],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        pageInfo['icon'],
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      pageInfo['title'],
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              // Navigation Items (Desktop)
              if (isDesktop)
                Flexible(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildNavItem('Dashboard', AppRoutes.dashboard, Icons.home, currentLocation, context),
                        _buildNavItem('Expenses', AppRoutes.expenses, Icons.attach_money, currentLocation, context),
                        _buildNavItem('Inventory', AppRoutes.inventory, Icons.inventory, currentLocation, context),
                        _buildNavItem('Calendar', AppRoutes.calendar, Icons.calendar_today, currentLocation, context),
                        _buildNavItem('Housekeeping', AppRoutes.housekeeping, Icons.cleaning_services, currentLocation, context),
                        _buildNavItem('Notifications', AppRoutes.notifications, Icons.notifications, currentLocation, context),
                        // _buildNavItem('Guest Logs', '/guest-logs', Icons.description, currentLocation, context),
                        _buildNavItem('Settings', AppRoutes.settings, Icons.settings, currentLocation, context),
                      ],
                    ),
                  ),
                )
              else
                IconButton(
                  icon: const Icon(Icons.menu, color: Colors.black87),
                  onPressed: () => _showSideMenu(context, currentLocation),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(String title, String path, IconData icon, String currentLocation, BuildContext context) {
    final isActive = currentLocation == path;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: TextButton.icon(
        onPressed: () => context.go(path),
        icon: Icon(
          icon,
          size: 18,
          color: isActive ? Colors.white : Colors.white.withValues(alpha: 0.7),
        ),
        label: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            color: isActive ? Colors.white : Colors.white.withValues(alpha: 0.7),
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        style: TextButton.styleFrom(
          backgroundColor: isActive ? Colors.white.withValues(alpha: 0.2) : Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
        ),
      ),
    );
  }

  void _showSideMenu(BuildContext context, String currentLocation) {
    final width = MediaQuery.of(context).size.width;
    final double panelWidth = width * 0.8 > 360 ? 360 : width * 0.8;

    showGeneralDialog(
      context: context,
      barrierLabel: 'Menu',
      barrierDismissible: true,
      barrierColor: Colors.black.withValues(alpha: 0.4),
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (context, _, __) {
        return Align(
          alignment: Alignment.centerRight,
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: panelWidth,
              height: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 20,
                    offset: const Offset(-4, 0),
                  )
                ],
              ),
              child: SafeArea(
                child: _SideMenuContent(currentLocation: currentLocation),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        final offset = Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
            .animate(CurvedAnimation(parent: anim1, curve: Curves.easeOut));
        return SlideTransition(position: offset, child: child);
      },
    );
  }

}

class _SideMenuContent extends StatelessWidget {
  final String currentLocation;
  const _SideMenuContent({required this.currentLocation});

  @override
  Widget build(BuildContext context) {
    final items = [
      ('Dashboard', AppRoutes.dashboard, Icons.home),
      ('Expenses', AppRoutes.expenses, Icons.attach_money),
      ('Inventory', AppRoutes.inventory, Icons.inventory),
      ('Calendar', AppRoutes.calendar, Icons.calendar_today),
      ('Housekeeping', AppRoutes.housekeeping, Icons.cleaning_services),
      ('Notifications', AppRoutes.notifications, Icons.notifications),
      // ('Guest Logs', '/guest-logs', Icons.description),
      ('Settings', AppRoutes.settings, Icons.settings),
    ];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Menu',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).maybePop(),
              )
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.separated(
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final (title, path, icon) = items[index];
                final bool isActive = currentLocation == path;
                return OutlinedButton.icon(
                  onPressed: () {
                    Navigator.of(context).maybePop();
                    context.go(path);
                  },
                  icon: Icon(
                    icon,
                    size: 18,
                    color: isActive ? const Color(0xFF2563EB) : Colors.black87,
                  ),
                  label: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      title,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: isActive ? const Color(0xFF2563EB) : Colors.black87,
                        fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                      ),
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    side: BorderSide(color: const Color.fromARGB(255, 175, 175, 175).withValues(alpha: 0.3)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    backgroundColor:
                        isActive ? const Color(0xFF2563EB).withValues(alpha: 0.08) : null,
                    alignment: Alignment.centerLeft,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

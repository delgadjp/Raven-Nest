import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavigationWidget extends StatelessWidget {
  const NavigationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final currentLocation = GoRouterState.of(context).uri.toString();
    
    final width = MediaQuery.of(context).size.width;
    final bool isDesktop = width > 1024; // closer to React lg breakpoint

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        border: Border(
          bottom: BorderSide(color: Colors.grey.withValues(alpha: 0.3), width: 0.5),
        ),
      ),
      child: SafeArea(
        child: Container(
          height: 64,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              // Logo and Title
              GestureDetector(
                onTap: () => context.go('/'),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF2563EB), Color(0xFF7C3AED)],
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.home,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Condo Manager',
                      style: TextStyle(
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
                        _buildNavItem('Dashboard', '/', Icons.home, currentLocation, context),
                        _buildNavItem('Expenses', '/expenses', Icons.attach_money, currentLocation, context),
                        _buildNavItem('Inventory', '/inventory', Icons.inventory, currentLocation, context),
                        _buildNavItem('Calendar', '/calendar', Icons.calendar_today, currentLocation, context),
                        _buildNavItem('Analytics', '/analytics', Icons.bar_chart, currentLocation, context),
                        _buildNavItem('Housekeeping', '/housekeeping', Icons.cleaning_services, currentLocation, context),
                        _buildNavItem('Notifications', '/notifications', Icons.notifications, currentLocation, context),
                        // _buildNavItem('Guest Logs', '/guest-logs', Icons.description, currentLocation, context),
                        _buildNavItem('Settings', '/settings', Icons.settings, currentLocation, context),
                      ],
                    ),
                  ),
                )
              else
                IconButton(
                  icon: const Icon(Icons.menu),
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
          color: isActive ? const Color(0xFF2563EB) : Colors.grey[600],
        ),
        label: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            color: isActive ? const Color(0xFF2563EB) : Colors.grey[600],
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        style: TextButton.styleFrom(
          backgroundColor: isActive ? const Color(0xFF2563EB).withValues(alpha: 0.1) : Colors.transparent,
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
      ('Dashboard', '/', Icons.home),
      ('Expenses', '/expenses', Icons.attach_money),
      ('Inventory', '/inventory', Icons.inventory),
      ('Calendar', '/calendar', Icons.calendar_today),
      ('Analytics', '/analytics', Icons.bar_chart),
      ('Housekeeping', '/housekeeping', Icons.cleaning_services),
      ('Notifications', '/notifications', Icons.notifications),
      // ('Guest Logs', '/guest-logs', Icons.description),
      ('Settings', '/settings', Icons.settings),
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
                    side: BorderSide(color: Colors.grey.withValues(alpha: 0.3)),
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

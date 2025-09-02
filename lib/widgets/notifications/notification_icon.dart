import '../../constants/app_exports.dart';

class NotificationIcon extends StatelessWidget {
  final IconData icon;
  final String type;

  const NotificationIcon({
    super.key,
    required this.icon,
    required this.type,
  });

  Color _getTypeBackgroundColor(String type) {
    switch (type) {
      case 'booking':
        return Colors.blue.shade50;
      case 'checkin':
        return Colors.green.shade50;
      case 'checkout':
        return Colors.orange.shade50;
      case 'maintenance':
        return Colors.purple.shade50;
      case 'inventory':
        return Colors.red.shade50;
      case 'payment':
        return Colors.green.shade50;
      case 'review':
        return Colors.indigo.shade50;
      default:
        return Colors.grey.shade50;
    }
  }

  Color _getTypeIconColor(String type) {
    switch (type) {
      case 'booking':
        return Colors.blue.shade600;
      case 'checkin':
        return Colors.green.shade600;
      case 'checkout':
        return Colors.orange.shade600;
      case 'maintenance':
        return Colors.purple.shade600;
      case 'inventory':
        return Colors.red.shade600;
      case 'payment':
        return Colors.green.shade600;
      case 'review':
        return Colors.indigo.shade600;
      default:
        return Colors.grey.shade600;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: _getTypeBackgroundColor(type),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Icon(
        icon,
        color: _getTypeIconColor(type),
        size: 20,
      ),
    );
  }
}

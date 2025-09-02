import '../../constants/app_exports.dart';
import 'package:intl/intl.dart';

class BookingCard extends StatelessWidget {
  final String guestName;
  final DateTime checkIn;
  final DateTime checkOut;
  final String room;
  final String source;
  final String status;
  final int nights;
  final double amount;
  final EdgeInsets? margin;
  final VoidCallback? onTap;

  const BookingCard({
    super.key,
    required this.guestName,
    required this.checkIn,
    required this.checkOut,
    required this.room,
    required this.source,
    required this.status,
    required this.nights,
    required this.amount,
    this.margin,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ReusableCard(
      margin: margin ?? const EdgeInsets.only(bottom: 16),
      backgroundColor: Colors.grey.shade50.withValues(alpha: 0.5),
      border: Border.all(color: Colors.grey.shade200),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Guest info and badges
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          guestName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Room $room',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      StatusBadge(
                        text: source,
                        backgroundColor: BookingStatusHelper.getSourceColor(source),
                        textColor: BookingStatusHelper.getSourceTextColor(source),
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      ),
                      const SizedBox(height: 4),
                      StatusBadge(
                        text: status,
                        backgroundColor: BookingStatusHelper.getStatusColor(status),
                        textColor: BookingStatusHelper.getStatusTextColor(status),
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      ),
                    ],
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Booking details
              Column(
                children: [
                  BookingDetailRow(
                    label: 'Check-in:',
                    value: DateFormat('M/d/yyyy').format(checkIn),
                  ),
                  const SizedBox(height: 8),
                  BookingDetailRow(
                    label: 'Check-out:',
                    value: DateFormat('M/d/yyyy').format(checkOut),
                  ),
                  const SizedBox(height: 8),
                  BookingDetailRow(
                    label: 'Nights:',
                    value: '$nights',
                  ),
                  
                  // Divider line
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    height: 1,
                    color: Colors.grey.shade200,
                  ),
                  
                  BookingDetailRow(
                    label: 'Total:',
                    value: '\$${amount.toStringAsFixed(0)}',
                    isTotal: true,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

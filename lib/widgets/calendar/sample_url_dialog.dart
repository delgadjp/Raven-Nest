import 'package:flutter/material.dart';

void showSampleUrlDialog(BuildContext context, String platform) {
  String sampleUrl;
  String instructions;
  
  switch (platform.toLowerCase()) {
    case 'airbnb':
      sampleUrl = 'https://www.airbnb.com/calendar/ical/[LISTING_ID].ics?s=[SECRET_KEY]';
      instructions = 'Replace [LISTING_ID] with your property ID and [SECRET_KEY] with your secret key from Airbnb.';
      break;
    case 'booking.com':
      sampleUrl = 'https://admin.booking.com/hotel/[PROPERTY_ID]/calendar/ical/[SECRET_KEY].ics';
      instructions = 'Replace [PROPERTY_ID] with your property ID and [SECRET_KEY] with your secret key from Booking.com.';
      break;
    default:
      sampleUrl = 'https://example.com/calendar.ics';
      instructions = 'Most calendar systems provide an iCal export URL ending with .ics';
  }

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: Row(
        children: [
          Icon(Icons.info_outline, color: Colors.blue.shade600),
          const SizedBox(width: 8),
          Text('Sample $platform URL'),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            instructions, 
            style: const TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sample URL:',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 4),
                SelectableText(
                  sampleUrl,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
      ],
    ),
  );
}
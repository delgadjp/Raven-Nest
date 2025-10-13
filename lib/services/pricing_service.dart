class PricingService {
  /// Computes total amount for a booking based on source and stay length.
  ///
  /// Rules provided:
  /// - Airbnb: base 2500/night, 10% off for >=7 nights, 15% off for >=28 nights
  /// - Booking.com: base 4500/night, 15% off for >=7 nights (weekly) and >=28 nights (monthly)
  /// - Others: returns null (caller may decide how to handle)
  static double? computeTotalAmount({
    required String sourceName,
    required DateTime checkIn,
    required DateTime checkOut,
  }) {
    final nights = _computeNights(checkIn, checkOut);
    if (nights <= 0) return 0; // no charge if invalid/zero-night

    final normalized = sourceName.trim().toLowerCase();

    if (normalized == 'airbnb') {
      const baseNightly = 2500.0;
      final discount = nights >= 28
          ? 0.15
          : nights >= 7
              ? 0.10
              : 0.0;
      final nightly = baseNightly * (1 - discount);
      return nightly * nights;
    }

    if (normalized == 'booking.com' || normalized == 'booking com' || normalized == 'booking') {
      const baseNightly = 4500.0;
      final discount = nights >= 7 ? 0.15 : 0.0; // weekly and monthly both 15%
      final nightly = baseNightly * (1 - discount);
      return nightly * nights;
    }

    // Unknown source; do not compute here
    return null;
  }

  static int _computeNights(DateTime checkIn, DateTime checkOut) {
    // Nights is the difference in whole days between the dates (checkout exclusive).
    final ci = DateTime(checkIn.year, checkIn.month, checkIn.day);
    final co = DateTime(checkOut.year, checkOut.month, checkOut.day);
    return co.difference(ci).inDays;
  }
}

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'dart:io' as io;
import 'package:pdf/widgets.dart' as pw;

/// Represents time ranges the user can export.
enum ExportRange { today, week, month, year, all }

/// Output format for exports
enum ExportFormat { csv, pdf }

/// A simple result object for export operations.
class ExportResult {
  final bool success;
  final String message;
  final String? fileName;

  const ExportResult({
    required this.success,
    required this.message,
    this.fileName,
  });
}

/// Service responsible for exporting application data.
///
/// NOTE: This is a placeholder implementation. Replace the simulated delay
/// with real data collection and file generation logic (CSV/JSON) and handle
/// saving/downloading per platform (mobile/web/desktop).
class DataExportService {
  /// Kicks off an export for the given [range]. Returns an [ExportResult]
  /// describing the outcome. Currently simulated with a small delay.
  static Future<ExportResult> exportAllData(
    ExportRange range, {
    ExportFormat format = ExportFormat.csv,
  }) async {
    // 1) Fetch data for the given range (placeholder sample rows)
    final rows = await _collectSampleData(range);

    // 2) Generate bytes
    final bytes = format == ExportFormat.csv
        ? _generateCsvBytes(rows)
        : await _generatePdfBytes(rows, title: 'Raven Export - ${_labelForRange(range)}');

    // 3) Pick filename
    final now = DateTime.now();
    final label = _labelForRange(range);
    final fileSafeLabel = label.toLowerCase().replaceAll(' ', '_');
    final ext = format == ExportFormat.csv ? 'csv' : 'pdf';
    final fileName = 'raven_export_${_yyyyMmDd(now)}_${fileSafeLabel}.$ext';

    // 4) Save depending on platform
    final savedPathOrName = await _saveBytes(bytes, fileName, mimeType: format == ExportFormat.csv ? 'text/csv' : 'application/pdf');

    return ExportResult(
      success: true,
      message: 'Export complete for $label as ${format.name.toUpperCase()}',
      fileName: savedPathOrName,
    );
  }

  static Future<List<Map<String, dynamic>>> _collectSampleData(ExportRange range) async {
    // TODO: Replace with real queries based on the date range.
    await Future.delayed(const Duration(milliseconds: 200));
    return [
      {
        'Date': _yyyyMmDd(DateTime.now()),
        'Type': 'Booking',
        'Details': 'Sample reservation 1234',
        'Amount': 3500.75,
      },
      {
        'Date': _yyyyMmDd(DateTime.now().subtract(const Duration(days: 1))),
        'Type': 'Expense',
        'Details': 'Cleaning supplies',
        'Amount': 420.10,
      },
    ];
  }

  static Uint8List _generateCsvBytes(List<Map<String, dynamic>> rows) {
    if (rows.isEmpty) return Uint8List.fromList(utf8.encode(''));
    final headers = rows.first.keys.toList();
    final buffer = StringBuffer();
    buffer.writeln(headers.join(','));
    for (final row in rows) {
      final values = headers.map((h) => _escapeCsv(row[h])).join(',');
      buffer.writeln(values);
    }
    return Uint8List.fromList(utf8.encode(buffer.toString()));
  }

  static String _escapeCsv(dynamic value) {
    if (value == null) return '';
    var s = value.toString();
    final needsQuotes = s.contains(',') || s.contains('"') || s.contains('\n');
    s = s.replaceAll('"', '""');
    return needsQuotes ? '"$s"' : s;
  }

  static Future<Uint8List> _generatePdfBytes(List<Map<String, dynamic>> rows, {required String title}) async {
    final doc = pw.Document();
    final headers = rows.isNotEmpty ? rows.first.keys.toList() : <String>[];
    final data = rows
        .map((r) => headers.map((h) => (r[h] ?? '').toString()).toList())
        .toList();

    doc.addPage(
      pw.MultiPage(
        build: (context) => [
          pw.Text(title, style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 12),
          if (headers.isEmpty)
            pw.Text('No data')
          else
            pw.Table.fromTextArray(headers: headers, data: data),
        ],
      ),
    );

    return await doc.save();
  }

  static Future<String> _saveBytes(Uint8List bytes, String fileName, {required String mimeType}) async {
    if (kIsWeb) {
      // On web, trigger download via AnchorElement + Blob (defer implementation to avoid web dependency here).
      // Use a quick workaround by returning the filename; UI can inform user the browser handled download.
      // If you want to implement, add: import 'dart:html' as html; then create a Blob and click a link.
      return fileName;
    }

    // On IO platforms, save to Downloads or Documents
    final dir = await _preferredSaveDirectory();
    final path = p.join(dir.path, fileName);
    final file = io.File(path);
    await file.writeAsBytes(bytes, flush: true);
    return path;
  }

  static Future<io.Directory> _preferredSaveDirectory() async {
    // Try downloads; fallback to documents
    try {
      final downloads = await getDownloadsDirectory();
      if (downloads != null) return downloads;
    } catch (_) {}
    return await getApplicationDocumentsDirectory();
  }

  static String _labelForRange(ExportRange range) {
    switch (range) {
      case ExportRange.today:
        return 'Today';
      case ExportRange.week:
        return 'This Week';
      case ExportRange.month:
        return 'This Month';
      case ExportRange.year:
        return 'This Year';
      case ExportRange.all:
        return 'All Data';
    }
  }

  static String _yyyyMmDd(DateTime dt) {
    final mm = dt.month.toString().padLeft(2, '0');
    final dd = dt.day.toString().padLeft(2, '0');
    return '${dt.year}-$mm-$dd';
  }
}

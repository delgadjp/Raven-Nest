import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
export 'dart:typed_data';
import '/core/app_export.dart';
import 'dart:typed_data';  // Add this for web support
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math'; // Import math library for distance calculations

class TipService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final Uuid _uuid = Uuid();
  
  // Google Vision API key
  final String _visionApiKey = 'AIzaSyBpeXXTgrLeT9PuUT-8H-AXPTW6sWlnys0';

  // Generate a formal document ID format: REPORT-YYYYMMDD-XXXX (where XXXX is sequential starting at 0001)
  Future<String> generateFormalReportId() async {
    final today = DateTime.now();
    final dateStr = "${today.year.toString().padLeft(4, '0')}${today.month.toString().padLeft(2, '0')}${today.day.toString().padLeft(2, '0')}";
    final idPrefix = 'REPORTS_$dateStr-';
    try {
      final QuerySnapshot querySnapshot = await _firestore
          .collection('reports')
          .get();
      int highestNumber = 0;
      for (final doc in querySnapshot.docs) {
        final String docId = doc.id;
        if (docId.startsWith(idPrefix) && docId.length > idPrefix.length) {
          final String seqPart = docId.substring(idPrefix.length);
          final int? seqNum = int.tryParse(seqPart);
          if (seqNum != null && seqNum > highestNumber) {
            highestNumber = seqNum;
          }
        }
      }
      final int nextNumber = highestNumber + 1;
      final String paddedNumber = nextNumber.toString().padLeft(3, '0');
      final String newDocId = '$idPrefix$paddedNumber';
      return newDocId;
    } catch (e) {
      print('Error generating report document ID: $e');
      final String paddedNumber = '001';
      final String fallbackId = '$idPrefix$paddedNumber';
      return fallbackId;
    }
  }

  // Helper method to upload image to Firebase Storage
  Future<String?> _uploadImage(dynamic imageData, String reportId) async {
    try {
      // Create reference to the file path in storage
      final Reference storageRef = _storage
          .ref()
          .child('reports-app')
          .child('$reportId.jpg');
      
      late UploadTask uploadTask;
      
      // Handle different types of image data (File for mobile, Uint8List for web)
      if (kIsWeb) {
        // For web, imageData should be Uint8List (from base64 decode)
        if (imageData is String) {
          // If it's base64 string, decode it
          final Uint8List bytes = Uri.parse(imageData).data!.contentAsBytes();
          uploadTask = storageRef.putData(bytes);
        } else if (imageData is Uint8List) {
          // If it's already bytes
          uploadTask = storageRef.putData(imageData);
        } else {
          throw Exception('Unsupported image data type for web');
        }
      } else {
        // For mobile platforms, imageData should be a File
        if (imageData is File) {
          uploadTask = storageRef.putFile(imageData);
        } else if (imageData is String && imageData.isNotEmpty) {
          // Assume it's a file path
          final File file = File(imageData);
          if (await file.exists()) {
            uploadTask = storageRef.putFile(file);
          } else {
            throw Exception('File does not exist at path: $imageData');
          }
        } else {
          throw Exception('Unsupported image data type for mobile');
        }
      }
      
      // Wait for the upload to complete and get download URL
      await uploadTask.whenComplete(() => null);
      final String downloadUrl = await storageRef.getDownloadURL();
      
      print('Image uploaded successfully. URL: $downloadUrl');
      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      // Return null if upload fails, but don't fail the entire submission
      return null;
    }
  }

  // New method to validate image using Google Vision API
  Future<Map<String, dynamic>> validateImageWithGoogleVision(dynamic imageData) async {
    try {
      // Default response
      Map<String, dynamic> result = {
        'isValid': false,
        'containsHuman': false,
        'confidence': 0.0,
        'message': 'Image validation failed'
      };
      
      // Convert image data to base64 format needed for Vision API
      String base64Image;
      
      if (kIsWeb) {
        if (imageData is Uint8List) {
          base64Image = base64Encode(imageData);
        } else if (imageData is String) {
          // If it's already a base64 string from web
          if (imageData.startsWith('data:image')) {
            base64Image = imageData.split(',')[1];
          } else {
            // Try to decode the string as bytes
            final Uint8List bytes = Uri.parse(imageData).data!.contentAsBytes();
            base64Image = base64Encode(bytes);
          }
        } else {
          throw Exception('Unsupported image data type for web validation');
        }
      } else {
        // For mobile platforms
        if (imageData is File) {
          final bytes = await imageData.readAsBytes();
          base64Image = base64Encode(bytes);
        } else if (imageData is String && imageData.isNotEmpty) {
          // Assume it's a file path
          final File file = File(imageData);
          if (await file.exists()) {
            final bytes = await file.readAsBytes();
            base64Image = base64Encode(bytes);
          } else {
            throw Exception('File does not exist at path: $imageData');
          }
        } else if (imageData is Uint8List) {
          base64Image = base64Encode(imageData);
        } else {
          throw Exception('Unsupported image data type for mobile validation');
        }
      }
      
      // Prepare request to Google Vision API
      final response = await http.post(
        Uri.parse('https://vision.googleapis.com/v1/images:annotate?key=$_visionApiKey'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'requests': [
            {
              'image': {
                'content': base64Image
              },
              'features': [
                {'type': 'LABEL_DETECTION', 'maxResults': 10},
                {'type': 'FACE_DETECTION', 'maxResults': 5},
                {'type': 'OBJECT_LOCALIZATION', 'maxResults': 10}
              ]
            }
          ]
        })
      );
      
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        print('Vision API response: ${jsonResponse.toString()}');
        
        bool containsHuman = false;
        double confidence = 0.0;
        
        // Check for human-related labels
        final annotations = jsonResponse['responses'][0];
        
        // Check face detection results
        if (annotations.containsKey('faceAnnotations') && 
            annotations['faceAnnotations'] != null &&
            annotations['faceAnnotations'].isNotEmpty) {
          containsHuman = true;
          confidence = annotations['faceAnnotations'][0]['detectionConfidence'] * 100;
        }
        
        // Check label detection results if no face found
        if (!containsHuman && annotations.containsKey('labelAnnotations')) {
          final List<dynamic> labels = annotations['labelAnnotations'];
          for (var label in labels) {
            String description = label['description'].toString().toLowerCase();
            if (description.contains('person') || 
                description.contains('human') || 
                description.contains('people') ||
                description.contains('face') ||
                description.contains('man') ||
                description.contains('woman') ||
                description.contains('child')) {
              containsHuman = true;
              confidence = label['score'] * 100;  // Convert to percentage
              break;
            }
          }
        }
        
        // Check object localization results if still no human found
        if (!containsHuman && annotations.containsKey('localizedObjectAnnotations')) {
          final List<dynamic> objects = annotations['localizedObjectAnnotations'];
          for (var object in objects) {
            String name = object['name'].toString().toLowerCase();
            if (name.contains('person') || 
                name.contains('human') ||
                name.contains('face') ||
                name.contains('man') ||
                name.contains('woman') ||
                name.contains('child')) {
              containsHuman = true;
              confidence = object['score'] * 100;  // Convert to percentage
              break;
            }
          }
        }
        
        result = {
          'isValid': true,
          'containsHuman': containsHuman,
          'confidence': confidence.round() / 100,  // Round to 2 decimal places
          'message': containsHuman 
              ? 'Image validated successfully. Human detected with ${confidence.toStringAsFixed(1)}% confidence.' 
              : 'No human detected in the image.'
        };
      } else {
        print('Error calling Google Vision API: ${response.statusCode}, ${response.body}');
        result['message'] = 'Error calling image validation service: ${response.statusCode}';
      }
      
      return result;
    } catch (e) {
      print('Exception in validateImageWithGoogleVision: $e');
      return {
        'isValid': false,
        'containsHuman': false,
        'confidence': 0.0,
        'message': 'Error validating image: $e'
      };
    }
  }

  Future<void> submitTip({
    required String dateLastSeen,
    required String timeLastSeen,
    required String gender,
    String ageRange = "Unknown", 
    String heightRange = "Unknown", 
    required String hairColor,
    required String clothing,
    required String features,
    required String description,
    required double lat,
    required double lng,
    required String userId,
    required String address,
    dynamic imageData, 
    bool validateImage = true, 
    required String caseId, // Add caseId to fetch missing person name
    required String missingPersonName, // Add missingPersonName as a required parameter
  }) async {
    try {
      // Validate image if provided and validation is enabled
      Map<String, dynamic> imageValidation = {'isValid': true, 'containsHuman': true};
      bool shouldUploadImage = imageData != null;
      
      if (imageData != null && validateImage) {
        imageValidation = await validateImageWithGoogleVision(imageData);
        
        // If validation failed completely, continue without the image
        if (!imageValidation['isValid']) {
          print('Image validation failed: [${imageValidation['message']}');
          shouldUploadImage = false;
        }
        // If validation succeeded but no human detected, don't upload the image
        else if (!imageValidation['containsHuman']) {
          print('No human detected in the image. The image will be automatically removed.');
          shouldUploadImage = false;
        }
      }
    
      // Generate formal reportId
      final String reportId = await generateFormalReportId();
        // Fetch missing person name by caseId using the correct field name
      String name = missingPersonName;
      try {
        final doc = await FirebaseFirestore.instance.collection('missingPersons').where('alarm_id', isEqualTo: caseId).get();
        if (doc.docs.isNotEmpty) {
          name = doc.docs.first.data()['name'] ?? missingPersonName;
          print('Found missing person in database: $name (using alarm_id: $caseId)');
        } else {
          print('No missing person found with alarm_id: $caseId, using provided name: $missingPersonName');
        }
      } catch (e) {
        print('Error fetching missing person name: $e');
      }// Format coordinates as GeoPoint for Firestore
      final GeoPoint coordinates = GeoPoint(lat, lng);

      // Format dateTimeLastSeen and timestamp
      final DateTime now = DateTime.now();
      final Timestamp createdAtTimestamp = Timestamp.now();
      final Timestamp dateTimeLastSeenTimestamp = Timestamp.fromDate(DateTime.parse(dateLastSeen + 'T' + timeLastSeen));

      // Prepare the data map
      final Map<String, dynamic> reportData = {
        'age': ageRange,
        'clothing': clothing,
        'coordinates': coordinates,
        'createdAt': createdAtTimestamp,
        'dateTimeLastSeen': dateTimeLastSeenTimestamp,
        'description': description,
        'features': features,
        'gender': gender,
        'hairColor': hairColor,
        'height': heightRange,
        'imageUrl': null, // Will be set after upload
        'name': name,
        'timestamp': createdAtTimestamp,
        'uid': userId,
        'reportId': reportId,
      };
      
      // Add image validation results if image was provided and validated
      if (imageData != null && validateImage) {
        reportData['imageValidation'] = {
          'containsHuman': imageValidation['containsHuman'],
          'confidence': imageValidation['confidence'],
          'wasRemoved': !shouldUploadImage && imageData != null,
        };
      }
      
      // Upload image only if validation passed or was skipped
      if (shouldUploadImage) {
        final String? imageUrl = await _uploadImage(imageData, reportId);
        if (imageUrl != null) {
          // Add the image URL to the report data
          reportData['imageUrl'] = imageUrl;
        }
      }
      
      // Create the report document in Firestore with custom reportId
      await _firestore.collection('reports').doc(reportId).set(reportData)
        .catchError((e) {
          print("Firestore write error: \u001b[${e.toString()}");
          throw e;
        });

      print('Report successfully added with custom reportId: $reportId');
    } catch (e) {
      print('Error submitting report: $e');
      if (e is FirebaseException) {
        print('Firebase error code: ${e.code}');
        print('Firebase error message: ${e.message}');
      }
      throw e;
    }
  }

  // Helper to format DateTime as 'May 13, 2025 at 10:28:00 PM UTC+8'
  String _formatDateTime(DateTime dt) {
    final String month = _monthName(dt.month);
    final String day = dt.day.toString();
    final String year = dt.year.toString();
    final int hour12 = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final String time =
      "${hour12.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}:${dt.second.toString().padLeft(2, '0')} ${dt.hour >= 12 ? 'PM' : 'AM'}";
    final String timezone = 'UTC${_timezoneOffset(dt)}';
    return "$month $day, $year at $time $timezone";
  }
  String _monthName(int month) {
    const months = [
      '', 'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month];
  }
  String _timezoneOffset(DateTime dt) {
    final offset = dt.timeZoneOffset;
    final hours = offset.inHours;
    final minutes = offset.inMinutes.remainder(60);
    final sign = hours >= 0 ? '+' : '-';
    return '$sign${hours.abs()}${minutes != 0 ? ':${minutes.abs().toString().padLeft(2, '0')}' : ''}';
  }

  Future<List<Map<String, dynamic>>> getAllReports() async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection('reports')
          .orderBy('timestamp', descending: true)
          .get();
          

      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      print('Error getting reports: $e');
      throw e;
    }
  }

  // New method to find tips within a specified radius
  Future<List<Map<String, dynamic>>> findNearbyTips(double latitude, double longitude, double radiusInMeters) async {
    try {
      // Get all tips from the database
      final QuerySnapshot snapshot = await _firestore
          .collection('reports')
          .get();

      // Filter tips by distance
      List<Map<String, dynamic>> nearbyTips = [];
      
      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
          // Check if this tip has coordinates
        if (data.containsKey('coordinates') && data['coordinates'] != null) {
          double? tipLat;
          double? tipLng;
          
          // Handle GeoPoint format
          if (data['coordinates'] is GeoPoint) {
            final GeoPoint geoPoint = data['coordinates'] as GeoPoint;
            tipLat = geoPoint.latitude;
            tipLng = geoPoint.longitude;
          }
          // Handle legacy coordinate formats
          else if (data['coordinates'] is Map) {
            tipLat = data['coordinates']['lat']?.toDouble();
            tipLng = data['coordinates']['lng']?.toDouble();
          }
          // Handle string format: "[lat° N, lng° E]"
          else if (data['coordinates'] is String) {
            final regex = RegExp(r'([\d.\-]+)°\s*N,\s*([\d.\-]+)°\s*E');
            final match = regex.firstMatch(data['coordinates']);
            if (match != null) {
              tipLat = double.tryParse(match.group(1)!);
              tipLng = double.tryParse(match.group(2)!);
            }
          }
          
          if (tipLat != null && tipLng != null) {
            final double distance = _calculateDistance(
              latitude, longitude, tipLat, tipLng);
            
            // If within radius, add to result list
            if (distance <= radiusInMeters) {
              data['id'] = doc.id;
              data['distance'] = distance;
              nearbyTips.add(data);
            }
          }
        }
      }
      
      // Sort by distance (closest first)
      nearbyTips.sort((a, b) => (a['distance'] as double).compareTo(b['distance'] as double));
      
      return nearbyTips;
    } catch (e) {
      print('Error finding nearby tips: $e');
      return [];
    }
  }

  // Helper method to calculate distance between two points using the Haversine formula
  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371000; // Earth's radius in meters
    
    // Convert degrees to radians
    final double lat1Rad = _degreesToRadians(lat1);
    final double lon1Rad = _degreesToRadians(lon1);
    final double lat2Rad = _degreesToRadians(lat2);
    final double lon2Rad = _degreesToRadians(lon2);
    
    // Haversine formula
    final double dLat = lat2Rad - lat1Rad;
    final double dLon = lon2Rad - lon1Rad;
    final double a = 
        sin(dLat/2) * sin(dLat/2) +
        cos(lat1Rad) * cos(lat2Rad) * 
        sin(dLon/2) * sin(dLon/2);
    final double c = 2 * atan2(sqrt(a), sqrt(1-a));
    
    return earthRadius * c; // Distance in meters
  }
  
  // Helper to convert degrees to radians
  double _degreesToRadians(double degrees) {
    return degrees * (pi / 180);
  }
}
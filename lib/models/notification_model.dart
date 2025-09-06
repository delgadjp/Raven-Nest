import 'package:flutter/material.dart';

class NotificationModel {
  final String id;
  final String type;
  final String title;
  final String message;
  final DateTime timestamp;
  final bool read;
  final String priority;
  final String? relatedBooking;
  final String? relatedTask;
  final String? relatedItem;
  final IconData icon;

  NotificationModel({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.timestamp,
    required this.read,
    required this.priority,
    this.relatedBooking,
    this.relatedTask,
    this.relatedItem,
    required this.icon,
  });

  NotificationModel copyWith({
    bool? read,
  }) {
    return NotificationModel(
      id: id,
      type: type,
      title: title,
      message: message,
      timestamp: timestamp,
      read: read ?? this.read,
      priority: priority,
      relatedBooking: relatedBooking,
      relatedTask: relatedTask,
      relatedItem: relatedItem,
      icon: icon,
    );
  }
}

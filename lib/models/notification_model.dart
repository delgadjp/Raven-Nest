import 'package:flutter/material.dart';

class NotificationModel {
  final int id;
  final String type;
  final String title;
  final String message;
  final DateTime timestamp;
  final bool read;
  final String priority;
  final String source;
  final double? amount;
  final int? rating;
  final IconData icon;

  NotificationModel({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.timestamp,
    required this.read,
    required this.priority,
    required this.source,
    this.amount,
    this.rating,
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
      source: source,
      amount: amount,
      rating: rating,
      icon: icon,
    );
  }
}

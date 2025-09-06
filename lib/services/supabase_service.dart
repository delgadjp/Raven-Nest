import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();
  factory SupabaseService() => _instance;
  SupabaseService._internal();

  // Your Supabase configuration
  static const String supabaseUrl = 'https://fyrwauqoshqtgbmmodjk.supabase.co';
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ5cndhdXFvc2hxdGdibW1vZGprIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTYyODg1NjEsImV4cCI6MjA3MTg2NDU2MX0.FOGDbIYYYBk3EnHQSijaDja9Gc95cFUhP7i2w-pfgE8';

  static SupabaseClient get client => Supabase.instance.client;

  // Initialize Supabase with your credentials
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );
  }

  // Check if user is authenticated
  bool get isAuthenticated => client.auth.currentUser != null;

  // Get current user
  User? get currentUser => client.auth.currentUser;
}

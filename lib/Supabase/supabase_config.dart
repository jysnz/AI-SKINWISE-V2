import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart'; // Import para sa kDebugMode

// Global variable para ma-access ang Supabase client sa buong app
late final SupabaseClient supabase;

Future<void> initializeSupabase() async {
  // Ito ang iyong actual Supabase URL at Anon Key
  const String supabaseUrl = 'https://hgcjvasnyamurflgrpel.supabase.co';
  const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhnY2p2YXNueWFtdXJmbGdycGVsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjI4Nzk3MDcsImV4cCI6MjA3ODQ1NTcwN30.uepBWtJa2WQX330YpTEqS61Y3GjajA8TgYtMhbN6GgI';

  // --- TINANGGAL ANG MALING IF-STATEMENT DITO ---
  // Ang check na iyon ang sanhi ng iyong crash.

  try {
    // Subukang i-initialize ang Supabase
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );

    // Kung successful, i-assign ang instance sa global variable
    supabase = Supabase.instance.client;

    // Mag-print ng success message sa console (para lang sa debugging)
    if (kDebugMode) {
      print('Supabase initialized successfully!');
    }

  } catch (e) {
    // Ito ang TAMANG paraan para mahuli ang error.
    // Ipapakita nito ang totoong dahilan kung bakit pumalya
    // (e.g., "invalid_key", "no_network", "project_not_found")
    if (kDebugMode) {
      print('Error initializing Supabase: $e');
    }
    // I-throw ulit ang error para malaman ng app na may problema
    throw Exception('Failed to initialize Supabase: $e');
  }
}
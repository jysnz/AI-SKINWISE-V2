import 'package:ai_skinwise_v2/Supabase/supabase_config.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';

// --- 1. USER MODEL (Data Structure) ---
class UserData {
  final String id;
  final String? firstName;
  final String? lastName;
  final int? age;
  final String? height;

  UserData({
    required this.id,
    this.firstName,
    this.lastName,
    this.age,
    this.height,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'] as String,
      firstName: json['FirstName'] as String?,
      lastName: json['LastName'] as String?,
      age: json['Age'] as int?,
      height: json['Height'] as String?,
    );
  }
}

// --- 2. ANALYSIS RECORD MODEL ---
class AnalysisRecord {
  final String diseaseName;
  final String analysisDate; // You can change this to DateTime if you prefer
  final String? rarity;
  final double confidenceScore; // e.g., 0.95

  AnalysisRecord({
    required this.diseaseName,
    required this.analysisDate,
    this.rarity,
    required this.confidenceScore,
  });

  // Factory method to convert Supabase data (a Map) into an AnalysisRecord
  factory AnalysisRecord.fromJson(Map<String, dynamic> json) {
    // IMPORTANT: Use the EXACT column names from your Supabase table
    return AnalysisRecord(
      diseaseName: json['disease_name'] as String,
      analysisDate: json['created_at'] as String, // Or whatever your date column is
      rarity: json['rarity'] as String?,
      confidenceScore: (json['confidence_score'] as num).toDouble(),
    );
  }
}

// --- 3. COMBINED MODEL FOR THE DASHBOARD ---
class DashboardData {
  // From UserData
  final String? firstName;
  final String? lastName;

  // From Analysis History
  final List<AnalysisRecord> analysisHistory;

  DashboardData({
    this.firstName,
    this.lastName,
    required this.analysisHistory,
  });
}

// --- 4. DATA FETCHING FUNCTION (USER) ---
Future<UserData> fetchUserData() async {
  final userId = supabase.auth.currentUser?.id;
  if (userId == null) {
    throw Exception("Walang naka-log in na user (User ID is NULL)");
  }
  try {
    final response = await supabase
        .from('UserInformation')
        .select()
        .eq('id', userId)
        .single();
    return UserData.fromJson(response);
  } on PostgrestException catch (e) {
    if (kDebugMode) {
      print('Database Error (fetchUserData): ${e.message}');
    }
    throw Exception('Hindi makuha ang data: ${e.message}');
  } catch (e) {
    if (kDebugMode) {
      print('General Error (fetchUserData): $e');
    }
    throw Exception('May naganap na error sa pagkuha ng data.');
  }
}

// --- 5. NEW FUNCTION: FETCH ANALYSIS HISTORY ---
Future<List<AnalysisRecord>> fetchAnalysisHistory() async {
  final userId = supabase.auth.currentUser?.id;
  if (userId == null) {
    return []; // Return empty list if no user
  }

  try {
    //
    // !!! ----------------- IMPORTANT ----------------- !!!
    // !!!   You MUST change 'AnalysisHistory' and 'user_id'
    // !!!   to match your Supabase table and column names!
    // !!! ----------------- IMPORTANT ----------------- !!!
    //
    final response = await supabase
        .from('AnalysisHistory') // <-- CHANGE THIS
        .select()
        .eq('user_id', userId); // <-- AND/OR THIS

    // Convert list of maps to list of AnalysisRecord objects
    final records = response
        .map<AnalysisRecord>((json) => AnalysisRecord.fromJson(json))
        .toList();

    return records;
  } on PostgrestException catch (e) {
    if (kDebugMode) {
      print('Error fetching analysis history: ${e.message}');
    }
    throw Exception('Failed to load analysis history: ${e.message}');
  } catch (e) {
    if (kDebugMode) {
      print('General Error fetching history: $e');
    }
    throw Exception('An error occurred while loading history.');
  }
}

// --- 6. NEW FUNCTION: FETCH COMBINED DASHBOARD DATA ---
Future<DashboardData> fetchDashboardData() async {
  try {
    // Call both functions at the same time
    final results = await Future.wait([
      fetchUserData(),        // Result [0]
      fetchAnalysisHistory(), // Result [1]
    ]);

    // Get the data from the results list
    final userData = results[0] as UserData;
    final history = results[1] as List<AnalysisRecord>;

    // Combine them into the DashboardData object
    return DashboardData(
      firstName: userData.firstName,
      lastName: userData.lastName,
      analysisHistory: history,
    );
  } catch (e) {
    if (kDebugMode) {
      print('Error fetching combined dashboard data: $e');
    }
    // Re-throw the error so the FutureBuilder can catch it
    throw Exception('Failed to load dashboard: $e');
  }
}


// --- 7. DEBUGGING/PRINTING FUNCTION ---
Future<void> fetchUserDataAndPrintToConsole() async {
  try {
    final response = await supabase
        .from('UserInformation')
        .select('id, firstName, LastName, Age, Height')
        .single();
    if (kDebugMode) {
      print('====================================');
      print('USER INFORMATION SUCCESSFULLY FETCHED');
      print('Raw Data (Map): $response');
      print('====================================');
    }
  } on PostgrestException catch (e) {
    if (kDebugMode) {
      print('USER INFO FETCH ERROR (Database): ${e.message}');
    }
  } catch (e) {
    if (kDebugMode) {
      print('USER INFO FETCH ERROR (General): $e');
    }
  }
}

// --- 8. BAGONG FUNCTION: Para kumuha ng data NANG WALANG LOGIN ---
// (This function is unused by the dashboard, but we can keep it)
Future<void> fetchAndPrintAllUserData() async {
  // ... (your function code)
}
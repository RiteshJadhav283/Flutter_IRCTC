import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../models/booking_model.dart';
import 'mock_data.dart';

class LocalStorageService {
  static const String _keyActiveUser = 'railgo_active_user';
  static const String _keyRegisteredUsers = 'railgo_registered_users';
  static const String _keyBookings = 'railgo_bookings';
  static const String _keyDarkMode = 'railgo_dark_mode';

  // Get active session user
  static Future<AppUser?> getActiveUser() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_keyActiveUser);
    if (jsonStr != null && jsonStr.isNotEmpty) {
      try {
        final map = jsonDecode(jsonStr) as Map<String, dynamic>;
        return AppUser.fromJson(map);
      } catch (_) {}
    }
    return null;
  }

  // Set active session user
  static Future<void> setActiveUser(AppUser? user) async {
    final prefs = await SharedPreferences.getInstance();
    if (user != null) {
      await prefs.setString(_keyActiveUser, jsonEncode(user.toJson()));
    } else {
      await prefs.remove(_keyActiveUser);
    }
  }

  // Register new account locally on the phone
  static Future<AppUser> registerUser({
    required String email,
    required String password,
    required String name,
    String? phone,
    String? irctcId,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final registeredUsersStr = prefs.getString(_keyRegisteredUsers) ?? '{}';
    Map<String, dynamic> registeredUsers = {};
    try {
      registeredUsers = jsonDecode(registeredUsersStr) as Map<String, dynamic>;
    } catch (_) {}

    final cleanEmail = email.trim().toLowerCase();

    final newUser = AppUser(
      uid: 'local_usr_${DateTime.now().millisecondsSinceEpoch}',
      name: name.trim(),
      email: cleanEmail,
      phone: phone?.trim() ?? '+91 98765 43210',
      irctcUserId: irctcId?.trim() ?? 'IRCTC_${cleanEmail.split('@').first.toUpperCase()}',
      savedPassengers: const [],
    );

    registeredUsers[cleanEmail] = {
      'password': password.trim(),
      'profile': newUser.toJson(),
    };

    await prefs.setString(_keyRegisteredUsers, jsonEncode(registeredUsers));
    await setActiveUser(newUser);
    return newUser;
  }

  // Login with credentials saved on device
  static Future<AppUser?> loginUser({
    required String email,
    required String password,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final registeredUsersStr = prefs.getString(_keyRegisteredUsers) ?? '{}';
    Map<String, dynamic> registeredUsers = {};
    try {
      registeredUsers = jsonDecode(registeredUsersStr) as Map<String, dynamic>;
    } catch (_) {}

    final cleanEmail = email.trim().toLowerCase();

    // Check if user exists in local phone storage
    if (registeredUsers.containsKey(cleanEmail)) {
      final record = registeredUsers[cleanEmail] as Map<String, dynamic>;
      if (record['password'] == password.trim()) {
        final profileMap = record['profile'] as Map<String, dynamic>;
        final user = AppUser.fromJson(profileMap);
        await setActiveUser(user);
        return user;
      } else {
        throw Exception('Incorrect password. Please try again.');
      }
    }

    // If initial demo user is used
    if (cleanEmail == 'ritesh.jadhav@gmail.com' && password == 'irctc2026') {
      final defaultUser = MockData.defaultUser;
      await setActiveUser(defaultUser);
      return defaultUser;
    }

    throw Exception('No account found with this email. Please click "Create Account" first.');
  }

  // Log out
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyActiveUser);
  }

  // Get all bookings from phone storage
  static Future<List<Booking>> getBookings() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_keyBookings);
    if (jsonStr != null && jsonStr.isNotEmpty) {
      try {
        final list = jsonDecode(jsonStr) as List;
        return list.map((e) => Booking.fromJson(e as Map<String, dynamic>)).toList();
      } catch (_) {}
    }
    // Default initial mock bookings
    final defaults = MockData.defaultBookings;
    await saveAllBookings(defaults);
    return defaults;
  }

  // Save a new booking into phone storage
  static Future<void> addBooking(Booking booking) async {
    final current = await getBookings();
    final updated = [booking, ...current];
    await saveAllBookings(updated);
  }

  // Cancel booking in phone storage
  static Future<void> cancelBooking(String pnr) async {
    final current = await getBookings();
    final updated = current.map((b) {
      if (b.pnr == pnr) {
        return Booking(
          pnr: b.pnr,
          userId: b.userId,
          trainNumber: b.trainNumber,
          trainName: b.trainName,
          trainType: b.trainType,
          journeyDate: b.journeyDate,
          bookingDate: b.bookingDate,
          source: b.source,
          sourceName: b.sourceName,
          destination: b.destination,
          destinationName: b.destinationName,
          departureTime: b.departureTime,
          arrivalTime: b.arrivalTime,
          departurePlatform: b.departurePlatform,
          arrivalPlatform: b.arrivalPlatform,
          travelClass: b.travelClass,
          quota: b.quota,
          status: 'CANCELLED',
          isTatkal: b.isTatkal,
          passengers: b.passengers,
          fareDetails: b.fareDetails,
          paymentMethod: b.paymentMethod,
          transactionId: b.transactionId,
          isDownloaded: b.isDownloaded,
        );
      }
      return b;
    }).toList();
    await saveAllBookings(updated);
  }

  static Future<void> saveAllBookings(List<Booking> bookings) async {
    final prefs = await SharedPreferences.getInstance();
    final list = bookings.map((b) => b.toJson()).toList();
    await prefs.setString(_keyBookings, jsonEncode(list));
  }

  // Theme preference
  static Future<bool> isDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyDarkMode) ?? false;
  }

  static Future<void> setDarkMode(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyDarkMode, isDark);
  }
}

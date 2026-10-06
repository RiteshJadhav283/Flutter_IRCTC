import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/local_storage_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  AppUser? _user;
  bool _isAuthenticated = false;
  bool _isLoading = false;
  String? _errorMessage;

  AppUser? get user => _user;
  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  AuthProvider() {
    _initAuthState();
  }

  Future<void> _initAuthState() async {
    _isLoading = true;
    notifyListeners();

    _user = await _authService.currentUser;
    _isAuthenticated = _user != null;
    _isLoading = false;
    notifyListeners();
  }

  // Email & Password Sign In via phone local storage
  Future<bool> loginWithEmail(String email, String password) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final loggedInUser = await _authService.signInWithEmail(email, password);
      if (loggedInUser != null) {
        _user = loggedInUser;
        _isAuthenticated = true;
        _isLoading = false;
        notifyListeners();
        return true;
      }

      _isLoading = false;
      _errorMessage = 'Invalid email or password.';
      notifyListeners();
      return false;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString().replaceAll("Exception:", "").trim();
      notifyListeners();
      return false;
    }
  }

  // Register with Email, Password & Username (stored on device)
  Future<bool> registerWithEmail({
    required String email,
    required String password,
    required String name,
    String? phone,
    String? irctcId,
  }) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final newUser = await _authService.registerWithEmail(
        email: email,
        password: password,
        name: name,
        phone: phone,
        irctcUserId: irctcId,
      );

      _user = newUser;
      _isAuthenticated = true;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString().replaceAll("Exception:", "").trim();
      notifyListeners();
      return false;
    }
  }

  // Guest / Anonymous mode
  Future<bool> continueAsGuest() async {
    _isLoading = true;
    notifyListeners();

    _user = await _authService.signInAnonymously();
    _isAuthenticated = true;
    _isLoading = false;
    notifyListeners();
    return true;
  }

  // Sign out
  Future<void> signOut() async {
    _isLoading = true;
    notifyListeners();

    await _authService.signOut();
    _user = null;
    _isAuthenticated = false;
    _isLoading = false;
    notifyListeners();
  }

  void addSavedPassenger(SavedPassenger passenger) {
    if (_user == null) return;
    final updatedList = List<SavedPassenger>.from(_user!.savedPassengers)..add(passenger);
    _user = _user!.copyWith(savedPassengers: updatedList);
    LocalStorageService.setActiveUser(_user!);
    notifyListeners();
  }

  void removeSavedPassenger(String id) {
    if (_user == null) return;
    final updatedList = _user!.savedPassengers.where((p) => p.id != id).toList();
    _user = _user!.copyWith(savedPassengers: updatedList);
    LocalStorageService.setActiveUser(_user!);
    notifyListeners();
  }

  void deleteSavedPassenger(String id) => removeSavedPassenger(id);
}

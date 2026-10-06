import '../models/user_model.dart';
import 'local_storage_service.dart';

class AuthService {
  Future<AppUser?> get currentUser async => await LocalStorageService.getActiveUser();

  Future<AppUser?> signInWithEmail(String email, String password) async {
    return await LocalStorageService.loginUser(
      email: email,
      password: password,
    );
  }

  Future<AppUser> registerWithEmail({
    required String email,
    required String password,
    required String name,
    String? phone,
    String? irctcUserId,
  }) async {
    return await LocalStorageService.registerUser(
      email: email,
      password: password,
      name: name,
      phone: phone,
      irctcId: irctcUserId,
    );
  }

  Future<AppUser> signInAnonymously() async {
    const guest = AppUser(
      uid: 'guest_local_user',
      name: 'Guest Passenger',
      email: '',
      phone: '',
      irctcUserId: '',
      savedPassengers: [],
    );
    await LocalStorageService.setActiveUser(guest);
    return guest;
  }

  Future<void> signOut() async {
    await LocalStorageService.logout();
  }
}

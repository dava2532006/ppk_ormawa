import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user.dart' as app_user; // Alias biar gak bentrok

class AuthService {
  final SupabaseClient _client = Supabase.instance.client;

  // 1. Fungsi Register (Sign Up)
  Future<void> signUp(String email, String password, String name) async {
    final response = await _client.auth.signUp(
      email: email,
      password: password,
      data: {'full_name': name, 'role': 'user'}, // Simpan nama di metadata
    );

    if (response.user == null) {
      throw 'Gagal mendaftar. Coba lagi.';
    }
  }

  // 2. Fungsi Login (Sign In)
  Future<void> signIn(String email, String password) async {
    final response = await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );

    if (response.user == null) {
      throw 'Login gagal. Cek email/password.';
    }
  }

  // 3. Fungsi Logout
  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  // 4. Cek siapa yang sedang login
  app_user.User? getCurrentUser() {
    final session = _client.auth.currentSession;
    if (session == null) return null;

    final user = session.user;
    final metadata = user.userMetadata;

    // Mapping dari Supabase User ke App User Model punya temanmu
    return app_user.User(
      name: metadata?['full_name'] ?? 'User',
      email: user.email ?? '',
      role: app_user.UserRole.user, // Default user biasa
      avatar: null, // Nanti kita urus avatar
    );
  }
}

import 'package:supabase_flutter/supabase_flutter.dart';

/// Admin authentication.
///
/// Production: Supabase email/password auth, restricted by the `admins`
/// table and RLS. Showcase mode: a fixed demo credential pair so the panel
/// can be evaluated without a backend.
class AuthRepository {
  AuthRepository(this._client);

  final SupabaseClient? _client;

  static const String demoEmail = 'admin@aurevia.travel';
  static const String demoPassword = 'aurevia-demo';

  static bool _demoSignedIn = false;

  bool get isSignedIn {
    final client = _client;
    if (client == null) return _demoSignedIn;
    return client.auth.currentSession != null;
  }

  String? get email {
    final client = _client;
    if (client == null) return _demoSignedIn ? demoEmail : null;
    return client.auth.currentUser?.email;
  }

  Future<void> signIn(String email, String password) async {
    final client = _client;
    if (client == null) {
      if (email.trim().toLowerCase() == demoEmail &&
          password == demoPassword) {
        _demoSignedIn = true;
        return;
      }
      throw const AuthException('Invalid credentials.');
    }
    await client.auth.signInWithPassword(email: email.trim(), password: password);
    // Only rows in `admins` may operate the panel.
    final admin = await client
        .from('admins')
        .select('id')
        .eq('user_id', client.auth.currentUser!.id)
        .maybeSingle();
    if (admin == null) {
      await client.auth.signOut();
      throw const AuthException('This account has no admin access.');
    }
  }

  Future<void> signOut() async {
    final client = _client;
    if (client == null) {
      _demoSignedIn = false;
      return;
    }
    await client.auth.signOut();
  }
}

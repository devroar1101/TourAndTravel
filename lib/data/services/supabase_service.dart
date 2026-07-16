import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/config/app_config.dart';

/// Thin lifecycle wrapper around the Supabase SDK.
class SupabaseService {
  SupabaseService._();

  static bool _initialised = false;

  /// Initialises Supabase when credentials are provided at build time.
  /// Safe to call unconditionally from `main`.
  static Future<void> init() async {
    if (!AppConfig.isSupabaseConfigured || _initialised) return;
    await Supabase.initialize(
      url: AppConfig.supabaseUrl,
      // Supabase still issues "anon" keys on every project; the parameter is
      // merely renamed upstream. Swap to `publishableKey` once the dashboard
      // migrates fully.
      // ignore: deprecated_member_use
      anonKey: AppConfig.supabaseAnonKey,
    );
    _initialised = true;
  }

  /// The active client, or `null` in showcase mode.
  static SupabaseClient? get client =>
      _initialised ? Supabase.instance.client : null;
}

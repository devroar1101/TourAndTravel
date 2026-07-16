/// Runtime configuration resolved from `--dart-define` values.
///
/// When Supabase credentials are not supplied the app runs in "showcase
/// mode": all content is served from the bundled seed catalogue and
/// enquiries are accepted in-memory so the experience remains fully
/// browsable in local development and static previews.
class AppConfig {
  AppConfig._();

  static const String supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  static const String supabaseAnonKey =
      String.fromEnvironment('SUPABASE_ANON_KEY');

  static bool get isSupabaseConfigured =>
      supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;

  static const String siteName = 'Aurevia';
  static const String siteTagline = 'Journeys, composed like cinema.';
  static const String siteUrl = 'https://tourandtraveldemo.pages.dev';
}

/// Company-level constants surfaced across the public site.
class AppConstants {
  AppConstants._();

  static const String phone = '+91 98470 12345';
  static const String whatsapp = '+919847012345';
  static const String email = 'concierge@aurevia.travel';
  static const String officeAddress =
      'Aurevia House, 14 Marine Parade, Fort Kochi, Kerala 682001, India';

  static const String instagram = 'https://instagram.com/aurevia.travel';
  static const String facebook = 'https://facebook.com/aurevia.travel';
  static const String youtube = 'https://youtube.com/@aurevia';
  static const String linkedin = 'https://linkedin.com/company/aurevia';

  static const double officeLat = 9.9658;
  static const double officeLng = 76.2422;

  // Company statistics rendered by the story section counters.
  static const int yearsExperience = 16;
  static const int happyTravellers = 48000;
  static const int countriesCovered = 42;
  static const int tourPackages = 120;
  static const int satisfactionPercent = 98;
}

/// Primary navigation entries for the public site.
class NavItem {
  const NavItem(this.label, this.path);

  final String label;
  final String path;
}

const List<NavItem> primaryNav = [
  NavItem('Destinations', '/destinations'),
  NavItem('Collections', '/collections'),
  NavItem('Gallery', '/gallery'),
  NavItem('Journal', '/faq'),
  NavItem('Contact', '/contact'),
];

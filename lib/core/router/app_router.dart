import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/admin/admin_login_page.dart';
import '../../features/admin/admin_shell.dart';
import '../../features/admin/dashboard_page.dart';
import '../../features/admin/enquiries_page.dart';
import '../../features/admin/manage_destinations_page.dart';
import '../../features/admin/manage_faqs_page.dart';
import '../../features/admin/manage_gallery_page.dart';
import '../../features/admin/manage_packages_page.dart';
import '../../features/admin/manage_testimonials_page.dart';
import '../../features/contact/contact_page.dart';
import '../../features/destinations/destination_detail_page.dart';
import '../../features/destinations/destinations_page.dart';
import '../../features/faq/faq_page.dart';
import '../../features/gallery/gallery_page.dart';
import '../../features/home/home_page.dart';
import '../../features/packages/collections_page.dart';
import '../../providers/providers.dart';

/// Application routes with cinematic fade-through transitions and an
/// auth-guarded admin shell.
final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    refreshListenable: AuthController.listenable,
    redirect: (context, state) {
      final signedIn = AuthController.listenable.value;
      final path = state.uri.path;
      final isAdminArea = path.startsWith('/admin') && path != '/admin/login';
      if (isAdminArea && !signedIn) return '/admin/login';
      if (path == '/admin/login' && signedIn) return '/admin';
      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        pageBuilder: (context, state) =>
            _fadePage(state, const HomePage()),
      ),
      GoRoute(
        path: '/destinations',
        pageBuilder: (context, state) =>
            _fadePage(state, const DestinationsPage()),
      ),
      GoRoute(
        path: '/destinations/:slug',
        pageBuilder: (context, state) => _fadePage(
          state,
          DestinationDetailPage(slug: state.pathParameters['slug'] ?? ''),
        ),
      ),
      GoRoute(
        path: '/collections',
        pageBuilder: (context, state) => _fadePage(
          state,
          CollectionsPage(
              initialCategory: state.uri.queryParameters['category']),
        ),
      ),
      GoRoute(
        path: '/gallery',
        pageBuilder: (context, state) =>
            _fadePage(state, const GalleryPage()),
      ),
      GoRoute(
        path: '/faq',
        pageBuilder: (context, state) => _fadePage(state, const FaqPage()),
      ),
      GoRoute(
        path: '/contact',
        pageBuilder: (context, state) => _fadePage(
          state,
          ContactPage(
              prefillDestination: state.uri.queryParameters['destination']),
        ),
      ),
      GoRoute(
        path: '/admin/login',
        pageBuilder: (context, state) =>
            _fadePage(state, const AdminLoginPage()),
      ),
      ShellRoute(
        builder: (context, state, child) => AdminShell(child: child),
        routes: [
          GoRoute(
            path: '/admin',
            pageBuilder: (context, state) =>
                _fadePage(state, const DashboardPage()),
          ),
          GoRoute(
            path: '/admin/enquiries',
            pageBuilder: (context, state) =>
                _fadePage(state, const EnquiriesPage()),
          ),
          GoRoute(
            path: '/admin/destinations',
            pageBuilder: (context, state) =>
                _fadePage(state, const ManageDestinationsPage()),
          ),
          GoRoute(
            path: '/admin/packages',
            pageBuilder: (context, state) =>
                _fadePage(state, const ManagePackagesPage()),
          ),
          GoRoute(
            path: '/admin/gallery',
            pageBuilder: (context, state) =>
                _fadePage(state, const ManageGalleryPage()),
          ),
          GoRoute(
            path: '/admin/testimonials',
            pageBuilder: (context, state) =>
                _fadePage(state, const ManageTestimonialsPage()),
          ),
          GoRoute(
            path: '/admin/faqs',
            pageBuilder: (context, state) =>
                _fadePage(state, const ManageFaqsPage()),
          ),
        ],
      ),
    ],
  );
});

CustomTransitionPage<void> _fadePage(GoRouterState state, Widget child) {
  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 450),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final fade = CurvedAnimation(parent: animation, curve: Curves.easeOut);
      final rise = Tween(begin: const Offset(0, 0.012), end: Offset.zero)
          .animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic));
      return FadeTransition(
        opacity: fade,
        child: SlideTransition(position: rise, child: child),
      );
    },
  );
}

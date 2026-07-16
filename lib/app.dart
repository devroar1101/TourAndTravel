import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'core/config/app_config.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

/// Root widget: theme, router and responsive scaling.
class AureviaApp extends ConsumerWidget {
  const AureviaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    return MaterialApp.router(
      title: '${AppConfig.siteName} — ${AppConfig.siteTagline}',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: router,
      builder: (context, child) => ResponsiveBreakpoints.builder(
        child: child!,
        breakpoints: [
          const Breakpoint(start: 0, end: 600, name: MOBILE),
          const Breakpoint(start: 601, end: 960, name: TABLET),
          const Breakpoint(start: 961, end: 1400, name: DESKTOP),
          const Breakpoint(start: 1401, end: double.infinity, name: '4K'),
        ],
      ),
    );
  }
}

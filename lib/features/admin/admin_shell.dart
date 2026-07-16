import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../data/models/enquiry.dart';
import '../../providers/providers.dart';

/// Admin chrome: midnight side rail, notification bell, sign-out.
class AdminShell extends ConsumerWidget {
  const AdminShell({super.key, required this.child});

  final Widget child;

  static const _items = [
    (label: 'Dashboard', icon: Icons.dashboard_outlined, path: '/admin'),
    (label: 'Enquiries', icon: Icons.inbox_outlined, path: '/admin/enquiries'),
    (label: 'Destinations', icon: Icons.public_outlined, path: '/admin/destinations'),
    (label: 'Packages', icon: Icons.card_travel_outlined, path: '/admin/packages'),
    (label: 'Gallery', icon: Icons.photo_library_outlined, path: '/admin/gallery'),
    (label: 'Testimonials', icon: Icons.format_quote_outlined, path: '/admin/testimonials'),
    (label: 'FAQs', icon: Icons.help_outline, path: '/admin/faqs'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final location = GoRouterState.of(context).uri.path;
    final wide = MediaQuery.sizeOf(context).width > 1000;
    final newCount = ref
            .watch(enquiriesProvider)
            .value
            ?.where((e) => e.status == EnquiryStatus.fresh)
            .length ??
        0;

    final rail = Container(
      width: wide ? 248 : 76,
      color: AppColors.midnightDeep,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(wide ? 28 : 18),
            child: wide
                ? Row(
                    children: [
                      Text('AUREVIA',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                  color: Colors.white,
                                  letterSpacing: 5,
                                  fontWeight: FontWeight.w300)),
                      const SizedBox(width: 5),
                      Container(
                          width: 5,
                          height: 5,
                          decoration: const BoxDecoration(
                              color: AppColors.gold, shape: BoxShape.circle)),
                    ],
                  )
                : const Icon(Icons.travel_explore,
                    color: AppColors.gold, size: 26),
          ),
          const SizedBox(height: 12),
          for (final item in _items)
            _RailItem(
              label: item.label,
              icon: item.icon,
              wide: wide,
              active: location == item.path,
              badge: item.path == '/admin/enquiries' ? newCount : 0,
              onTap: () => context.go(item.path),
            ),
          const Spacer(),
          _RailItem(
            label: 'View site',
            icon: Icons.language,
            wide: wide,
            active: false,
            badge: 0,
            onTap: () => context.go('/'),
          ),
          _RailItem(
            label: 'Sign out',
            icon: Icons.logout,
            wide: wide,
            active: false,
            badge: 0,
            onTap: () async {
              await ref.read(authControllerProvider.notifier).signOut();
              if (context.mounted) context.go('/admin/login');
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.mist,
      body: Row(
        children: [
          rail,
          Expanded(
            child: Column(
              children: [
                _TopBar(newCount: newCount),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(32),
                    child: child,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TopBar extends ConsumerWidget {
  const _TopBar({required this.newCount});

  final int newCount;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final email = ref.watch(authRepositoryProvider).email ?? 'admin';
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 32),
      decoration: BoxDecoration(
        color: AppColors.cloud,
        border: Border(
            bottom:
                BorderSide(color: AppColors.midnight.withValues(alpha: 0.08))),
      ),
      child: Row(
        children: [
          Text('Operations',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w500)),
          const Spacer(),
          Tooltip(
            message: newCount == 0
                ? 'No new enquiries'
                : '$newCount new ${newCount == 1 ? 'enquiry' : 'enquiries'}',
            child: InkWell(
              borderRadius: BorderRadius.circular(24),
              onTap: () => context.go('/admin/enquiries'),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Badge(
                  isLabelVisible: newCount > 0,
                  label: Text('$newCount'),
                  backgroundColor: AppColors.gold,
                  textColor: AppColors.midnightDeep,
                  child: const Icon(Icons.notifications_outlined,
                      color: AppColors.ink),
                ),
              ),
            ),
          ),
          const SizedBox(width: 20),
          CircleAvatar(
            radius: 16,
            backgroundColor: AppColors.midnight,
            child: Text(
              email.substring(0, 1).toUpperCase(),
              style: const TextStyle(color: Colors.white, fontSize: 13),
            ),
          ),
          const SizedBox(width: 10),
          Text(email, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}

class _RailItem extends StatefulWidget {
  const _RailItem({
    required this.label,
    required this.icon,
    required this.wide,
    required this.active,
    required this.badge,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool wide;
  final bool active;
  final int badge;
  final VoidCallback onTap;

  @override
  State<_RailItem> createState() => _RailItemState();
}

class _RailItemState extends State<_RailItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final active = widget.active;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
          padding: EdgeInsets.symmetric(
              horizontal: widget.wide ? 16 : 0, vertical: 12),
          decoration: BoxDecoration(
            color: active
                ? AppColors.gold.withValues(alpha: 0.14)
                : _hovered
                    ? Colors.white.withValues(alpha: 0.06)
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border(
              left: BorderSide(
                color: active ? AppColors.gold : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: widget.wide
                ? MainAxisAlignment.start
                : MainAxisAlignment.center,
            children: [
              Badge(
                isLabelVisible: widget.badge > 0,
                label: Text('${widget.badge}'),
                backgroundColor: AppColors.gold,
                textColor: AppColors.midnightDeep,
                child: Icon(
                  widget.icon,
                  size: 20,
                  color: active ? AppColors.goldBright : AppColors.onDarkSoft,
                ),
              ),
              if (widget.wide) ...[
                const SizedBox(width: 14),
                Text(
                  widget.label,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: active ? Colors.white : AppColors.onDarkSoft,
                        fontWeight:
                            active ? FontWeight.w500 : FontWeight.w300,
                      ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

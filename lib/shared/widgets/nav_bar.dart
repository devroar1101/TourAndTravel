import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/responsive.dart';

/// Fixed top navigation.
///
/// Transparent while resting over the page's dark hero; melts into a
/// midnight glass bar once the page scrolls. Collapses to a full-screen
/// staggered overlay menu on mobile. Sizes to bar-height when closed so
/// pointer events reach the page below.
class NavBar extends StatefulWidget {
  const NavBar({super.key, required this.scrollOffset});

  final ValueListenable<double> scrollOffset;

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  bool _menuOpen = false;

  void _closeMenu() => setState(() => _menuOpen = false);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<double>(
      valueListenable: widget.scrollOffset,
      builder: (context, offset, _) {
        final scrolled = offset > 40;
        final barHeight = scrolled ? 72.0 : 96.0;
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeOut,
              height: barHeight,
              decoration: BoxDecoration(
                color: scrolled || _menuOpen
                    ? AppColors.midnightDeep.withValues(alpha: 0.94)
                    : Colors.transparent,
                border: Border(
                  bottom: BorderSide(
                    color: scrolled && !_menuOpen
                        ? Colors.white.withValues(alpha: 0.08)
                        : Colors.transparent,
                  ),
                ),
              ),
              padding: EdgeInsets.symmetric(horizontal: context.gutter),
              child: Row(
                children: [
                  _Wordmark(onTap: () {
                    _closeMenu();
                    context.go('/');
                  }),
                  const Spacer(),
                  if (context.isDesktop) ...[
                    for (final item in primaryNav) _NavLink(item: item),
                    const SizedBox(width: 28),
                    _PlanButton(onTap: () => context.go('/contact')),
                  ] else
                    _MenuToggle(
                      open: _menuOpen,
                      onTap: () => setState(() => _menuOpen = !_menuOpen),
                    ),
                ],
              ),
            ),
            if (_menuOpen)
              SizedBox(
                height: context.screenHeight - barHeight,
                child: _MobileMenu(onClose: _closeMenu),
              ),
          ],
        );
      },
    );
  }
}

class _Wordmark extends StatelessWidget {
  const _Wordmark({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'AUREVIA',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    letterSpacing: 6,
                    fontWeight: FontWeight.w300,
                    fontSize: 20,
                  ),
            ),
            const SizedBox(width: 6),
            Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                color: AppColors.gold,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavLink extends StatefulWidget {
  const _NavLink({required this.item});

  final NavItem item;

  @override
  State<_NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<_NavLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    final active = location.startsWith(widget.item.path);
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () => context.go(widget.item.path),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.item.label.toUpperCase(),
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: active || _hovered
                          ? Colors.white
                          : Colors.white.withValues(alpha: 0.72),
                      fontSize: 12,
                      letterSpacing: 2,
                    ),
              ),
              const SizedBox(height: 5),
              AnimatedContainer(
                duration: const Duration(milliseconds: 280),
                curve: Curves.easeOut,
                height: 1.5,
                width: active || _hovered ? 20 : 0,
                color: AppColors.gold,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PlanButton extends StatefulWidget {
  const _PlanButton({required this.onTap});

  final VoidCallback onTap;

  @override
  State<_PlanButton> createState() => _PlanButtonState();
}

class _PlanButtonState extends State<_PlanButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
          decoration: BoxDecoration(
            color: _hovered ? AppColors.gold : Colors.transparent,
            border: Border.all(
              color:
                  _hovered ? AppColors.gold : AppColors.gold.withValues(alpha: 0.7),
            ),
          ),
          child: Text(
            'PLAN A JOURNEY',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color:
                      _hovered ? AppColors.midnightDeep : AppColors.goldBright,
                  fontSize: 11.5,
                  letterSpacing: 2.2,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
      ),
    );
  }
}

class _MenuToggle extends StatelessWidget {
  const _MenuToggle({required this.open, required this.onTap});

  final bool open;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        transitionBuilder: (child, animation) =>
            RotationTransition(turns: animation, child: child),
        child: Icon(
          open ? Icons.close : Icons.menu,
          key: ValueKey(open),
          color: Colors.white,
          size: 26,
        ),
      ),
    );
  }
}

class _MobileMenu extends StatelessWidget {
  const _MobileMenu({required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final entries = [const NavItem('Home', '/'), ...primaryNav];
    return Container(
      width: double.infinity,
      color: AppColors.midnightDeep.withValues(alpha: 0.98),
      padding: EdgeInsets.only(
          top: 32, left: context.gutter, right: context.gutter),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final (i, item) in entries.indexed)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    onClose();
                    context.go(item.path);
                  },
                  child: Text(
                    item.label,
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          color: AppColors.onDark,
                          fontSize: 36,
                        ),
                  ),
                ),
              )
                  .animate(delay: Duration(milliseconds: 60 * i))
                  .fadeIn(duration: 450.ms)
                  .moveX(begin: -24, end: 0, curve: Curves.easeOutCubic),
            ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(bottom: 48),
            child: Text(
              AppConstants.email,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: AppColors.onDarkSoft),
            ).animate(delay: 400.ms).fadeIn(),
          ),
        ],
      ),
    );
  }
}

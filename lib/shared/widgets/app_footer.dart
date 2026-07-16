import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../core/config/app_config.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/responsive.dart';

/// Site footer: brand statement, explore links, contact block and social.
class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final isMobile = context.isMobile;

    final columns = <Widget>[
      SizedBox(
        width: isMobile ? double.infinity : 340,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'AUREVIA',
                  style: theme.headlineSmall?.copyWith(
                    color: AppColors.onDark,
                    letterSpacing: 6,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                      color: AppColors.gold, shape: BoxShape.circle),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Text(
              AppConfig.siteTagline,
              style: theme.bodyMedium?.copyWith(color: AppColors.onDarkSoft),
            ),
            const SizedBox(height: 22),
            Row(
              children: [
                _SocialIcon(icon: Icons.camera_alt_outlined, url: AppConstants.instagram, tooltip: 'Instagram'),
                _SocialIcon(icon: Icons.facebook_outlined, url: AppConstants.facebook, tooltip: 'Facebook'),
                _SocialIcon(icon: Icons.play_circle_outline, url: AppConstants.youtube, tooltip: 'YouTube'),
                _SocialIcon(icon: Icons.business_center_outlined, url: AppConstants.linkedin, tooltip: 'LinkedIn'),
              ],
            ),
          ],
        ),
      ),
      _FooterColumn(
        title: 'Explore',
        children: [
          _FooterLink('Destinations', () => context.go('/destinations')),
          _FooterLink('Collections', () => context.go('/collections')),
          _FooterLink('Gallery', () => context.go('/gallery')),
          _FooterLink('Questions', () => context.go('/faq')),
          _FooterLink('Plan a journey', () => context.go('/contact')),
        ],
      ),
      _FooterColumn(
        title: 'Signature Journeys',
        children: [
          _FooterLink('Kerala', () => context.go('/destinations/kerala')),
          _FooterLink('Ladakh', () => context.go('/destinations/ladakh')),
          _FooterLink('Maldives', () => context.go('/destinations/maldives')),
          _FooterLink('Switzerland', () => context.go('/destinations/switzerland')),
          _FooterLink('Bali', () => context.go('/destinations/bali')),
        ],
      ),
      _FooterColumn(
        title: 'Contact',
        children: [
          _FooterExternal(AppConstants.phone, 'tel:${AppConstants.phone.replaceAll(' ', '')}'),
          _FooterExternal('WhatsApp', 'https://wa.me/${AppConstants.whatsapp.replaceAll('+', '')}'),
          _FooterExternal(AppConstants.email, 'mailto:${AppConstants.email}'),
          const SizedBox(height: 8),
          SizedBox(
            width: 260,
            child: Text(
              AppConstants.officeAddress,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: AppColors.onDarkSoft, height: 1.7),
            ),
          ),
        ],
      ),
    ];

    return Container(
      color: AppColors.midnightDeep,
      padding: EdgeInsets.only(top: 80, bottom: 32),
      child: SectionFrame(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isMobile)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final c in columns)
                    Padding(
                        padding: const EdgeInsets.only(bottom: 40), child: c),
                ],
              )
            else
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  columns.first,
                  const Spacer(),
                  for (final c in columns.skip(1))
                    Padding(padding: const EdgeInsets.only(left: 64), child: c),
                ],
              ),
            const SizedBox(height: 56),
            Container(height: 1, color: Colors.white.withValues(alpha: 0.08)),
            const SizedBox(height: 24),
            Wrap(
              spacing: 24,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  '© ${DateTime.now().year} ${AppConfig.siteName} Journeys Pvt. Ltd. All rights reserved.',
                  style: theme.bodySmall
                      ?.copyWith(color: AppColors.onDarkSoft.withValues(alpha: 0.7)),
                ),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () => context.go('/admin/login'),
                    child: Text(
                      'Admin',
                      style: theme.bodySmall?.copyWith(
                          color: AppColors.onDarkSoft.withValues(alpha: 0.45)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _FooterColumn extends StatelessWidget {
  const _FooterColumn({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.toUpperCase(),
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.gold, letterSpacing: 2.4, fontSize: 11),
        ),
        const SizedBox(height: 20),
        ...children,
      ],
    );
  }
}

class _FooterLink extends StatefulWidget {
  const _FooterLink(this.label, this.onTap);

  final String label;
  final VoidCallback onTap;

  @override
  State<_FooterLink> createState() => _FooterLinkState();
}

class _FooterLinkState extends State<_FooterLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: _hovered ? Colors.white : AppColors.onDarkSoft,
                ),
            child: Text(widget.label),
          ),
        ),
      ),
    );
  }
}

class _FooterExternal extends StatelessWidget {
  const _FooterExternal(this.label, this.url);

  final String label;
  final String url;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () => launchUrlString(url),
          child: Text(
            label,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: AppColors.onDarkSoft),
          ),
        ),
      ),
    );
  }
}

class _SocialIcon extends StatefulWidget {
  const _SocialIcon(
      {required this.icon, required this.url, required this.tooltip});

  final IconData icon;
  final String url;
  final String tooltip;

  @override
  State<_SocialIcon> createState() => _SocialIconState();
}

class _SocialIconState extends State<_SocialIcon> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Tooltip(
        message: widget.tooltip,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) => setState(() => _hovered = true),
          onExit: (_) => setState(() => _hovered = false),
          child: GestureDetector(
            onTap: () => launchUrlString(widget.url),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _hovered ? AppColors.gold : Colors.transparent,
                border: Border.all(
                  color: _hovered
                      ? AppColors.gold
                      : Colors.white.withValues(alpha: 0.25),
                ),
              ),
              child: Icon(
                widget.icon,
                size: 18,
                color: _hovered ? AppColors.midnightDeep : AppColors.onDarkSoft,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

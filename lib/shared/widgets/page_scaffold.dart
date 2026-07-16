import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import 'app_footer.dart';
import 'nav_bar.dart';

/// Public-page chrome: lazily-built scroll body, fixed nav, footer, and a
/// floating WhatsApp concierge button.
///
/// Exposes its scroll offset so heroes can parallax and the nav can
/// transition.
class PageScaffold extends StatefulWidget {
  const PageScaffold({
    super.key,
    required this.sections,
    this.withFooter = true,
  });

  /// Builders for each page section, laid out vertically and built lazily.
  final List<Widget Function(BuildContext, ValueNotifier<double>)> sections;
  final bool withFooter;

  @override
  State<PageScaffold> createState() => _PageScaffoldState();
}

class _PageScaffoldState extends State<PageScaffold> {
  final ScrollController _controller = ScrollController();
  final ValueNotifier<double> _offset = ValueNotifier(0);

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => _offset.value = _controller.offset);
  }

  @override
  void dispose() {
    _controller.dispose();
    _offset.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final count = widget.sections.length + (widget.withFooter ? 1 : 0);
    return Scaffold(
      backgroundColor: AppColors.ivory,
      body: Stack(
        children: [
          ScrollConfiguration(
            behavior: const _SmoothScrollBehavior(),
            child: ListView.builder(
              controller: _controller,
              itemCount: count,
              itemBuilder: (context, index) {
                if (index == widget.sections.length) return const AppFooter();
                return widget.sections[index](context, _offset);
              },
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: NavBar(scrollOffset: _offset),
          ),
          const Positioned(
            right: 24,
            bottom: 24,
            child: _WhatsAppButton(),
          ),
        ],
      ),
    );
  }
}

class _SmoothScrollBehavior extends ScrollBehavior {
  const _SmoothScrollBehavior();

  @override
  Widget buildScrollbar(
          BuildContext context, Widget child, ScrollableDetails details) =>
      child;

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) =>
      const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics());
}

class _WhatsAppButton extends StatefulWidget {
  const _WhatsAppButton();

  @override
  State<_WhatsAppButton> createState() => _WhatsAppButtonState();
}

class _WhatsAppButtonState extends State<_WhatsAppButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () => launchUrlString(
            'https://wa.me/${AppConstants.whatsapp.replaceAll('+', '')}'),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
          height: 54,
          padding: EdgeInsets.symmetric(horizontal: _hovered ? 22 : 15),
          decoration: BoxDecoration(
            color: const Color(0xFF1FAF57),
            borderRadius: BorderRadius.circular(27),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF1FAF57).withValues(alpha: 0.4),
                blurRadius: _hovered ? 28 : 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.chat_outlined, color: Colors.white, size: 24),
              AnimatedSize(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOut,
                child: _hovered
                    ? Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          'Chat with us',
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge
                              ?.copyWith(color: Colors.white, letterSpacing: 0.5),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

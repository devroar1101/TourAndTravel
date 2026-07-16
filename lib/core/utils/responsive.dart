import 'package:flutter/widgets.dart';
import 'package:responsive_framework/responsive_framework.dart';

/// Breakpoint helpers layered over responsive_framework.
extension ResponsiveContext on BuildContext {
  bool get isMobile => ResponsiveBreakpoints.of(this).smallerThan(TABLET);
  bool get isTablet => ResponsiveBreakpoints.of(this).equals(TABLET);
  bool get isDesktop => ResponsiveBreakpoints.of(this).largerThan(TABLET);
  bool get isWide => ResponsiveBreakpoints.of(this).largerThan(DESKTOP);

  double get screenWidth => MediaQuery.sizeOf(this).width;
  double get screenHeight => MediaQuery.sizeOf(this).height;

  /// Interpolates a value between mobile and desktop extremes based on width.
  double fluid(double min, double max) {
    const narrow = 380.0;
    const wide = 1600.0;
    final t = ((screenWidth - narrow) / (wide - narrow)).clamp(0.0, 1.0);
    return min + (max - min) * t;
  }

  /// Standard horizontal gutter for full-width sections.
  double get gutter => fluid(20, 96);

  /// Maximum content width for readable layouts.
  double get contentMaxWidth => 1360;
}

/// Constrains a section's content while letting backgrounds bleed full-width.
class SectionFrame extends StatelessWidget {
  const SectionFrame({
    super.key,
    required this.child,
    this.maxWidth,
    this.padding,
  });

  final Widget child;
  final double? maxWidth;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints:
            BoxConstraints(maxWidth: maxWidth ?? context.contentMaxWidth),
        child: Padding(
          padding: padding ??
              EdgeInsets.symmetric(horizontal: context.gutter),
          child: child,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../shared/widgets/page_scaffold.dart';
import 'sections/collections_section.dart';
import 'sections/cta_section.dart';
import 'sections/destinations_section.dart';
import 'sections/hero_section.dart';
import 'sections/story_section.dart';
import 'sections/testimonials_section.dart';

/// The cinematic landing page.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      sections: [
        (context, offset) => HeroSection(scrollOffset: offset),
        (context, _) => const StorySection(),
        (context, _) => const DestinationsSection(),
        (context, _) => const CollectionsSection(),
        (context, _) => const TestimonialsSection(),
        (context, _) => const CtaSection(),
      ],
    );
  }
}

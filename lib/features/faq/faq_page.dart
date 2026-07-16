import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/responsive.dart';
import '../../data/models/content_models.dart';
import '../../providers/providers.dart';
import '../../shared/widgets/buttons.dart';
import '../../shared/widgets/page_header.dart';
import '../../shared/widgets/page_scaffold.dart';
import '../../shared/widgets/reveal.dart';

/// Questions & answers, grouped by category with a sprung accordion.
class FaqPage extends ConsumerWidget {
  const FaqPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PageScaffold(
      sections: [
        (context, offset) => PageHeader(
              eyebrow: 'The journal',
              title: 'Questions,\nanswered honestly',
              subtitle:
                  'Everything travellers ask before their first Aurevia journey. '
                  'Anything else — we\'re one message away.',
              image:
                  'https://images.unsplash.com/photo-1476514525535-07fb3b4ae5f1?auto=format&fit=crop&w=2000&q=75',
              scrollOffset: offset,
            ),
        (context, _) => const _FaqBody(),
        (context, _) => const _StillCurious(),
      ],
    );
  }
}

class _FaqBody extends ConsumerStatefulWidget {
  const _FaqBody();

  @override
  ConsumerState<_FaqBody> createState() => _FaqBodyState();
}

class _FaqBodyState extends ConsumerState<_FaqBody> {
  String? _openId;

  @override
  Widget build(BuildContext context) {
    final faqs = ref.watch(faqsProvider);

    return Container(
      color: AppColors.ivory,
      padding: EdgeInsets.symmetric(vertical: context.fluid(48, 90)),
      child: SectionFrame(
        maxWidth: 900,
        child: faqs.when(
          loading: () => const Padding(
            padding: EdgeInsets.symmetric(vertical: 120),
            child: Center(
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: AppColors.gold)),
          ),
          error: (e, _) => Text('Could not load questions: $e'),
          data: (items) {
            final categories = <String, List<FaqItem>>{};
            for (final f in items) {
              categories.putIfAbsent(f.category, () => []).add(f);
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final entry in categories.entries) ...[
                  Reveal(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20, top: 22),
                      child: Row(
                        children: [
                          Container(
                              width: 26, height: 1, color: AppColors.gold),
                          const SizedBox(width: 12),
                          Text(
                            entry.key.toUpperCase(),
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium
                                ?.copyWith(
                                    color: AppColors.gold,
                                    fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ),
                  for (final (i, faq) in entry.value.indexed)
                    Reveal(
                      delay: Duration(milliseconds: 50 * i),
                      distance: 24,
                      child: _FaqTile(
                        faq: faq,
                        open: _openId == faq.id,
                        onTap: () => setState(
                            () => _openId = _openId == faq.id ? null : faq.id),
                      ),
                    ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}

class _FaqTile extends StatelessWidget {
  const _FaqTile({required this.faq, required this.open, required this.onTap});

  final FaqItem faq;
  final bool open;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOutCubic,
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 20),
          decoration: BoxDecoration(
            color: open ? AppColors.cloud : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: open
                  ? AppColors.gold.withValues(alpha: 0.45)
                  : AppColors.midnight.withValues(alpha: 0.13),
            ),
            boxShadow: open
                ? [
                    BoxShadow(
                        color: AppColors.shadowSoft,
                        blurRadius: 26,
                        offset: const Offset(0, 10)),
                  ]
                : const [],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(faq.question,
                        style: theme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w500)),
                  ),
                  const SizedBox(width: 16),
                  AnimatedRotation(
                    turns: open ? 0.125 : 0,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOutCubic,
                    child: Icon(
                      Icons.add,
                      size: 20,
                      color: open ? AppColors.gold : AppColors.inkSoft,
                    ),
                  ),
                ],
              ),
              AnimatedCrossFade(
                duration: const Duration(milliseconds: 350),
                sizeCurve: Curves.easeOutCubic,
                crossFadeState:
                    open ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                firstChild: const SizedBox(width: double.infinity),
                secondChild: Padding(
                  padding: const EdgeInsets.only(top: 14, right: 36),
                  child: Text(faq.answer, style: theme.bodyMedium),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StillCurious extends StatelessWidget {
  const _StillCurious();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return Container(
      color: AppColors.mist,
      padding: EdgeInsets.symmetric(vertical: context.fluid(56, 90)),
      child: SectionFrame(
        maxWidth: 760,
        child: Reveal(
          child: Column(
            children: [
              Text('Still curious?',
                  style: theme.headlineLarge, textAlign: TextAlign.center),
              const SizedBox(height: 14),
              Text(
                'Our designers answer real questions with real answers — '
                'usually within the hour.',
                style: theme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              AureviaButton(
                label: 'Ask us anything',
                onPressed: () => context.go('/contact'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

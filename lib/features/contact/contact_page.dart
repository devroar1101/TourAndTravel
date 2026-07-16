import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/responsive.dart';
import '../../shared/widgets/enquiry_form.dart';
import '../../shared/widgets/map_embed.dart';
import '../../shared/widgets/page_header.dart';
import '../../shared/widgets/page_scaffold.dart';
import '../../shared/widgets/reveal.dart';
import '../../shared/widgets/section_header.dart';

/// Contact: enquiry form beside the concierge channels, office map below.
class ContactPage extends StatelessWidget {
  const ContactPage({super.key, this.prefillDestination});

  final String? prefillDestination;

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      sections: [
        (context, offset) => PageHeader(
              eyebrow: 'The concierge desk',
              title: 'Speak to a\ntravel designer',
              subtitle:
                  'Phone, WhatsApp, email or the form below — choose your channel; '
                  'the attention is identical.',
              image:
                  'https://images.unsplash.com/photo-1447752875215-b2761acb3c5d?auto=format&fit=crop&w=2000&q=75',
              scrollOffset: offset,
            ),
        (context, _) => _ContactBody(prefillDestination: prefillDestination),
        (context, _) => const _OfficeSection(),
      ],
    );
  }
}

class _ContactBody extends StatelessWidget {
  const _ContactBody({this.prefillDestination});

  final String? prefillDestination;

  @override
  Widget build(BuildContext context) {
    final form = EnquiryForm(prefillDestination: prefillDestination);
    final channels = _Channels();

    return Container(
      color: AppColors.mist,
      padding: EdgeInsets.symmetric(vertical: context.fluid(56, 100)),
      child: SectionFrame(
        child: context.isMobile
            ? Column(children: [
                Reveal(child: channels),
                const SizedBox(height: 36),
                Reveal(child: form),
              ])
            : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 4, child: Reveal(from: RevealFrom.left, child: channels)),
                  const SizedBox(width: 64),
                  Expanded(flex: 7, child: Reveal(child: form)),
                ],
              ),
      ),
    );
  }
}

class _Channels extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          eyebrow: 'Always reachable',
          title: 'Every channel,\na human',
        ),
        const SizedBox(height: 36),
        _ChannelTile(
          icon: Icons.call_outlined,
          title: 'Telephone',
          value: AppConstants.phone,
          hint: '9 AM – 9 PM IST, every day',
          url: 'tel:${AppConstants.phone.replaceAll(' ', '')}',
        ),
        _ChannelTile(
          icon: Icons.chat_outlined,
          title: 'WhatsApp',
          value: 'Message the concierge',
          hint: 'Typically replies in minutes',
          url: 'https://wa.me/${AppConstants.whatsapp.replaceAll('+', '')}',
        ),
        _ChannelTile(
          icon: Icons.alternate_email,
          title: 'Email',
          value: AppConstants.email,
          hint: 'Answered within one working day',
          url: 'mailto:${AppConstants.email}',
        ),
        _ChannelTile(
          icon: Icons.place_outlined,
          title: 'The office',
          value: 'Aurevia House, Fort Kochi',
          hint: AppConstants.officeAddress,
          url:
              'https://maps.google.com/?q=${AppConstants.officeLat},${AppConstants.officeLng}',
        ),
        const SizedBox(height: 12),
        Text('FOLLOW THE JOURNEYS',
            style: theme.labelSmall
                ?.copyWith(letterSpacing: 2.4, color: AppColors.inkSoft)),
        const SizedBox(height: 14),
        Wrap(
          spacing: 12,
          children: [
            _SocialChip('Instagram', AppConstants.instagram),
            _SocialChip('Facebook', AppConstants.facebook),
            _SocialChip('YouTube', AppConstants.youtube),
            _SocialChip('LinkedIn', AppConstants.linkedin),
          ],
        ),
      ],
    );
  }
}

class _ChannelTile extends StatefulWidget {
  const _ChannelTile({
    required this.icon,
    required this.title,
    required this.value,
    required this.hint,
    required this.url,
  });

  final IconData icon;
  final String title;
  final String value;
  final String hint;
  final String url;

  @override
  State<_ChannelTile> createState() => _ChannelTileState();
}

class _ChannelTileState extends State<_ChannelTile> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () => launchUrlString(widget.url),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: _hovered ? AppColors.cloud : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: _hovered
                  ? AppColors.gold.withValues(alpha: 0.5)
                  : AppColors.midnight.withValues(alpha: 0.14),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.midnight.withValues(alpha: 0.05),
                ),
                child:
                    Icon(widget.icon, size: 19, color: AppColors.emeraldDeep),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.title.toUpperCase(),
                        style: theme.labelSmall?.copyWith(
                            fontSize: 10,
                            letterSpacing: 2,
                            color: AppColors.inkSoft)),
                    const SizedBox(height: 4),
                    Text(widget.value,
                        style: theme.titleSmall
                            ?.copyWith(fontWeight: FontWeight.w500)),
                    const SizedBox(height: 3),
                    Text(widget.hint, style: theme.bodySmall),
                  ],
                ),
              ),
              AnimatedSlide(
                duration: const Duration(milliseconds: 250),
                offset: _hovered ? Offset.zero : const Offset(-0.2, 0),
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 250),
                  opacity: _hovered ? 1 : 0,
                  child: const Icon(Icons.arrow_forward,
                      size: 16, color: AppColors.gold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SocialChip extends StatelessWidget {
  const _SocialChip(this.label, this.url);

  final String label;
  final String url;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => launchUrlString(url),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
          decoration: BoxDecoration(
            border:
                Border.all(color: AppColors.midnight.withValues(alpha: 0.2)),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Text(
            label,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: AppColors.ink),
          ),
        ),
      ),
    );
  }
}

class _OfficeSection extends StatelessWidget {
  const _OfficeSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.ivory,
      padding: EdgeInsets.symmetric(vertical: context.fluid(56, 100)),
      child: SectionFrame(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(
              eyebrow: 'Visit us',
              title: 'Fort Kochi,\nwhere it all started',
              body:
                  'The office keeps the door open and the coffee strong. Walk in '
                  'between nine and nine — the harbour sunset is on the house.',
            ),
            const SizedBox(height: 44),
            Reveal(
              scaleFrom: 0.97,
              from: RevealFrom.none,
              child: SizedBox(
                height: context.fluid(320, 480),
                child: MapEmbed(
                  latitude: AppConstants.officeLat,
                  longitude: AppConstants.officeLng,
                  zoom: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

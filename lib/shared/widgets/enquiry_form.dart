import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/formatters.dart';
import '../../core/utils/responsive.dart';
import '../../data/models/enquiry.dart';
import '../../providers/providers.dart';
import 'animated_check.dart';
import 'buttons.dart';

/// The journey enquiry form. Persists to Supabase (or the in-memory pipeline
/// in showcase mode) and plays a drawn-in confirmation on success.
class EnquiryForm extends ConsumerStatefulWidget {
  const EnquiryForm({super.key, this.prefillDestination});

  final String? prefillDestination;

  @override
  ConsumerState<EnquiryForm> createState() => _EnquiryFormState();
}

class _EnquiryFormState extends ConsumerState<EnquiryForm> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _email = TextEditingController();
  final _requirements = TextEditingController();
  final _message = TextEditingController();

  String? _destination;
  DateTime? _travelDate;
  int _adults = 2;
  int _children = 0;
  String _budget = _budgets[1];

  bool _submitting = false;
  bool _submitted = false;

  static const _budgets = [
    'Under ₹50,000',
    '₹50,000 – ₹1,00,000',
    '₹1,00,000 – ₹2,00,000',
    '₹2,00,000 – ₹3,00,000',
    'Above ₹3,00,000',
  ];

  @override
  void initState() {
    super.initState();
    _destination = widget.prefillDestination;
  }

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _email.dispose();
    _requirements.dispose();
    _message.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _submitting = true);
    try {
      await ref.read(enquiryRepositoryProvider).submit(
            Enquiry(
              id: '',
              name: _name.text.trim(),
              phone: _phone.text.trim(),
              email: _email.text.trim(),
              destination: _destination ?? 'Undecided',
              travelDate: _travelDate,
              adults: _adults,
              children: _children,
              budget: _budget,
              specialRequirements: _requirements.text.trim(),
              message: _message.text.trim(),
              status: EnquiryStatus.fresh,
              notes: '',
              createdAt: DateTime.now(),
            ),
          );
      ref.invalidate(enquiriesProvider);
      if (mounted) setState(() => _submitted = true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Something went wrong — please retry. ($e)')),
        );
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final destinations = ref.watch(destinationsProvider).value ?? [];

    return Container(
      padding: EdgeInsets.all(context.fluid(24, 48)),
      decoration: BoxDecoration(
        color: AppColors.cloud,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
              color: AppColors.shadowSoft,
              blurRadius: 40,
              offset: const Offset(0, 16)),
        ],
      ),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 450),
        child: _submitted ? _success(theme) : _form(theme, destinations),
      ),
    );
  }

  Widget _success(TextTheme theme) {
    return Column(
      key: const ValueKey('success'),
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 12),
        const AnimatedCheck(),
        const SizedBox(height: 28),
        Text('Consider it begun.', style: theme.headlineMedium)
            .animate(delay: 500.ms)
            .fadeIn(duration: 600.ms)
            .moveY(begin: 16, curve: Curves.easeOutCubic),
        const SizedBox(height: 12),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 440),
          child: Text(
            'Your enquiry is with our travel designers. Expect a call or a '
            'thoughtfully written email within one working day — and a '
            'confirmation is already on its way to your inbox.',
            textAlign: TextAlign.center,
            style: theme.bodyMedium,
          ),
        ).animate(delay: 700.ms).fadeIn(duration: 600.ms),
        const SizedBox(height: 28),
        AureviaButton(
          label: 'Send another enquiry',
          style: AureviaButtonStyle.ghostDark,
          icon: null,
          onPressed: () => setState(() {
            _submitted = false;
            _formKey.currentState?.reset();
            _name.clear();
            _phone.clear();
            _email.clear();
            _requirements.clear();
            _message.clear();
            _travelDate = null;
          }),
        ).animate(delay: 900.ms).fadeIn(),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _form(TextTheme theme, List destinations) {
    final destinationNames = <String>{
      for (final d in destinations) d.name as String,
      ?_destination,
      'Undecided — advise me',
    }.toList();

    return Form(
      key: _formKey,
      child: Column(
        key: const ValueKey('form'),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Begin the conversation', style: theme.headlineMedium),
          const SizedBox(height: 8),
          Text(
            'Tell us a little; we\'ll do the rest. No obligation, no spam — '
            'just a travel designer\'s full attention.',
            style: theme.bodyMedium,
          ),
          const SizedBox(height: 32),
          _row([
            _field(
              label: 'FULL NAME',
              child: TextFormField(
                controller: _name,
                decoration: const InputDecoration(hintText: 'Aditi Sharma'),
                validator: (v) =>
                    (v == null || v.trim().length < 2) ? 'Your name, please' : null,
              ),
            ),
            _field(
              label: 'PHONE',
              child: TextFormField(
                controller: _phone,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(hintText: '+91 98XXX XXXXX'),
                validator: (v) => (v == null || v.trim().length < 7)
                    ? 'A reachable number'
                    : null,
              ),
            ),
          ]),
          _row([
            _field(
              label: 'EMAIL',
              child: TextFormField(
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(hintText: 'you@example.com'),
                validator: (v) => (v == null || !v.contains('@') || !v.contains('.'))
                    ? 'A valid email'
                    : null,
              ),
            ),
            _field(
              label: 'DESTINATION',
              child: DropdownButtonFormField<String>(
                initialValue: destinationNames.contains(_destination)
                    ? _destination
                    : null,
                hint: const Text('Where to?'),
                items: [
                  for (final name in destinationNames)
                    DropdownMenuItem(value: name, child: Text(name)),
                ],
                onChanged: (v) => setState(() => _destination = v),
                validator: (v) => v == null ? 'Pick one — or "Undecided"' : null,
              ),
            ),
          ]),
          _row([
            _field(
              label: 'TRAVEL DATE',
              child: _DateField(
                value: _travelDate,
                onChanged: (d) => setState(() => _travelDate = d),
              ),
            ),
            _field(
              label: 'BUDGET (PER JOURNEY)',
              child: DropdownButtonFormField<String>(
                initialValue: _budget,
                items: [
                  for (final b in _budgets)
                    DropdownMenuItem(value: b, child: Text(b)),
                ],
                onChanged: (v) => setState(() => _budget = v ?? _budget),
              ),
            ),
          ]),
          _row([
            _field(
              label: 'ADULTS',
              child: _Stepper(
                value: _adults,
                min: 1,
                onChanged: (v) => setState(() => _adults = v),
              ),
            ),
            _field(
              label: 'CHILDREN',
              child: _Stepper(
                value: _children,
                min: 0,
                onChanged: (v) => setState(() => _children = v),
              ),
            ),
          ]),
          _field(
            label: 'SPECIAL REQUIREMENTS',
            child: TextFormField(
              controller: _requirements,
              decoration: const InputDecoration(
                  hintText:
                      'Dietary needs, accessibility, celebrations, anything at all'),
            ),
          ),
          const SizedBox(height: 22),
          _field(
            label: 'YOUR MESSAGE',
            child: TextFormField(
              controller: _message,
              maxLines: 4,
              decoration: const InputDecoration(
                  hintText: 'Tell us about the journey you\'re imagining…'),
            ),
          ),
          const SizedBox(height: 32),
          AureviaButton(
            label: _submitting ? 'Sending' : 'Send enquiry',
            busy: _submitting,
            expand: context.isMobile,
            onPressed: _submit,
          ),
        ],
      ),
    );
  }

  Widget _row(List<Widget> children) {
    if (context.isMobile) {
      return Column(
        children: [
          for (final c in children)
            Padding(padding: const EdgeInsets.only(bottom: 22), child: c),
        ],
      );
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 22),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final (i, c) in children.indexed) ...[
            if (i > 0) const SizedBox(width: 20),
            Expanded(child: c),
          ],
        ],
      ),
    );
  }

  Widget _field({required String label, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
              fontSize: 10.5, letterSpacing: 2, color: AppColors.inkSoft),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}

class _DateField extends StatelessWidget {
  const _DateField({required this.value, required this.onChanged});

  final DateTime? value;
  final ValueChanged<DateTime> onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final now = DateTime.now();
        final picked = await showDatePicker(
          context: context,
          firstDate: now,
          lastDate: now.add(const Duration(days: 730)),
          initialDate: value ?? now.add(const Duration(days: 30)),
        );
        if (picked != null) onChanged(picked);
      },
      child: InputDecorator(
        decoration: const InputDecoration(
          suffixIcon: Icon(Icons.calendar_today_outlined, size: 18),
        ),
        child: Text(
          value == null ? 'Choose a date' : Formatters.date(value!),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: value == null ? AppColors.inkSoft : AppColors.inkStrong,
              ),
        ),
      ),
    );
  }
}

class _Stepper extends StatelessWidget {
  const _Stepper(
      {required this.value, required this.min, required this.onChanged});

  final int value;
  final int min;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 58,
      decoration: BoxDecoration(
        color: AppColors.cloud,
        border: Border.all(color: AppColors.midnight.withValues(alpha: 0.12)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          _button(Icons.remove, value > min ? () => onChanged(value - 1) : null),
          Expanded(
            child: Text(
              '$value',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          _button(Icons.add, value < 20 ? () => onChanged(value + 1) : null),
        ],
      ),
    );
  }

  Widget _button(IconData icon, VoidCallback? onTap) {
    return IconButton(
      onPressed: onTap,
      icon: Icon(icon, size: 18),
      color: AppColors.ink,
      disabledColor: AppColors.inkSoft.withValues(alpha: 0.3),
    );
  }
}

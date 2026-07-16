import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// Page title row used across admin screens.
class AdminHeader extends StatelessWidget {
  const AdminHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.action,
  });

  final String title;
  final String subtitle;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: theme.headlineMedium),
              const SizedBox(height: 6),
              Text(subtitle, style: theme.bodyMedium),
            ],
          ),
        ),
        ?action,
      ],
    );
  }
}

/// Card container used across the admin panel.
class AdminCard extends StatelessWidget {
  const AdminCard({super.key, required this.child, this.padding});

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.cloud,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.midnight.withValues(alpha: 0.07)),
        boxShadow: [
          BoxShadow(
              color: AppColors.shadowSoft,
              blurRadius: 18,
              offset: const Offset(0, 6)),
        ],
      ),
      child: child,
    );
  }
}

/// Labelled text field for admin forms.
class AdminField extends StatelessWidget {
  const AdminField({
    super.key,
    required this.label,
    required this.controller,
    this.maxLines = 1,
    this.hint,
    this.keyboardType,
    this.validator,
  });

  final String label;
  final TextEditingController controller;
  final int maxLines;
  final String? hint;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                fontSize: 10, letterSpacing: 1.8, color: AppColors.inkSoft),
          ),
          const SizedBox(height: 7),
          TextFormField(
            controller: controller,
            maxLines: maxLines,
            keyboardType: keyboardType,
            validator: validator,
            decoration: InputDecoration(
              hintText: hint,
              isDense: true,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            ),
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }
}

/// Confirmation dialog for destructive admin actions.
Future<bool> confirmDelete(BuildContext context, String what) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: AppColors.cloud,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      title: Text('Delete $what?',
          style: Theme.of(context).textTheme.headlineSmall),
      content: Text(
        'This performs a soft delete — the record is archived and can be '
        'restored from the database if needed.',
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Keep it'),
        ),
        FilledButton(
          style: FilledButton.styleFrom(backgroundColor: AppColors.danger),
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Delete'),
        ),
      ],
    ),
  );
  return result ?? false;
}

/// Opens a right-sized admin form dialog.
Future<T?> showAdminDialog<T>(BuildContext context, Widget child) {
  return showDialog<T>(
    context: context,
    builder: (context) => Dialog(
      backgroundColor: AppColors.ivory,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 640, maxHeight: 720),
        child: child,
      ),
    ),
  );
}

/// Status pill with semantic colour.
class StatusPill extends StatelessWidget {
  const StatusPill({super.key, required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: color,
            fontSize: 10,
            letterSpacing: 1.2,
            fontWeight: FontWeight.w600),
      ),
    );
  }
}

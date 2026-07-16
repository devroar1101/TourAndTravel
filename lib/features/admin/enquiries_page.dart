import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web/web.dart' as web;

import '../../core/theme/app_colors.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/enquiry.dart';
import '../../providers/providers.dart';
import 'widgets/admin_widgets.dart';

/// The enquiry pipeline: search, status filter, inline status changes,
/// notes, and one-click CSV export.
class EnquiriesPage extends ConsumerStatefulWidget {
  const EnquiriesPage({super.key});

  @override
  ConsumerState<EnquiriesPage> createState() => _EnquiriesPageState();
}

class _EnquiriesPageState extends ConsumerState<EnquiriesPage> {
  String _query = '';
  EnquiryStatus? _statusFilter;
  String? _expandedId;

  static const statusColors = {
    EnquiryStatus.fresh: AppColors.info,
    EnquiryStatus.contacted: AppColors.warning,
    EnquiryStatus.quoted: AppColors.gold,
    EnquiryStatus.confirmed: AppColors.emerald,
    EnquiryStatus.completed: AppColors.emeraldDeep,
    EnquiryStatus.cancelled: AppColors.danger,
  };

  List<Enquiry> _filter(List<Enquiry> all) {
    var list = all;
    if (_statusFilter != null) {
      list = list.where((e) => e.status == _statusFilter).toList();
    }
    if (_query.isNotEmpty) {
      final q = _query.toLowerCase();
      list = list
          .where((e) =>
              e.name.toLowerCase().contains(q) ||
              e.email.toLowerCase().contains(q) ||
              e.phone.contains(q) ||
              e.destination.toLowerCase().contains(q))
          .toList();
    }
    return list;
  }

  void _exportCsv(List<Enquiry> list) {
    String esc(String v) => '"${v.replaceAll('"', '""')}"';
    final rows = <String>[
      'Name,Phone,Email,Destination,Travel Date,Adults,Children,Budget,Status,Message,Special Requirements,Notes,Received',
      for (final e in list)
        [
          esc(e.name),
          esc(e.phone),
          esc(e.email),
          esc(e.destination),
          e.travelDate == null ? '' : Formatters.date(e.travelDate!),
          '${e.adults}',
          '${e.children}',
          esc(e.budget),
          e.status.label,
          esc(e.message),
          esc(e.specialRequirements),
          esc(e.notes),
          Formatters.dateTime(e.createdAt),
        ].join(','),
    ];
    final csv = rows.join('\r\n');
    final anchor = web.HTMLAnchorElement()
      ..href = 'data:text/csv;charset=utf-8,${Uri.encodeComponent(csv)}'
      ..download =
          'aurevia-enquiries-${DateTime.now().toIso8601String().substring(0, 10)}.csv';
    anchor.click();
  }

  @override
  Widget build(BuildContext context) {
    final enquiries = ref.watch(enquiriesProvider);

    return enquiries.when(
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: 160),
        child: Center(
            child: CircularProgressIndicator(
                strokeWidth: 2, color: AppColors.gold)),
      ),
      error: (e, _) => Text('Could not load enquiries: $e'),
      data: (all) {
        final list = _filter(all);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AdminHeader(
              title: 'Enquiries',
              subtitle:
                  '${all.length} total · ${all.where((e) => e.status == EnquiryStatus.fresh).length} awaiting first contact',
              action: FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.midnight,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 18),
                ),
                onPressed: list.isEmpty ? null : () => _exportCsv(list),
                icon: const Icon(Icons.download_outlined, size: 18),
                label: Text('Export CSV (${list.length})'),
              ),
            ),
            const SizedBox(height: 24),
            AdminCard(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (v) => setState(() => _query = v),
                      decoration: const InputDecoration(
                        hintText:
                            'Search by name, email, phone or destination…',
                        prefixIcon: Icon(Icons.search, size: 20),
                        isDense: true,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  DropdownButton<EnquiryStatus?>(
                    value: _statusFilter,
                    hint: const Text('All statuses'),
                    underline: const SizedBox.shrink(),
                    items: [
                      const DropdownMenuItem(
                          value: null, child: Text('All statuses')),
                      for (final s in EnquiryStatus.values)
                        DropdownMenuItem(value: s, child: Text(s.label)),
                    ],
                    onChanged: (v) => setState(() => _statusFilter = v),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            if (list.isEmpty)
              const AdminCard(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(child: Text('Nothing matches that filter.')),
                ),
              )
            else
              for (final e in list)
                _EnquiryTile(
                  enquiry: e,
                  expanded: _expandedId == e.id,
                  color: statusColors[e.status] ?? AppColors.inkSoft,
                  onToggle: () => setState(
                      () => _expandedId = _expandedId == e.id ? null : e.id),
                ),
          ],
        );
      },
    );
  }
}

class _EnquiryTile extends ConsumerStatefulWidget {
  const _EnquiryTile({
    required this.enquiry,
    required this.expanded,
    required this.color,
    required this.onToggle,
  });

  final Enquiry enquiry;
  final bool expanded;
  final Color color;
  final VoidCallback onToggle;

  @override
  ConsumerState<_EnquiryTile> createState() => _EnquiryTileState();
}

class _EnquiryTileState extends ConsumerState<_EnquiryTile> {
  late final TextEditingController _notes =
      TextEditingController(text: widget.enquiry.notes);
  bool _savingNotes = false;

  @override
  void dispose() {
    _notes.dispose();
    super.dispose();
  }

  Future<void> _setStatus(EnquiryStatus status) async {
    await ref
        .read(enquiryRepositoryProvider)
        .updateStatus(widget.enquiry.id, status);
    ref.invalidate(enquiriesProvider);
  }

  Future<void> _saveNotes() async {
    setState(() => _savingNotes = true);
    await ref
        .read(enquiryRepositoryProvider)
        .updateNotes(widget.enquiry.id, _notes.text.trim());
    ref.invalidate(enquiriesProvider);
    if (mounted) {
      setState(() => _savingNotes = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Notes saved.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final e = widget.enquiry;
    final theme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: AdminCard(
        padding: EdgeInsets.zero,
        child: Column(
          children: [
            InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: widget.onToggle,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
                child: Row(
                  children: [
                    Container(
                      width: 4,
                      height: 40,
                      decoration: BoxDecoration(
                        color: widget.color,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(e.name, style: theme.titleSmall),
                          Text('${e.email} · ${e.phone}',
                              style: theme.bodySmall?.copyWith(fontSize: 12)),
                        ],
                      ),
                    ),
                    Expanded(
                        flex: 2,
                        child: Text(e.destination, style: theme.bodyMedium)),
                    if (MediaQuery.sizeOf(context).width > 860) ...[
                      Expanded(
                        flex: 2,
                        child: Text(
                          e.travelDate == null
                              ? 'Date open'
                              : Formatters.date(e.travelDate!),
                          style: theme.bodySmall,
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                            '${e.adults} adult${e.adults == 1 ? '' : 's'}'
                            '${e.children > 0 ? ' · ${e.children} child${e.children == 1 ? '' : 'ren'}' : ''}',
                            style: theme.bodySmall),
                      ),
                    ],
                    StatusPill(label: e.status.label, color: widget.color),
                    const SizedBox(width: 10),
                    AnimatedRotation(
                      turns: widget.expanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 250),
                      child: const Icon(Icons.keyboard_arrow_down, size: 20),
                    ),
                  ],
                ),
              ),
            ),
            AnimatedCrossFade(
              duration: const Duration(milliseconds: 300),
              sizeCurve: Curves.easeOutCubic,
              crossFadeState: widget.expanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              firstChild: const SizedBox(width: double.infinity),
              secondChild: Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(42, 4, 22, 22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Divider(
                        color: AppColors.midnight.withValues(alpha: 0.06)),
                    const SizedBox(height: 14),
                    Wrap(
                      spacing: 40,
                      runSpacing: 14,
                      children: [
                        _detail('Budget', e.budget.isEmpty ? '—' : e.budget),
                        _detail('Received', Formatters.dateTime(e.createdAt)),
                        _detail(
                            'Special requirements',
                            e.specialRequirements.isEmpty
                                ? '—'
                                : e.specialRequirements),
                      ],
                    ),
                    if (e.message.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      _detail('Message', e.message),
                    ],
                    const SizedBox(height: 20),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('MOVE TO',
                                style: theme.labelSmall?.copyWith(
                                    fontSize: 9.5, letterSpacing: 1.6)),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                for (final s in EnquiryStatus.values)
                                  if (s != e.status)
                                    OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                        visualDensity: VisualDensity.compact,
                                        side: BorderSide(
                                            color: _EnquiriesPageState
                                                    .statusColors[s]!
                                                .withValues(alpha: 0.5)),
                                        foregroundColor: _EnquiriesPageState
                                            .statusColors[s],
                                      ),
                                      onPressed: () => _setStatus(s),
                                      child: Text(s.label,
                                          style:
                                              const TextStyle(fontSize: 12)),
                                    ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text('INTERNAL NOTES',
                        style: theme.labelSmall
                            ?.copyWith(fontSize: 9.5, letterSpacing: 1.6)),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _notes,
                            maxLines: 2,
                            decoration: const InputDecoration(
                              hintText:
                                  'Call outcomes, quote numbers, preferences…',
                              isDense: true,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        FilledButton(
                          style: FilledButton.styleFrom(
                              backgroundColor: AppColors.emeraldDeep,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 22, vertical: 20)),
                          onPressed: _savingNotes ? null : _saveNotes,
                          child:
                              Text(_savingNotes ? 'Saving…' : 'Save notes'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _detail(String label, String value) {
    final theme = Theme.of(context).textTheme;
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 420),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label.toUpperCase(),
              style: theme.labelSmall?.copyWith(
                  fontSize: 9.5,
                  letterSpacing: 1.6,
                  color: AppColors.inkSoft)),
          const SizedBox(height: 4),
          Text(value, style: theme.bodyMedium),
        ],
      ),
    );
  }
}

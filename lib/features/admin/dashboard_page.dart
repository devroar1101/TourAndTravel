import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/enquiry.dart';
import '../../providers/providers.dart';
import 'widgets/admin_widgets.dart';

/// Operations dashboard: headline numbers, a fourteen-day enquiry trend,
/// the status pipeline and the latest enquiries.
class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enquiries = ref.watch(enquiriesProvider);

    return enquiries.when(
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: 160),
        child: Center(
            child: CircularProgressIndicator(
                strokeWidth: 2, color: AppColors.gold)),
      ),
      error: (e, _) => Text('Could not load the dashboard: $e'),
      data: (all) {
        final now = DateTime.now();
        final today = all
            .where((e) =>
                e.createdAt.year == now.year &&
                e.createdAt.month == now.month &&
                e.createdAt.day == now.day)
            .length;
        final month = all
            .where((e) =>
                e.createdAt.year == now.year && e.createdAt.month == now.month)
            .length;

        final byDestination = <String, int>{};
        for (final e in all) {
          byDestination[e.destination] =
              (byDestination[e.destination] ?? 0) + 1;
        }
        final popular = byDestination.entries.isEmpty
            ? '—'
            : (byDestination.entries.toList()
                  ..sort((a, b) => b.value.compareTo(a.value)))
                .first
                .key;

        final confirmed =
            all.where((e) => e.status == EnquiryStatus.confirmed).length;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AdminHeader(
              title: 'Good ${_daypart(now)}.',
              subtitle: DateFormat('EEEE, d MMMM yyyy').format(now),
            ),
            const SizedBox(height: 28),
            Wrap(
              spacing: 20,
              runSpacing: 20,
              children: [
                _StatCard(
                    label: 'Today\'s enquiries',
                    value: '$today',
                    icon: Icons.today_outlined,
                    color: AppColors.info),
                _StatCard(
                    label: 'This month',
                    value: '$month',
                    icon: Icons.calendar_month_outlined,
                    color: AppColors.emerald),
                _StatCard(
                    label: 'Most requested',
                    value: popular,
                    icon: Icons.favorite_outline,
                    color: AppColors.gold),
                _StatCard(
                    label: 'Confirmed journeys',
                    value: '$confirmed',
                    icon: Icons.verified_outlined,
                    color: AppColors.emeraldDeep),
              ],
            ),
            const SizedBox(height: 28),
            LayoutBuilder(builder: (context, constraints) {
              final narrow = constraints.maxWidth < 980;
              final trend = _TrendChart(enquiries: all);
              final pipeline = _PipelineChart(enquiries: all);
              if (narrow) {
                return Column(children: [
                  trend,
                  const SizedBox(height: 20),
                  pipeline
                ]);
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 3, child: trend),
                  const SizedBox(width: 20),
                  Expanded(flex: 2, child: pipeline),
                ],
              );
            }),
            const SizedBox(height: 28),
            _RecentEnquiries(enquiries: all.take(6).toList()),
          ],
        );
      },
    );
  }

  String _daypart(DateTime now) => now.hour < 12
      ? 'morning'
      : now.hour < 17
          ? 'afternoon'
          : 'evening';
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return AdminCard(
      child: SizedBox(
        width: 218,
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 21),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.headlineSmall
                        ?.copyWith(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 2),
                  Text(label.toUpperCase(),
                      style: theme.labelSmall?.copyWith(
                          fontSize: 9.5,
                          letterSpacing: 1.4,
                          color: AppColors.inkSoft)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TrendChart extends StatelessWidget {
  const _TrendChart({required this.enquiries});

  final List<Enquiry> enquiries;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final now = DateTime.now();
    final days = List.generate(14, (i) {
      final day = now.subtract(Duration(days: 13 - i));
      final count = enquiries
          .where((e) =>
              e.createdAt.year == day.year &&
              e.createdAt.month == day.month &&
              e.createdAt.day == day.day)
          .length;
      return (day: day, count: count);
    });
    final maxY =
        (days.map((d) => d.count).fold(0, (a, b) => a > b ? a : b) + 1)
            .toDouble();

    return AdminCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Enquiries — last 14 days', style: theme.titleMedium),
          const SizedBox(height: 24),
          SizedBox(
            height: 240,
            child: LineChart(
              LineChartData(
                minY: 0,
                maxY: maxY,
                gridData: FlGridData(
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (_) => FlLine(
                    color: AppColors.midnight.withValues(alpha: 0.06),
                    strokeWidth: 1,
                  ),
                ),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(),
                  rightTitles: const AxisTitles(),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 28,
                      interval: 1,
                      getTitlesWidget: (v, _) => Text(
                        v.toInt().toString(),
                        style: theme.labelSmall?.copyWith(fontSize: 10),
                      ),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 2,
                      getTitlesWidget: (v, _) {
                        final i = v.toInt();
                        if (i < 0 || i >= days.length) {
                          return const SizedBox.shrink();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            DateFormat('d/M').format(days[i].day),
                            style: theme.labelSmall?.copyWith(fontSize: 10),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: [
                      for (final (i, d) in days.indexed)
                        FlSpot(i.toDouble(), d.count.toDouble()),
                    ],
                    isCurved: true,
                    curveSmoothness: 0.35,
                    color: AppColors.emerald,
                    barWidth: 2.5,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.emerald.withValues(alpha: 0.18),
                          AppColors.emerald.withValues(alpha: 0.0),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeOutCubic,
            ),
          ),
        ],
      ),
    );
  }
}

class _PipelineChart extends StatelessWidget {
  const _PipelineChart({required this.enquiries});

  final List<Enquiry> enquiries;

  static const _colors = {
    EnquiryStatus.fresh: AppColors.info,
    EnquiryStatus.contacted: AppColors.warning,
    EnquiryStatus.quoted: AppColors.gold,
    EnquiryStatus.confirmed: AppColors.emerald,
    EnquiryStatus.completed: AppColors.emeraldDeep,
    EnquiryStatus.cancelled: AppColors.danger,
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final total = enquiries.length;

    return AdminCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Pipeline', style: theme.titleMedium),
          const SizedBox(height: 24),
          SizedBox(
            height: 150,
            child: Row(
              children: [
                Expanded(
                  child: PieChart(
                    PieChartData(
                      sectionsSpace: 3,
                      centerSpaceRadius: 42,
                      sections: [
                        for (final status in EnquiryStatus.values)
                          if (enquiries
                              .where((e) => e.status == status)
                              .isNotEmpty)
                            PieChartSectionData(
                              value: enquiries
                                  .where((e) => e.status == status)
                                  .length
                                  .toDouble(),
                              color: _colors[status],
                              radius: 26,
                              showTitle: false,
                            ),
                      ],
                    ),
                    duration: const Duration(milliseconds: 600),
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('$total',
                        style: theme.headlineMedium
                            ?.copyWith(fontWeight: FontWeight.w500)),
                    Text('TOTAL',
                        style: theme.labelSmall?.copyWith(
                            fontSize: 9, letterSpacing: 1.6)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 14,
            runSpacing: 10,
            children: [
              for (final status in EnquiryStatus.values)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                        width: 9,
                        height: 9,
                        decoration: BoxDecoration(
                            color: _colors[status], shape: BoxShape.circle)),
                    const SizedBox(width: 6),
                    Text(
                      '${status.label} · ${enquiries.where((e) => e.status == status).length}',
                      style: theme.bodySmall?.copyWith(fontSize: 12),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RecentEnquiries extends StatelessWidget {
  const _RecentEnquiries({required this.enquiries});

  final List<Enquiry> enquiries;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return AdminCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                  child: Text('Recent enquiries', style: theme.titleMedium)),
              TextButton(
                onPressed: () => context.go('/admin/enquiries'),
                child: const Text('View all →'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          for (final e in enquiries)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                      color: AppColors.midnight.withValues(alpha: 0.06)),
                ),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 17,
                    backgroundColor:
                        AppColors.emeraldDeep.withValues(alpha: 0.1),
                    child: Text(
                      e.name.substring(0, 1).toUpperCase(),
                      style: theme.titleSmall
                          ?.copyWith(color: AppColors.emeraldDeep),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(e.name, style: theme.titleSmall),
                        Text(e.email,
                            style:
                                theme.bodySmall?.copyWith(fontSize: 12)),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(e.destination, style: theme.bodyMedium),
                  ),
                  if (MediaQuery.sizeOf(context).width > 800)
                    Expanded(
                      flex: 2,
                      child: Text(Formatters.dateTime(e.createdAt),
                          style: theme.bodySmall),
                    ),
                  _StatusDot(status: e.status),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _StatusDot extends StatelessWidget {
  const _StatusDot({required this.status});

  final EnquiryStatus status;

  @override
  Widget build(BuildContext context) {
    return StatusPill(
      label: status.label,
      color: _PipelineChart._colors[status] ?? AppColors.inkSoft,
    );
  }
}

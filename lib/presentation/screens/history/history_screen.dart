import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/providers.dart';
import '../../providers/history_notifier.dart';
import 'widgets/history_calendar_view.dart';
import 'widgets/history_list_view.dart';
import 'widgets/stats_summary.dart';

/// History screen showing check-in records
class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyState = ref.watch(historyNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Check-in History'),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list),
            onSelected: (value) {
              final notifier = ref.read(historyNotifierProvider.notifier);
              switch (value) {
                case 'last30':
                  notifier.setLast30Days();
                  break;
                case 'last90':
                  notifier.setLast90Days();
                  break;
                case 'month':
                  notifier.setCurrentMonth();
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'last30',
                child: Text('Last 30 Days'),
              ),
              const PopupMenuItem(
                value: 'last90',
                child: Text('Last 90 Days'),
              ),
              const PopupMenuItem(
                value: 'month',
                child: Text('Current Month'),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // View Mode Toggle
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SegmentedButton<HistoryViewMode>(
              segments: const [
                ButtonSegment(
                  value: HistoryViewMode.calendar,
                  icon: Icon(Icons.calendar_month),
                  label: Text('Calendar'),
                ),
                ButtonSegment(
                  value: HistoryViewMode.list,
                  icon: Icon(Icons.list),
                  label: Text('List'),
                ),
              ],
              selected: {historyState.viewMode},
              onSelectionChanged: (Set<HistoryViewMode> newSelection) {
                ref
                    .read(historyNotifierProvider.notifier)
                    .setViewMode(newSelection.first);
              },
            ),
          ),

          // Statistics Summary
          StatsSummary(
            completionRate: historyState.completionRate,
            currentStreak: historyState.currentStreak,
            longestStreak: historyState.longestStreak,
            totalCompleted: historyState.totalCompleted,
            totalMissed: historyState.totalMissed,
          ),

          // View Content
          Expanded(
            child: historyState.viewMode == HistoryViewMode.calendar
                ? HistoryCalendarView(
                    records: historyState.records,
                    rangeStart: historyState.rangeStart,
                    rangeEnd: historyState.rangeEnd,
                  )
                : HistoryListView(
                    records: historyState.records,
                  ),
          ),
        ],
      ),
    );
  }
}

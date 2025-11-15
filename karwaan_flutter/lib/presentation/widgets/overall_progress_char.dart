// overall_progress_chart.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:karwaan_flutter/domain/models/board/overall_analytics.dart';

class OverallProgressChart extends StatefulWidget {
  final OverallAnalytics analytics;

  const OverallProgressChart({super.key, required this.analytics});

  @override
  State<OverallProgressChart> createState() => _OverallProgressChartState();
}

class _OverallProgressChartState extends State<OverallProgressChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.transparent,
      elevation: 0,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
          ? Colors.white.withValues(alpha: 0.05)
          : Colors.black.withValues(alpha: 0.02),
          border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.4)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Your existing header
              Text(
                'Overall Progress',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 15),
              // Your existing content - COMPLETELY UNCHANGED
              _buildProgressOverview(context),
              const SizedBox(height: 25),
              _buildPieChart(context),
              const SizedBox(height: 15),
              if (widget.analytics.cardsPerWorkspace != null &&
                  widget.analytics.cardsPerWorkspace!.isNotEmpty)
                _buildWorkspaceDistribution(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressOverview(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildStatCard(
          context,
          'Total Tasks',
          widget.analytics.totalCards.toString(),
          Icons.task_outlined,
          Colors.blue,
        ),
        _buildStatCard(
          context,
          'Completed',
          widget.analytics.compeletedCards.toString(),
          Icons.check_circle,
          Colors.green,
        ),
        _buildStatCard(
          context,
          'Progress',
          '${widget.analytics.completionPercentage.toStringAsFixed(1)}%',
          Icons.trending_up,
          Colors.orange,
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withAlpha(40),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
        ),
        Text(
          title,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
                fontSize: 10,
              ),
        ),
      ],
    );
  }

  Widget _buildPieChart(BuildContext context) {
    final completed = widget.analytics.compeletedCards.toDouble();
    final pending =
        (widget.analytics.totalCards - widget.analytics.compeletedCards)
            .toDouble();

    // Don't show chart if no data
    if (widget.analytics.totalCards == 0) {
      return Container(
        height: 120,
        alignment: Alignment.center,
        child:
            Text('No tasks yet', style: Theme.of(context).textTheme.bodySmall),
      );
    }

    return SizedBox(
      height: 200,
      child: PieChart(
        PieChartData(
          pieTouchData: PieTouchData(
            touchCallback: (FlTouchEvent event, pieTouchResponse) {
              setState(() {
                if (!event.isInterestedForInteractions ||
                    pieTouchResponse == null ||
                    pieTouchResponse.touchedSection == null) {
                  touchedIndex = -1;
                  return;
                }
                touchedIndex =
                    pieTouchResponse.touchedSection!.touchedSectionIndex;
              });
            },
          ),
          borderData: FlBorderData(show: false),
          sectionsSpace: 0,
          centerSpaceRadius: 40,
          sections: _buildChartSections(completed, pending, context),
        ),
      ),
    );
  }

  List<PieChartSectionData> _buildChartSections(
      double completed, double pending, BuildContext context) {
    final completedPercentage = widget.analytics.totalCards > 0
        ? (completed / widget.analytics.totalCards) * 100
        : 0;
    final pendingPercentage = widget.analytics.totalCards > 0
        ? (pending / widget.analytics.totalCards) * 100
        : 0;

    return [
      if (completed > 0)
        PieChartSectionData(
          color: Colors.green,
          value: completed,
          title: '${completedPercentage.toStringAsFixed(0)}%',
          radius: _getRadiusForIndex(0),
          titleStyle: TextStyle(
            fontSize: _getFontSizeForIndex(0),
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: const [Shadow(color: Colors.black, blurRadius: 2)],
          ),
          badgeWidget: _buildBadge(Icons.check_circle, Colors.green, 0),
          badgePositionPercentageOffset: 1.1,
        ),
      if (pending > 0)
        PieChartSectionData(
          color: Colors.orange,
          value: pending,
          title: '${pendingPercentage.toStringAsFixed(0)}%',
          radius: _getRadiusForIndex(1),
          titleStyle: TextStyle(
            fontSize: _getFontSizeForIndex(1),
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: const [Shadow(color: Colors.black, blurRadius: 2)],
          ),
          badgeWidget: _buildBadge(Icons.pending_actions, Colors.orange, 1),
          badgePositionPercentageOffset: 1.1,
        ),
    ];
  }

  double _getRadiusForIndex(int index) {
    return touchedIndex == index ? 60.0 : 50.0;
  }

  double _getFontSizeForIndex(int index) {
    return touchedIndex == index ? 16.0 : 14.0;
  }

  Widget _buildBadge(IconData icon, Color color, int index) {
    final isTouched = touchedIndex == index;
    final size = isTouched ? 35.0 : 30.0;

    return AnimatedContainer(
      duration: PieChart.defaultDuration,
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: color,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            offset: const Offset(2, 2),
            blurRadius: 3,
          ),
        ],
      ),
      child: Center(
        child: Icon(
          icon,
          size: size * 0.5,
          color: color,
        ),
      ),
    );
  }

  Widget _buildWorkspaceDistribution(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tasks by Workspace',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
        ),
        const SizedBox(height: 8),
        ...widget.analytics.cardsPerWorkspace!.entries.map((entry) {
          final percentage = widget.analytics.totalCards > 0
              ? (entry.value / widget.analytics.totalCards) * 100
              : 0;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    entry.key,
                    style: const TextStyle(fontSize: 10),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: LinearProgressIndicator(
                    value: percentage / 100,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _getColorForWorkspace(entry.key),
                    ),
                    minHeight: 6,
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  flex: 2,
                  child: Text(
                    '${entry.value}',
                    style: const TextStyle(fontSize: 10),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Color _getColorForWorkspace(String workspaceName) {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.red,
      Colors.teal,
      Colors.amber,
    ];
    final index = workspaceName.hashCode % colors.length;
    return colors[index];
  }
}

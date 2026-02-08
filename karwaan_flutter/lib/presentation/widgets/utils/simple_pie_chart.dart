import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:karwaan_flutter/domain/models/board/board_analytics.dart';

class SimplePieChart extends StatefulWidget {
  final BoardAnalytics analytics;
  const SimplePieChart({super.key, required this.analytics});

  @override
  State<SimplePieChart> createState() => _SimplePieChartState();
}

class _SimplePieChartState extends State<SimplePieChart> {
  @override
  Widget build(BuildContext context) {
    final completed = widget.analytics.completedCards.toDouble();
    final pending =
        (widget.analytics.totalCards - widget.analytics.completedCards)
            .toDouble();

    if (widget.analytics.totalCards == 0) {
      return Container(
        height: 120,
        alignment: Alignment.center,
        child:
            Text('No Tasks Yet', style: Theme.of(context).textTheme.bodySmall),
      );
    }
    return SizedBox(
      height: 200,
      child: PieChart(PieChartData(
        borderData: FlBorderData(show: false),
        sectionsSpace: 0,
        centerSpaceRadius: 40,
        sections: _buildChartSections(completed, pending),
      )),
    );
  }

  List<PieChartSectionData> _buildChartSections(
      double completed, double pending) {
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
          radius: 50,
          titleStyle: TextStyle(
              fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
          badgeWidget: _buildBadge(Icons.check_circle, Colors.green, 0),
          badgePositionPercentageOffset: 1.1,
        ),
      if (pending > 0)
        PieChartSectionData(
            color: Colors.orange,
            value: pending,
            title: '${pendingPercentage.toStringAsFixed(0)}%',
            radius: 50,
            titleStyle: TextStyle(
                fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
            badgeWidget: _buildBadge(Icons.pending_actions, Colors.orange, 1),
            badgePositionPercentageOffset: 1.1)
    ];
  }

  Widget _buildBadge(IconData icon, Color color, int index) {
    final size = 30.0;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 2),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withAlpha(51),
              offset: const Offset(2, 2),
              blurRadius: 3)
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
}

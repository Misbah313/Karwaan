import 'package:flutter/material.dart';
import 'package:karwaan_flutter/domain/models/board/overall_analytics.dart';
import 'package:karwaan_flutter/presentation/widgets/utils/pie_char_with_touch.dart';
class StlOverallProgressChar extends StatelessWidget {
  final OverallAnalytics analytics;

  const StlOverallProgressChar({super.key, required this.analytics});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.transparent,
      elevation: 0,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white.withAlpha(13) // ~5%
              : Colors.black.withAlpha(5),  // ~2%
          border: Border.all(color: Theme.of(context).dividerColor.withAlpha(102)), // ~0.4
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Overall Progress',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              _buildProgressOverview(context),
              const SizedBox(height: 25),
              PieChartWithTouch(analytics: analytics), // <-- Inner StatefulWidget
              const SizedBox(height: 15),
              if (analytics.cardsPerWorkspace != null &&
                  analytics.cardsPerWorkspace!.isNotEmpty)
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
            context, 'Total Tasks', analytics.totalCards.toString(), Icons.task_outlined, Colors.blue),
        _buildStatCard(
            context, 'Completed', analytics.compeletedCards.toString(), Icons.check_circle, Colors.green),
        _buildStatCard(
            context, 'Progress', '${analytics.completionPercentage.toStringAsFixed(1)}%', Icons.trending_up, Colors.orange),
      ],
    );
  }

  Widget _buildStatCard(BuildContext context, String title, String value, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(color: color.withAlpha(40), shape: BoxShape.circle),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        Text(title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey[600], fontSize: 10)),
      ],
    );
  }

  Widget _buildWorkspaceDistribution(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Tasks by Workspace',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold, fontSize: 12)),
        const SizedBox(height: 8),
        ...analytics.cardsPerWorkspace!.entries.map((entry) {
          final percentage = analytics.totalCards > 0 ? (entry.value / analytics.totalCards) * 100 : 0;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Row(
              children: [
                Expanded(flex: 3, child: Text(entry.key, style: const TextStyle(fontSize: 10), overflow: TextOverflow.ellipsis)),
                Expanded(
                  flex: 5,
                  child: LinearProgressIndicator(
                    value: percentage / 100,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation(_getColorForWorkspace(entry.key)),
                    minHeight: 6,
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(flex: 2, child: Text('${entry.value}', style: const TextStyle(fontSize: 10), textAlign: TextAlign.right)),
              ],
            ),
          );
        }),
      ],
    );
  }

  Color _getColorForWorkspace(String workspaceName) {
    final colors = [Colors.blue, Colors.green, Colors.orange, Colors.purple, Colors.red, Colors.teal, Colors.amber];
    return colors[workspaceName.hashCode % colors.length];
  }
}

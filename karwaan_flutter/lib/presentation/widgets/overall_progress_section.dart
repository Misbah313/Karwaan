import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:karwaan_flutter/domain/models/board/overall_analytic_states.dart';
import 'package:karwaan_flutter/presentation/cubits/board/overall_analytic_cubit.dart';
import 'package:karwaan_flutter/presentation/widgets/utils/stl_overall_progress_char.dart';

class OverallProgressSection extends StatefulWidget {
  const OverallProgressSection({super.key});

  @override
  State<OverallProgressSection> createState() => _OverallProgressSectionState();
}

class _OverallProgressSectionState extends State<OverallProgressSection> {
  @override
  void initState() {
    super.initState();
    // Load overall analytics when section initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OverallAnalyticsCubit>().getOverallAnalytics();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OverallAnalyticsCubit, OverallAnalyticStates>(
      builder: (context, state) {
        if (state is OverallAnalyticsLoading) {
          return Container(
            height: 200,
            alignment: Alignment.center,
            child: const CircularProgressIndicator(),
          );
        } else if (state is OverallAnalyticsLoaded) {
          return StlOverallProgressChar(analytics: state.analytics);
          // OverallProgressChart(analytics: state.analytics);
        } else if (state is OverallAnalyticError) {
          return Container(
            height: 120,
            alignment: Alignment.center,
            child: Text(
              'Failed to load analytics',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.red,
                  ),
            ),
          );
        } else {
          return Container(
            height: 120,
            alignment: Alignment.center,
            child: Text(
              'Loading analytics...',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          );
        }
      },
    );
  }
}
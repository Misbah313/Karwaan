import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:karwaan_flutter/core/utils/search_function/search_cubit.dart';
import 'package:karwaan_flutter/core/utils/search_function/search_use_case.dart';
import 'package:karwaan_flutter/domain/repository/board/board_repo.dart';
import 'package:karwaan_flutter/domain/repository/boardcard/boardcard_repo.dart';
import 'package:karwaan_flutter/domain/repository/workspace/workspace_repo.dart';
import 'package:karwaan_flutter/presentation/cubits/board/board_analytics_cubit.dart';
import 'package:karwaan_flutter/presentation/cubits/board/overall_analytic_cubit.dart';
import 'package:karwaan_flutter/presentation/cubits/board/recent_board_cubit.dart';
import 'package:karwaan_flutter/presentation/cubits/workspace/workspace_cubit.dart';
import 'package:karwaan_flutter/presentation/cubits/workspace/workspace_member_cubit.dart';

class AppDependencies extends StatelessWidget {
  final Widget child;

  const AppDependencies({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Search
        BlocProvider(
          create: (context) => SearchCubit(
            SearchUseCase(
              boardRepo: context.read<BoardRepo>(),
              boardcardRepo: context.read<BoardcardRepo>(),
            ),
          ),
        ),
        
        // Workspace
        BlocProvider(
          create: (context) => WorkspaceCubit(
            context.read<WorkspaceRepo>(),
          ),
        ),
        BlocProvider(
          create: (context) => WorkspaceMemberCubit(
            context.read<WorkspaceRepo>(),
          ),
        ),
        
        // Analytics
        BlocProvider(
          create: (context) => OverallAnalyticsCubit(
            context.read<BoardRepo>(),
          ),
        ),
        BlocProvider(
          create: (context) => BoardAnalyticsCubit(
            context.read<BoardRepo>(),
          ),
        ),
        BlocProvider(
          create: (context) => RecentBoardCubit(
            context.read<BoardRepo>(),
          ),
        ),
      ],
      child: child,
    );
  }
}
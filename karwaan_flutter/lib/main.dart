// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:karwaan_flutter/core/services/auth_token_storage_helper.dart';
import 'package:karwaan_flutter/core/services/serverpod_client_service.dart';
import 'package:karwaan_flutter/data/repositories/auth/auth_remote_repo.dart';
import 'package:karwaan_flutter/data/repositories/board/board_remote_repo.dart';
import 'package:karwaan_flutter/data/repositories/boardcard/board_card_remote_repo.dart';
import 'package:karwaan_flutter/data/repositories/boardlist/boardlist_remote_repo.dart';
import 'package:karwaan_flutter/data/repositories/workspace/workspace_remote_repo.dart';
import 'package:karwaan_flutter/domain/repository/auth/auth_repo.dart';
import 'package:karwaan_flutter/domain/repository/board/board_repo.dart';
import 'package:karwaan_flutter/domain/repository/boardcard/boardcard_repo.dart';
import 'package:karwaan_flutter/domain/repository/boardlist/boardlist_repo.dart';
import 'package:karwaan_flutter/domain/repository/workspace/workspace_repo.dart';
import 'package:karwaan_flutter/presentation/cubits/auth/auth_cubit.dart';
import 'package:karwaan_flutter/presentation/cubits/auth/auth_gate.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();


  final serverpodClientService =
      ServerpodClientService(AuthTokenStorageHelper());
  await serverpodClientService.initialize();
  final authRepo = AuthRemoteRepo(serverpodClientService);
  final workspaceRepo = WorkspaceRemoteRepo(serverpodClientService);
  final boardRepo = BoardRemoteRepo(serverpodClientService);
  final boardlistRepo = BoardlistRemoteRepo(serverpodClientService);
  final boardcardRepo = BoardCardRemoteRepo(serverpodClientService);

  runApp(
    MultiProvider(
      providers: [
        Provider<AuthRepo>(create: (_) => authRepo), // Global AuthRepo
        Provider<WorkspaceRepo>(create: (_) => workspaceRepo),
        Provider<BoardRepo>(create: (_) => boardRepo),
        Provider<BoardlistRepo>(create: (_) => boardlistRepo),
        Provider<BoardcardRepo>(create: (_) => boardcardRepo),
        BlocProvider<AuthCubit>(
          // Global AuthCubit
          create: (context) => AuthCubit(context.read<AuthRepo>())..checkAuth(),
        ),
      ],
      child: MyApp(
        authRepo: authRepo,
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final AuthRepo authRepo;
  const MyApp({super.key, required this.authRepo});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthGate(
        authRepo: authRepo,
      ),
    );
  }
}

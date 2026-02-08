import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:karwaan_flutter/core/services/client/app_theme_service.dart';
import 'package:karwaan_flutter/core/services/client/profile_image_service.dart';
import 'package:karwaan_flutter/core/services/client/serverpod_client_service.dart';
import 'package:karwaan_flutter/core/services/workspace/app_naviagation_service.dart';
import 'package:karwaan_flutter/core/services/workspace/logout_dialog_service.dart';
import 'package:karwaan_flutter/core/services/workspace/workspace_member/member_service.dart';
import 'package:karwaan_flutter/domain/repository/label/label_repo.dart';
import 'package:karwaan_flutter/presentation/cubits/board/board_member_cubit.dart';
import 'package:karwaan_flutter/presentation/cubits/board/board_preview_analytics_cubit.dart';
import 'package:karwaan_flutter/presentation/cubits/board/board_preview_cubit.dart';
import 'package:karwaan_flutter/presentation/cubits/label/label_cubit.dart';
import 'package:karwaan_flutter/presentation/cubits/main_layout_cubit.dart';
import 'package:karwaan_flutter/core/theme/theme_notifier.dart';
import 'package:karwaan_flutter/core/theme/theme_service.dart';
import 'package:karwaan_flutter/domain/models/auth/auth_user.dart';
import 'package:karwaan_flutter/domain/repository/board/board_repo.dart';
import 'package:karwaan_flutter/domain/repository/boardcard/boardcard_repo.dart';
import 'package:karwaan_flutter/presentation/cubits/auth/auth_cubit.dart';
import 'package:karwaan_flutter/presentation/cubits/auth/auth_state_check.dart';
import 'package:karwaan_flutter/presentation/cubits/board/board_cubit.dart';
import 'package:karwaan_flutter/presentation/cubits/board/overall_analytic_cubit.dart';
import 'package:karwaan_flutter/presentation/cubits/boardcard/board_card_cubit.dart';
import 'package:karwaan_flutter/presentation/cubits/workspace/workspace_context_cubit.dart';
import 'package:karwaan_flutter/presentation/pages/desktop/board/board_page_rightside_bar.dart';
import 'package:karwaan_flutter/presentation/widgets/layout/deskleft_side_bar.dart';
import 'package:karwaan_flutter/presentation/widgets/layout/deskmain_content_area.dart';
import 'package:karwaan_flutter/presentation/widgets/layout/deskright_side_bar.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class MainAppPage extends StatefulWidget {
  const MainAppPage({super.key});

  @override
  State<MainAppPage> createState() => _MainAppPageState();
}

class _MainAppPageState extends State<MainAppPage> {
  final PageController _mainContentController = PageController();
  // final PageController _sidebarController = PageController();

  late ProfileImageService _profileImageService;
  late AppThemeService _appThemeService;
  late LogoutDialogService _logoutDialogService;
  late AppNavigationService _appNavigationService;
  late BoardPreviewCubit _previewCubit;

  @override
  void initState() {
    super.initState();
    _previewCubit = BoardPreviewCubit();
    _initializeServices();
  }

  void _initializeServices() {
    final serverpodService = context.read<ServerpodClientService>();
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    final authCubit = context.read<AuthCubit>();

    _profileImageService =
        ProfileImageService(serverpodService: serverpodService);
    _appThemeService = AppThemeService(
      themeService: ThemeService(serverpodService),
      themeNotifier: themeNotifier,
    );
    _logoutDialogService = LogoutDialogServiceImpl(authCubit: authCubit);
    _appNavigationService = AppNavigationServiceImpl(
      mainContentController: _mainContentController,
      onMenuChange: _handleMenuChange,
      logoutDialogService: _logoutDialogService,
    );
  }

  void _handleMenuChange(String menuName) {
    context.read<MainLayoutCubit>().changeMenu(menuName);
  }

  @override
  void dispose() {
    _mainContentController.dispose();
    // _sidebarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthStateCheck>(
      buildWhen: (previous, current) {
        return current is AuthAuthenticated && previous is! AuthAuthenticated ||
            current is AuthLoading && previous is! AuthLoading ||
            current is AuthError && previous is! AuthError;
      },
      builder: (context, state) {
        if (state is AuthLoading) {
          return Center(child: Lottie.asset('asset/ani/load.json'));
        } else if (state is AuthAuthenticated) {
          return MultiBlocProvider(
            providers: [
              BlocProvider.value(value: _previewCubit),
              // auth & user
              BlocProvider(create: (_) => WorkspaceContextCubit(_previewCubit)),
              Provider<AppNavigationService>(
                create: (context) => _appNavigationService,
              ),

              // board features
              BlocProvider(
                create: (context) => BoardCubit(context.read<BoardRepo>()),
              ),

              BlocProvider(
                create: (context) =>
                    BoardMemberCubit(context.read<BoardRepo>()),
              ),

              BlocProvider(
                create: (context) => LabelCubit(context.read<LabelRepo>()),
              ),
              BlocProvider(
                  create: (_) =>
                      OverallAnalyticsCubit(context.read<BoardRepo>())),
              BlocProvider(
                create: (context) => BoardCardCubit(
                  context.read<BoardcardRepo>(),
                  context.read<OverallAnalyticsCubit>(),
                ),
              ),
              BlocProvider(
                create: (context) =>
                    BoardPreviewAnalyticsCubit(context.read<BoardRepo>()),
              )

              // other provider will be here
            ],
            child: _buildAuthenticatedLayout(state.user),
          );
        }

        return _buildErrorState();
      },
    );
  }

  Widget _buildAuthenticatedLayout(AuthUser user) {
    return BlocBuilder<MainLayoutCubit, MainLayoutState>(
      builder: (context, layoutState) {
        final currentMenu = layoutState.currentMenu;

        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: Row(
            children: [
              LeftSidebar(
                selectedMenu: currentMenu,
                navigationService: _appNavigationService,
              ),
              Expanded(
                child: MainContentArea(
                  controller: _mainContentController,
                  currentPageIndex: _getPageIndex(currentMenu),
                  user: user,
                ),
              ),
              _buildRightSidebar(user, currentMenu),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRightSidebar(AuthUser user, String currentMenu) {
    final sideBar = _getSideBarForPage(currentMenu, user);

    if (sideBar == null) {
      return const SizedBox.shrink();
    }

    return SizedBox(
        width: MediaQuery.of(context).size.width * 0.25, child: sideBar
        );
  }

  Widget? _getSideBarForPage(String pageName, AuthUser user) {
    switch (pageName) {
      case 'Dashboard':
        return DashboardRightSidebar(
          user: user,
          profileImageService: _profileImageService,
          navigationService: _appNavigationService,
          themeService: _appThemeService,
        );
      case 'Boards':
        return BoardPageRightsideBar(
          user: user,
          profileImageService: _profileImageService,
          navigationService: _appNavigationService,
          themeService: _appThemeService,
          memberService: MemberService(),
        );
      case 'Analysis':
        return null;
      case 'Teams':
        return _buildSimpleRightSidebar('Teams in person');
      case 'Settings':
        return _buildSimpleRightSidebar('Fast settings');
      default:
        return null;
    }
  }

  Widget _buildSimpleRightSidebar(String title) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(
          left: BorderSide(
            color: Colors.white.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: Center(
        child: Text(
          title,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }

  int _getPageIndex(String menuName) {
    switch (menuName) {
      case 'Dashboard':
        return 0;
      case 'Boards':
        return 1;
      case 'Analysis':
        return 2;
      case 'Teams':
        return 3;
      case 'Settings':
        return 4;
      default:
        return 0;
    }
  }

  Widget _buildErrorState() {
    return Center(
      child: Text(
        'Something went wrong...',
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }
}

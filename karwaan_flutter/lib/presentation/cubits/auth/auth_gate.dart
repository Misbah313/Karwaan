import 'dart:async';
import 'dart:ui';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:karwaan_flutter/core/managers/connectivity_manager.dart';
import 'package:karwaan_flutter/core/managers/dialog_state_manager.dart';
import 'package:karwaan_flutter/core/services/serverpod_client_service.dart';
import 'package:karwaan_flutter/core/theme/theme_notifier.dart';
import 'package:karwaan_flutter/core/theme/theme_service.dart';
import 'package:karwaan_flutter/core/utils/banner/banner_manager.dart';
import 'package:karwaan_flutter/core/utils/layout/home_wrapper.dart';
import 'package:karwaan_flutter/data/mappers/auth/error/exception_mapper.dart';
import 'package:karwaan_flutter/domain/repository/auth/auth_repo.dart';
import 'package:karwaan_flutter/domain/repository/workspace/workspace_repo.dart';
import 'package:karwaan_flutter/presentation/cubits/auth/auth_cubit.dart';
import 'package:karwaan_flutter/presentation/cubits/auth/auth_page.dart';
import 'package:karwaan_flutter/presentation/cubits/auth/auth_state_check.dart';
import 'package:karwaan_flutter/presentation/cubits/workspace/workspace_page.dart';
import 'package:karwaan_flutter/presentation/pages/desktop/auth/desk_on_auth_page.dart';
import 'package:karwaan_flutter/presentation/widgets/auth/account_deletion_dialog.dart';
import 'package:karwaan_flutter/presentation/widgets/auth/auth_loading_screen.dart';
import 'package:karwaan_flutter/presentation/widgets/auth/connection_state_banner.dart';
import 'package:karwaan_flutter/presentation/widgets/auth/registeration_success_dialog.dart';
import 'package:karwaan_flutter/presentation/widgets/builders/mobile_content_builder.dart';

class AuthGate extends StatefulWidget {
  final AuthRepo authRepo;
  const AuthGate({super.key, required this.authRepo});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  // Managers
  final ConnectivityManager _connectivityManager = ConnectivityManager();
  final DialogStateManager _dialogStateManager = DialogStateManager();

  // State
  Timer? _minimumLoadTimer;
  bool _minimumLoadCompleted = false;
  bool _showBanner = false;
  bool _shouldShowLoginView = false;
  bool _shouldShowRegisterView = false;

  // Add this for direct connectivity listening
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  bool get _isDesktop => MediaQuery.of(context).size.width >= 800;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    await _connectivityManager.initialize();
    _startMinimumLoadTimer();

    // Listen to connectivity changes directly
    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> results) {
      _handleConnectivityChange();
    });
  }

  void _startMinimumLoadTimer() {
    _minimumLoadCompleted = false;
    _minimumLoadTimer?.cancel();
    _minimumLoadTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) setState(() => _minimumLoadCompleted = true);
    });
  }

  void _handleConnectivityChange() {
    if (!mounted) return;

    setState(() => _showBanner = true);

    Timer(const Duration(seconds: 3), () {
      if (!mounted) return;
      setState(() => _showBanner = false);
    });
  }

  void _handleStateChange(AuthStateCheck state) {
    if (state is RegisterationSuccess) {
      // Only show desktop dialogs for desktop
      if (_isDesktop) {
        _dialogStateManager.showRegistrationSuccess();
      }
    } else if (state is DeleteSuccessfully) {
      // Only show desktop dialogs for desktop
      if (_isDesktop) {
        _dialogStateManager.showAccountDeleted();
      }
    }
  }

  Future<void> _loadUserTheme(int userId) async {
    try {
      final themeService = ThemeService(context.read<ServerpodClientService>());
      final savedTheme = await themeService.loadUserTheme(userId);
      if (!mounted) return;
      context
          .read<ThemeNotifier>()
          .setThemeMode(savedTheme ? ThemeMode.dark : ThemeMode.light);
    } catch (e) {
      final message = ExceptionMapper.toMessage(e);
      context.read<BannerManager>().show(message);
    }
  }

  Widget _buildMainContent(AuthStateCheck state) {
    final AuthView initialView = _getInitialView();

    if (state is AuthAuthenticated) {
      return WorkspacePage(
        workspaceRepo: context.read<WorkspaceRepo>(),
        child: const HomeWrapper(),
      );
    }

    // MOBILE: Use mobile-specific full-screen pages for special states
    if (!_isDesktop) {
      final bool showLoading = state is AuthLoading && !_minimumLoadCompleted;
      final bool showContent = !showLoading;

      // For mobile, use MobileContentBuilder for special states, but for AuthUnAuthenticated, use AuthPage
      if (state is RegisterationSuccess ||
          state is AuthError ||
          state is DeleteSuccessfully) {
        return MobileContentBuilder.buildContent(
          context: context,
          state: state,
          authRepo: widget.authRepo,
          showLoading: showLoading,
          showContent: showContent,
        );
      }

      // For AuthUnAuthenticated on mobile, use AuthPage (which uses AuthWrapper)
      return AuthPage(authRepo: widget.authRepo);
    }

    // DESKTOP: Use existing desktop logic (overlay approach)
    return DeskOnAuthPage(initialView: initialView);
  }

  AuthView _getInitialView() {
    if (_shouldShowLoginView) return AuthView.login;
    if (_shouldShowRegisterView) return AuthView.register;
    return AuthView.intro;
  }

  Widget _buildBlurBackground({required Widget child}) {
    // Only apply blur for desktop dialogs
    if (!_isDesktop ||
        (!_dialogStateManager.showRegistrationDialog &&
            !_dialogStateManager.showAccountDeletedDialog)) {
      return child;
    }

    return Stack(
      children: [
        child,
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(color: Colors.blue.withValues(alpha: 0.1)),
          ),
        ),
      ],
    );
  }

  void _handleRegistrationContinue() {
    setState(() {
      _dialogStateManager.hideAllDialogs();
      _shouldShowLoginView = true;
      _shouldShowRegisterView = false;
    });
    context.read<AuthCubit>().resetToUnAuthenticated();
  }

  void _handleCreateNewAccount() {
    setState(() {
      _dialogStateManager.hideAllDialogs();
      _shouldShowRegisterView = true;
      _shouldShowLoginView = false;
    });
    context.read<AuthCubit>().resetToUnAuthenticated();
  }

  void _handleCloseDialog() {
    setState(() => _dialogStateManager.hideAllDialogs());
    context.read<AuthCubit>().resetToUnAuthenticated();
  }

  @override
  void dispose() {
    _minimumLoadTimer?.cancel();
    _connectivityManager.dispose();
    _connectivitySubscription.cancel(); // Don't forget this!
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthStateCheck>(
      listener: (context, state) {
        _handleStateChange(state);

        if (state is AuthLoading) {
          _startMinimumLoadTimer();
        }

        if (state is AuthAuthenticated) _loadUserTheme(state.user.id);

        if (state is AuthError) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;
            context.read<BannerManager>().show(state.errormessage);
          });
        }
      },
      child: BlocBuilder<AuthCubit, AuthStateCheck>(
        builder: (context, state) {
          final bool showLoading = state is AuthLoading &&
              !_minimumLoadCompleted &&
              state is! AuthError;

          return Stack(
            children: [
              // Main content
              _buildBlurBackground(
                child: _buildMainContent(state),
              ),

              // Loading overlay (only for desktop - mobile handles loading in its content)
              if (showLoading && _isDesktop) const AuthLoadingScreen(),

              // Connection banner
              Positioned(
                top: 20,
                left: 0,
                right: 0,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: ConnectionStateBanner(
                    isConnected: _connectivityManager.isConnected,
                    lastResult: _connectivityManager.lastResult,
                    showBanner: _showBanner,
                  ),
                ),
              ),

              // Desktop-only dialogs
              if (_isDesktop) ...[
                if (_dialogStateManager.showRegistrationDialog)
                  RegistrationSuccessDialog(
                    onContinue: _handleRegistrationContinue,
                  ),
                if (_dialogStateManager.showAccountDeletedDialog)
                  AccountDeletedDialog(
                    onCreateNewAccount: _handleCreateNewAccount,
                    onClose: _handleCloseDialog,
                  ),
              ],
            ],
          );
        },
      ),
    );
  }
}

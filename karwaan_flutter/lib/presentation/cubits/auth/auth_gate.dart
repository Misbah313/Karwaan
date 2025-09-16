import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:karwaan_flutter/core/services/serverpod_client_service.dart';
import 'package:karwaan_flutter/core/theme/theme_notifier.dart';
import 'package:karwaan_flutter/core/theme/theme_service.dart';
import 'package:karwaan_flutter/core/utils/layout/home_wrapper.dart';
import 'package:karwaan_flutter/domain/repository/auth/auth_repo.dart';
import 'package:karwaan_flutter/domain/repository/workspace/workspace_repo.dart';
import 'package:karwaan_flutter/presentation/cubits/auth/auth_cubit.dart';
import 'package:karwaan_flutter/presentation/cubits/auth/auth_page.dart';
import 'package:karwaan_flutter/presentation/cubits/auth/auth_state_check.dart';
import 'package:karwaan_flutter/presentation/cubits/workspace/workspace_page.dart';
import 'package:karwaan_flutter/presentation/pages/desktop/auth/desk_on_auth_page.dart';
import 'package:lottie/lottie.dart';

class AuthGate extends StatefulWidget {
  final AuthRepo authRepo;
  const AuthGate({super.key, required this.authRepo});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  Timer? _minimumLoadTimer;
  bool _minimumLoadCompleted = false;
  bool _isConnected = true;
  ConnectivityResult _lastResult = ConnectivityResult.none;
  bool showBanner = false;
  bool _showDialog = false;

  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  void _updateConnectionState(bool isConnected) {
    setState(() {
      showBanner = true;
    });

    // hide the banner after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          showBanner = false;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _initConnectivity();
    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> results) {
      if (mounted) {
        final newIsConnected = results.isNotEmpty &&
            results.any((result) => result != ConnectivityResult.none);

        // save last known connection type
        final newLastResult = newIsConnected
            ? results.firstWhere(
                (r) => r != ConnectivityResult.none,
                orElse: () => ConnectivityResult.none,
              )
            : ConnectivityResult.none;

        setState(() {
          _isConnected = newIsConnected;
          _lastResult = newLastResult;
        });

        // 🔥 trigger banner show/hide for 3 seconds
        _updateConnectionState(newIsConnected);
      }
    });
  }

  Future<void> _initConnectivity() async {
    final results = await Connectivity().checkConnectivity();
    if (mounted) {
      setState(() {
        _isConnected = results.isNotEmpty &&
            results.any((result) => result != ConnectivityResult.none);

        _lastResult = _isConnected
            ? results.firstWhere(
                (r) => r != ConnectivityResult.none,
                orElse: () => ConnectivityResult.none,
              )
            : ConnectivityResult.none;
      });
    }
  }

  @override
  void dispose() {
    _minimumLoadTimer?.cancel();
    _connectivitySubscription.cancel();
    super.dispose();
  }

  void _startMinimumLoadTimer() {
    _minimumLoadCompleted = false;
    _minimumLoadTimer?.cancel();
    _minimumLoadTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() => _minimumLoadCompleted = true);
      }
    });
  }

  void _handleStateChange(AuthStateCheck state) {
    debugPrint('Current state: ${state.runtimeType}');

    // Cancel any existing timer
    _minimumLoadTimer?.cancel();

    if (state is AuthLoading) {
      if (!_minimumLoadCompleted) {
        _startMinimumLoadTimer();
      }
    } else {
      // For all other states, immediately show content
      if (!_minimumLoadCompleted ||
          state is AuthAuthenticated ||
          state is RegisterationSuccess) {
        if (mounted) {
          setState(() => _minimumLoadCompleted = true);
        }
      }
    }

    // Show dialogs for desktop for specific states
    if (_isDesktop(context)) {
      if (state is RegisterationSuccess && !_showDialog) {
        _showDialog = true;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _showRegistrationSuccessDialog();
        });
      } else if (state is AuthError && !_showDialog) {
        _showDialog = true;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _showErrorDialog(state.errormessage);
        });
      } else if (state is DeleteSuccessfully && !_showDialog) {
        _showDialog = true;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _showAccountDeletedDialog();
        });
      } else if (state is AuthUnAuthenticated) {
        _showDialog = false;
      }
    }
  }

  IconData _getIconForConnection(ConnectivityResult result) {
    switch (result) {
      case ConnectivityResult.wifi:
        return Icons.wifi;
      case ConnectivityResult.mobile:
        return Icons.network_cell;
      case ConnectivityResult.ethernet:
        return Icons.settings_ethernet;
      default:
        return Icons.wifi_off;
    }
  }

  Widget _buildConnectionStateBanner(bool isConnected) {
    return Positioned(
      top: 20,
      left: 10,
      right: 10,
      child: AnimatedOpacity(
        opacity: showBanner ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 300),
        child: Container(
          height: 40,
          decoration: BoxDecoration(
            color: isConnected ? Colors.green : Colors.redAccent,
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isConnected
                    ? _getIconForConnection(_lastResult)
                    : Icons.wifi_off,
                color: Colors.white,
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= 800;
  }

  void _showErrorDialog(String errorMessage) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return _buildErrorDialog(errorMessage);
      },
    );
  }

  void _showRegistrationSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return _buildRegistrationSuccessDialog();
      },
    );
  }

  void _showAccountDeletedDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return _buildAccountDeletedDialog();
      },
    );
  }

  Widget _buildErrorDialog(String errorMessage) {
    return Dialog(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      insetPadding: const EdgeInsets.all(40),
      child: Container(
        width: 500,
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset(
              'asset/ani/error.json',
              width: 120,
              height: 120,
              repeat: false,
            ),
            const SizedBox(height: 24),
            Text(
              'Oops! Something went wrong',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              errorMessage,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    context.read<AuthCubit>().checkAuth();
                  },
                  child: Text(
                    'Try Again',
                    style: Theme.of(context).textTheme.bodyMedium
                  ),
                ),
                const SizedBox(width: 16),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    context.read<AuthCubit>().resetToUnAuthenticated();
                  },
                  child: Text(
                    'Go Back',
                    style: Theme.of(context).textTheme.bodyMedium
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRegistrationSuccessDialog() {
    return Dialog(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      insetPadding: const EdgeInsets.all(40),
      child: Container(
        width: 500,
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.blueGrey.withOpacity(0.2),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset(
              'asset/ani/registered.json',
              width: MediaQuery.of(context).size.width * 0.3,
              height: MediaQuery.of(context).size.height * 0.2,
              repeat: false,
            ),
            const SizedBox(height: 24),
            Text(
              'Welcome Aboard! 🎉',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Your account has been successfully created.\nPlease login with your credentials to continue.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  context.read<AuthCubit>().resetToUnAuthenticated();
                },
                child: Text(
                  'Continue to Login',
                  style: Theme.of(context).textTheme.bodySmall
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountDeletedDialog() {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(40),
      child: Container(
        width: 500,
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset(
              'asset/ani/deleted.json',
              width: 120,
              height: 120,
              repeat: false,
            ),
            const SizedBox(height: 24),
            Text(
              'Account Deleted',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Your account has been successfully deleted.\nWe\'re sorry to see you go.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    context.read<AuthCubit>().resetToUnAuthenticated();
                  },
                  child: Text(
                    'Create New Account',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
                const SizedBox(width: 16),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Close',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingScreen() {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'asset/ani/dataSecure.json',
              width: 300,
              height: 300,
            ),
            const SizedBox(height: 20),
            Text('Securing your session...',
                style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }

  Future<void> _loadUserTheme(int userId) async {
    try {
      final themeService = ThemeService(context.read<ServerpodClientService>());
      final savedTheme = await themeService.loadUserTheme(userId);

      final themeNotifier = context.read<ThemeNotifier>();
      themeNotifier.setThemeMode(savedTheme ? ThemeMode.dark : ThemeMode.light);
    } catch (e) {
      debugPrint('Failed to load user theme: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthStateCheck>(
      listener: (context, state) {
        _handleStateChange(state);

        if (state is AuthAuthenticated) {
          _loadUserTheme(state.user.id);
        }
      },
      child: BlocBuilder<AuthCubit, AuthStateCheck>(
        builder: (context, state) {
          final showLoading = state is AuthLoading && !_minimumLoadCompleted;
          final showContent = !showLoading;

          return Stack(
            children: [
              if (showLoading) _buildLoadingScreen(),
              if (showContent) ...[
                if (state is AuthAuthenticated)
                  WorkspacePage(
                      workspaceRepo: context.read<WorkspaceRepo>(),
                      child: const HomeWrapper()),
                if (state is AuthUnAuthenticated)
                  _isDesktop(context)
                      ? const DeskOnAuthPage()
                      : AuthPage(authRepo: widget.authRepo),
              ],
              _buildConnectionStateBanner(_isConnected),
            ],
          );
        },
      ),
    );
  }
}
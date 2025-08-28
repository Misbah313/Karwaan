import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:karwaan_flutter/domain/repository/auth/auth_repo.dart';
import 'package:karwaan_flutter/domain/repository/workspace/workspace_repo.dart';
import 'package:karwaan_flutter/presentation/cubits/auth/auth_cubit.dart';
import 'package:karwaan_flutter/presentation/cubits/auth/auth_page.dart';
import 'package:karwaan_flutter/presentation/cubits/auth/auth_state_check.dart';
import 'package:karwaan_flutter/presentation/cubits/workspace/workspace_page.dart';
import 'package:karwaan_flutter/presentation/pages/mobile/auth/login_page.dart';
import 'package:karwaan_flutter/presentation/pages/mobile/workspace/home_page.dart';
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
      // Reduced to 2 seconds for better UX
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

  Widget _buildErrorScreen({
    required String title,
    required String message,
    required String asset,
    String? actionText,
    VoidCallback? action,
    bool showLoading = false,
  }) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.asset(asset, width: 180, height: 180, repeat: false),
                    const SizedBox(height: 24),
                    Text(title, style: Theme.of(context).textTheme.bodyLarge),
                    const SizedBox(height: 12),
                    Text(message,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(height: 32),
                    if (actionText != null && action != null)
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            minimumSize: const Size(200, 50),
                            padding: const EdgeInsets.symmetric(horizontal: 32),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            backgroundColor:
                                Theme.of(context).colorScheme.primary),
                        onPressed: action,
                        child: Text(actionText,
                            style: Theme.of(context).textTheme.bodySmall),
                      ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          PageRouteBuilder(
                            transitionDuration:
                                const Duration(milliseconds: 600),
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    HomePage(),
                            transitionsBuilder: (
                              context,
                              animation,
                              secondaryAnimation,
                              child,
                            ) {
                              const begin = Offset(0.0, 1.0);
                              const end = Offset.zero;
                              const curve = Curves.easeOut;

                              final tween = Tween(
                                begin: begin,
                                end: end,
                              ).chain(CurveTween(curve: curve));
                              final offsetAnimation = animation.drive(tween);

                              return SlideTransition(
                                position: offsetAnimation,
                                child: child,
                              );
                            },
                          ),
                        );
                      },
                      child: Text('Return to Login',
                          style: Theme.of(context).textTheme.bodySmall),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (showLoading && !_minimumLoadCompleted)
          const Center(
            child: CircularProgressIndicator.adaptive(),
          ),
      ],
    );
  }

  Widget _buildRegistrationSuccessScreen() {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(
                  'asset/ani/registered.json',
                  width: 250,
                  height: 250,
                  repeat: false,
                ),
                const SizedBox(height: 32),
                Text('Welcome Aboard!',
                    style: Theme.of(context).textTheme.bodyLarge),
                const SizedBox(height: 16),
                Text(
                    'Your account has been successfully created.\nPlease Login with your credentials.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        PageRouteBuilder(
                          transitionDuration: const Duration(milliseconds: 600),
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  const LoginPage(),
                          transitionsBuilder: (
                            context,
                            animation,
                            secondaryAnimation,
                            child,
                          ) {
                            const begin = Offset(0.0, 1.0);
                            const end = Offset.zero;
                            const curve = Curves.easeOut;

                            final tween = Tween(
                              begin: begin,
                              end: end,
                            ).chain(CurveTween(curve: curve));
                            final offsetAnimation = animation.drive(tween);

                            return SlideTransition(
                              position: offsetAnimation,
                              child: child,
                            );
                          },
                        ),
                      );
                    },
                    child: Text('Continue to Login',
                        style: Theme.of(context).textTheme.bodyMedium),
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AuthPage(authRepo: widget.authRepo),
                    ),
                  ),
                  child: Text('Back to Home',
                      style: Theme.of(context).textTheme.bodySmall),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAccountDeletedScreen() {
    return _buildErrorScreen(
      title: 'Account Deleted',
      message: 'Your account has been successfully deleted.',
      asset: 'asset/ani/deleted.json',
      actionText: 'Create New Account',
      action: () {
        context.read<AuthCubit>().resetToUnAuthenticated();
      },
      showLoading: false,
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

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthStateCheck>(
      listener: (context, state) {
        _handleStateChange(state);
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
                      child: const HomePage()),
                if (state is RegisterationSuccess)
                  _buildRegistrationSuccessScreen(),
                if (state is AuthError)
                  _buildErrorScreen(
                    title: 'Error',
                    message: state.errormessage,
                    asset: 'asset/ani/error.json',
                    actionText: 'Retry',
                    action: () => context.read<AuthCubit>().checkAuth(),
                  ),
                if (state is DeleteSuccessfully) _buildAccountDeletedScreen(),
                if (state is AuthUnAuthenticated)
                  AuthPage(authRepo: widget.authRepo),
              ],
              _buildConnectionStateBanner(_isConnected),
            ],
          );
        },
      ),
    );
  }
}

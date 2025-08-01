import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karwaan_flutter/domain/repository/auth/auth_repo.dart';
import 'package:karwaan_flutter/presentation/cubits/auth/auth_cubit.dart';
import 'package:karwaan_flutter/presentation/cubits/auth/auth_page.dart';
import 'package:karwaan_flutter/presentation/cubits/auth_state_check.dart';
import 'package:karwaan_flutter/presentation/pages/mobile/home_mobile.dart';
import 'package:karwaan_flutter/presentation/pages/mobile/login_page.dart';
import 'package:karwaan_flutter/presentation/widgets/utils/constant.dart';
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
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  bool _isConnected = true;

  @override
  void initState() {
    super.initState();
    _initConnectivity();
    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> results) {
      if (mounted) {
        setState(() {
          _isConnected = results.isNotEmpty &&
              results.any((result) => result != ConnectivityResult.none);
        });
      }
    });
  }

  @override
  void dispose() {
    _minimumLoadTimer?.cancel();
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> _initConnectivity() async {
    final List<ConnectivityResult> results =
        await Connectivity().checkConnectivity();
    if (mounted) {
      setState(() {
        _isConnected = results.isNotEmpty &&
            results.any((result) => result != ConnectivityResult.none);
      });
    }
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

  Widget _buildConnectionStateBanner(bool isConnected) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: isConnected ? 0 : 40,
        color: Colors.redAccent,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            const Icon(Icons.wifi_off, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                isConnected ? 'Back online' : 'No internet connection',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorScreen({
    required String title,
    required String message,
    String? actionText,
    VoidCallback? action,
    bool showLoading = false,
  }) {
    return Stack(
      children: [
        Scaffold(
          body: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.asset(
                      'asset/ani/error.json',
                      width: 180,
                      height: 180,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      title,
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: Theme.of(context).colorScheme.error,
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      message,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 32),
                    if (actionText != null && action != null)
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(200, 50),
                          padding: const EdgeInsets.symmetric(horizontal: 32),
                        ),
                        onPressed: action,
                        child: Text(actionText),
                      ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AuthPage(authRepo: widget.authRepo),
                        ),
                      ),
                      child: const Text('Return to Login'),
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
      backgroundColor:
          myDeafultBackgroundColor, 
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(
                  'asset/ani/success.json', 
                  width: 250,
                  height: 250,
                  repeat: false,
                ),
                const SizedBox(height: 32),
                Text(
                  'Welcome Aboard!',
                  style: GoogleFonts.poppins(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade800,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Your account has been successfully created.\nPlease Login with your credentials.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade600,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => LoginPage(),
                      ),
                    ),
                    child: Text(
                      'Continue to Login',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
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
                  child: Text(
                    'Back to Home',
                    style: GoogleFonts.poppins(
                      color: Colors.blue.shade600,
                    ),
                  ),
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
      message: 'Your account has been successfully removed',
      actionText: 'Create New Account',
      action: () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => AuthPage(authRepo: widget.authRepo)),
      ),
      showLoading: false,
    );
  }

  Widget _buildLoadingScreen() {
    return Scaffold(
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
            Text(
              'Securing your session...',
              style: Theme.of(context).textTheme.titleMedium,
            ),
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
                if (state is AuthAuthenticated) const HomeMobile(),
                if (state is RegisterationSuccess)
                  _buildRegistrationSuccessScreen(),
                if (state is AuthError)
                  _buildErrorScreen(
                    title: 'Error',
                    message: state.errormessage,
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

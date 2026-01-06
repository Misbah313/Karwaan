import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:karwaan_flutter/core/utils/banner/banner_manager.dart';
import 'package:karwaan_flutter/data/mappers/auth/error/exception_mapper.dart';
import 'package:karwaan_flutter/domain/models/auth/auth_credentials.dart';
import 'package:karwaan_flutter/domain/repository/auth/auth_repo.dart';
import 'package:karwaan_flutter/presentation/cubits/auth/auth_cubit.dart';
import 'package:karwaan_flutter/presentation/cubits/auth/auth_gate.dart';
import 'package:karwaan_flutter/presentation/pages/desktop/auth/intro_content.dart';
import 'package:karwaan_flutter/presentation/pages/desktop/auth/login_content.dart';
import 'package:karwaan_flutter/presentation/pages/desktop/auth/register_content.dart';
import 'package:video_player/video_player.dart';

class DeskOnAuthPage extends StatefulWidget {
  final AuthView initialView;
  const DeskOnAuthPage({super.key, this.initialView = AuthView.intro});

  @override
  State<DeskOnAuthPage> createState() => _DeskOnAuthPageState();
}

class _DeskOnAuthPageState extends State<DeskOnAuthPage>
    with SingleTickerProviderStateMixin {
  late VideoPlayerController _controller;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  bool _isVideoInitialized = false;
  AuthView _currentView = AuthView.intro;

  final emailController = TextEditingController();
  final pwController = TextEditingController();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool isProcessing = false;
  bool isGoogleAuthDialogOpen = false;

  @override
  void initState() {
    super.initState();
    _currentView = widget.initialView;

    _controller = VideoPlayerController.asset("asset/video/background.mp4")
      ..initialize().then((_) {
        _controller.setVolume(0);
        _controller.play();
        setState(() => _isVideoInitialized = true);
      });

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _fadeAnimation =
        Tween<double>(begin: 1.0, end: 0.0).animate(_fadeController);

    _controller.addListener(() {
      if (_controller.value.isInitialized &&
          _controller.value.position >=
              _controller.value.duration - const Duration(milliseconds: 200)) {
        _fadeController.forward().then((_) async {
          await _controller.seekTo(Duration.zero);
          _fadeController.reverse();
          _controller.play();
        });
      }
    });

    _controller.setLooping(false);
  }

  @override
  void dispose() {
    _controller.dispose();
    _fadeController.dispose();
    emailController.dispose();
    pwController.dispose();
    nameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!mounted) return const Scaffold(body: SizedBox.shrink());
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Background video
          if (_isVideoInitialized)
            SizedBox.expand(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: _controller.value.size.width,
                    height: _controller.value.size.height,
                    child: VideoPlayer(_controller),
                  ),
                ),
              ),
            ),

          // Gradient overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  colors.surface.withOpacity(0.25),
                  colors.surface.withOpacity(0.7)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // Main content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.9,
                        width: MediaQuery.of(context).size.width * 0.28,
                        decoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: Theme.of(context).dividerColor,
                            width: 1.2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.25),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 800),
                          switchInCurve: Curves.easeInOut,
                          switchOutCurve: Curves.easeInOut,
                          transitionBuilder: (child, animation) {
                            return FadeTransition(
                              opacity: animation,
                              child: SizeTransition(
                                sizeFactor: animation,
                                axis: Axis.horizontal,
                                axisAlignment: -1,
                                child: child,
                              ),
                            );
                          },
                          child: _buildCurrentView(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Blur effect when Google dialog is open
          if (isGoogleAuthDialogOpen)
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
              child: Container(
                color: Colors.black.withOpacity(0.2),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCurrentView() {
    switch (_currentView) {
      case AuthView.intro:
        return IntroContent(
          key: const ValueKey('intro'),
          onTapToContinue: () {
            setState(() => _currentView = AuthView.login);
          },
          colors: Theme.of(context).colorScheme,
        );
      case AuthView.login:
        return DeskLoginPageContent(
          key: const ValueKey('login'),
          emailController: emailController,
          pwController: pwController,
          isProcessing: isProcessing,
          onLoginPressed: _handleLogin,
          onGooglePressed: _handleGoogleSignIn,
          onBackPressed: () => setState(() => _currentView = AuthView.intro),
          onRegisterPressed: () =>
              setState(() => _currentView = AuthView.register),
        );
      case AuthView.register:
        return DeskRegisterPageContent(
          key: const ValueKey('register'),
          nameController: nameController,
          emailController: emailController,
          passwordController: passwordController,
          confirmPasswordController: confirmPasswordController,
          isProcessing: isProcessing,
          onRegisterPressed: _handleRegistration,
          onGooglePressed: _handleGoogleSignIn,
          onBackPressed: () => setState(() => _currentView = AuthView.login),
          onLoginPressed: () => setState(() => _currentView = AuthView.login),
        );
    }
  }

  void _handleLogin() async {
    FocusScope.of(context).unfocus();

    if (emailController.text.isEmpty || pwController.text.isEmpty) {
      context.read<BannerManager>().show('Please fill in all fields');
      return;
    }

    setState(() => isProcessing = true);
    try {
      final authCubit = context.read<AuthCubit>();
      final authRepo = context.read<AuthRepo>();

      final credentials = AuthCredential(
        email: emailController.text.trim(),
        password: pwController.text.trim(),
      );

      await authCubit.login(credentials);

      await Future.delayed(const Duration(milliseconds: 300));

      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (_) => BlocProvider.value(
              value: authCubit,
              child: AuthGate(authRepo: authRepo),
            ),
          ),
          (route) => false,
        );
      }
    } catch (e) {
      final userFriendlyMessage = ExceptionMapper.toMessage(e);
      context.read<BannerManager>().show(userFriendlyMessage);
    } finally {
      if (mounted) setState(() => isProcessing = false);
    }
  }

  void _handleRegistration() async {
    FocusScope.of(context).unfocus();

    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      context.read<BannerManager>().show('Please fill in all fields');
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      context.read<BannerManager>().show('Passwords do not match');
      return;
    }

    setState(() => isProcessing = true);
    try {
      final authCubit = context.read<AuthCubit>();
      final authRepo = context.read<AuthRepo>();

      final credentials = AuthCredential(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      await authCubit.register(credentials, nameController.text.trim());

      await Future.delayed(const Duration(milliseconds: 300));

      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (_) => BlocProvider.value(
              value: authCubit,
              child: AuthGate(authRepo: authRepo),
            ),
          ),
          (route) => false,
        );
      }
    } catch (e) {
      final userFriendlyMessage = ExceptionMapper.toMessage(e);
      context.read<BannerManager>().show(userFriendlyMessage);
    } finally {
      if (mounted) setState(() => isProcessing = false);
    }
  }

  void _handleGoogleSignIn() async {
    if (!mounted) return;

    setState(() {
      isGoogleAuthDialogOpen = true;
      isProcessing = true;
    });

    try {
      final authCubit = context.read<AuthCubit>();
      await Future.delayed(const Duration(milliseconds: 100));
      await authCubit.googleAuth();

      await Future.delayed(const Duration(milliseconds: 300));

      if (mounted) {
        final authRepo = context.read<AuthRepo>();
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (_) => BlocProvider.value(
              value: authCubit,
              child: AuthGate(authRepo: authRepo),
            ),
          ),
          (route) => false,
        );
      }
    } catch (e) {
      final errorMessage = e.toString().toLowerCase();
      final isUserCancelled = errorMessage.contains('aborted') ||
          errorMessage.contains('cancelled') ||
          errorMessage.contains('null');

      if (mounted && !isUserCancelled) {
        final message = ExceptionMapper.toMessage(e);
        context.read<BannerManager>().show(message);
      }
    } finally {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          setState(() {
            isGoogleAuthDialogOpen = false;
            isProcessing = false;
          });
        }
      });
    }
  }
}

enum AuthView { intro, login, register }

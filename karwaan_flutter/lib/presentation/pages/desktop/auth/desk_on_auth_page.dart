import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karwaan_flutter/data/mappers/auth/error/exception_mapper.dart';
import 'package:karwaan_flutter/domain/models/auth/auth_credentials.dart';
import 'package:karwaan_flutter/domain/repository/auth/auth_repo.dart';
import 'package:karwaan_flutter/presentation/cubits/auth/auth_cubit.dart';
import 'package:karwaan_flutter/presentation/cubits/auth/auth_gate.dart';
import 'package:karwaan_flutter/presentation/widgets/utils/button.dart';
import 'package:karwaan_flutter/presentation/widgets/utils/constant.dart';
import 'package:karwaan_flutter/presentation/widgets/utils/textfield.dart';
import 'package:lottie/lottie.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:video_player/video_player.dart';

class DeskOnAuthPage extends StatefulWidget {
  const DeskOnAuthPage({super.key});

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

  @override
  void initState() {
    super.initState();

    // video controller
    _controller = VideoPlayerController.asset("asset/video/background.mp4")
      ..initialize().then((_) {
        _controller.setVolume(0);
        _controller.play();
        setState(() => _isVideoInitialized = true);
      });

    // fade animation controller
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _fadeAnimation =
        Tween<double>(begin: 1.0, end: 0.0).animate(_fadeController);

    // smooth loop logic
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
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          /// Background video with fade
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

          /// subtle overlay
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

          /// Glassmorphism container
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
                          )),
                    ),
                  ),
                ],
              ),
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
          onSlideToContinue: () {
            setState(() {
              _currentView = AuthView.login;
            });
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
          onBackPressed: () {
            setState(() {
              _currentView = AuthView.intro;
            });
          },
          onRegisterPressed: () {
            setState(() {
              _currentView = AuthView.register;
            });
          },
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
          onBackPressed: () {
            setState(() {
              _currentView = AuthView.login;
            });
          },
          onLoginPressed: () {
            setState(() {
              _currentView = AuthView.login;
            });
          },
        );
    }
  }

  void _handleLogin() async {
    FocusScope.of(context).unfocus();

    if (emailController.text.isEmpty || pwController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please fill in all fields'),
        backgroundColor: Colors.red,
      ));
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
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(userFriendlyMessage),
        backgroundColor: Colors.red,
      ));
    } finally {
      if (mounted) {
        setState(() => isProcessing = false);
      }
    }
  }

  void _handleRegistration() async {
    FocusScope.of(context).unfocus();

    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please fill in all fields'),
        backgroundColor: Colors.red,
      ));
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Passwords do not match'),
        backgroundColor: Colors.red,
      ));
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

      // You'll need to implement register method in your AuthCubit
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
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(userFriendlyMessage),
        backgroundColor: Colors.red,
      ));
    } finally {
      if (mounted) {
        setState(() => isProcessing = false);
      }
    }
  }
}

enum AuthView { intro, login, register }

class IntroContent extends StatelessWidget {
  final VoidCallback onSlideToContinue;
  final ColorScheme colors;

  const IntroContent({
    super.key,
    required this.onSlideToContinue,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          middleSizedBox,
          Lottie.asset('asset/ani/work.json',
              height: MediaQuery.of(context).size.height * 0.25),
          heighSizedBox,
          Text("Welcome to Karwaan",
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center),
          middleSizedBox,
          Text("Organize tasks, stay focused, and achieve goals with your team",
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center),
          supperHeighSizedbox,
          _buildFeatureRow(),
          supperHeighSizedbox,
          _buildSlideAction(context, colors, onSlideToContinue),
          middleSizedBox,
          _buildLegalText(colors),
        ],
      ),
    );
  }

  Widget _buildFeatureRow() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _FeatureItem(icon: Icons.groups_rounded, label: "Collaborate"),
          _FeatureItem(icon: Icons.trending_up_rounded, label: "Progress"),
          _FeatureItem(icon: Icons.emoji_events_rounded, label: "Success"),
        ],
      );

  Widget _buildSlideAction(
      BuildContext context, ColorScheme colors, VoidCallback onSubmitted) {
    final GlobalKey<SlideActionState> slideKey = GlobalKey();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [colors.surface, colors.onSurface],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(14),
        ),
        child: SlideAction(
          key: slideKey,
          elevation: 0,
          innerColor: Colors.white.withOpacity(0.2),
          outerColor: Colors.transparent,
          text: "Slide to Continue",
          textStyle: Theme.of(context).textTheme.bodyMedium,
          borderRadius: 14,
          onSubmit: () async {
            onSubmitted();
            await Future.delayed(const Duration(milliseconds: 300));
            slideKey.currentState?.reset();
            return null;
          },
          submittedIcon: Icon(Icons.check, color: colors.onSurface),
          sliderButtonIcon:
              Icon(Icons.arrow_forward_rounded, color: colors.onSurface),
          sliderButtonIconSize: 20,
          sliderButtonIconPadding: 10,
          animationDuration: const Duration(milliseconds: 300),
        ),
      ),
    );
  }

  Widget _buildLegalText(ColorScheme colors) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: GoogleFonts.openSans(fontSize: 12, color: Colors.grey[600]),
            children: const [
              TextSpan(text: 'By continuing, you agree to our '),
              TextSpan(
                  text: 'Privacy Policy',
                  style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Colors.blueAccent)),
              TextSpan(text: ' and '),
              TextSpan(
                  text: 'Terms of Service',
                  style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Colors.blueAccent)),
            ],
          ),
        ),
      );
}

class DeskLoginPageContent extends StatefulWidget {
  final TextEditingController emailController;
  final TextEditingController pwController;
  final bool isProcessing;
  final VoidCallback onLoginPressed;
  final VoidCallback onBackPressed;
  final VoidCallback onRegisterPressed;

  const DeskLoginPageContent({
    super.key,
    required this.emailController,
    required this.pwController,
    required this.isProcessing,
    required this.onLoginPressed,
    required this.onBackPressed,
    required this.onRegisterPressed,
  });

  @override
  State<DeskLoginPageContent> createState() => _DeskLoginPageContentState();
}

class _DeskLoginPageContentState extends State<DeskLoginPageContent>
    with TickerProviderStateMixin {
  late AnimationController _lottieController;

  @override
  void initState() {
    super.initState();
    _lottieController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _lottieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Back button
          Align(
            alignment: Alignment.topLeft,
            child: IconButton(
              icon: Icon(Icons.arrow_back,
                  color: Theme.of(context).iconTheme.color),
              onPressed: widget.onBackPressed,
            ),
          ),
          Lottie.asset(
            'asset/ani/auth.json',
            height: MediaQuery.of(context).size.height * 0.28,
            controller: _lottieController,
            onLoaded: (composition) {
              _lottieController
                ..duration = composition.duration
                ..repeat();
            },
          ),
          middleSizedBox,
          Container(
            height: 50,
            width: MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Theme.of(context).dividerColor)),
            child: Center(
                child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Login with your google account ',
                      style: Theme.of(context).textTheme.bodyMedium),
                  Image.asset(
                    'asset/images/google.png',
                    height: 25,
                    width: 25,
                  )
                ],
              ),
            )),
          ),
          lowSizedBox,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Row(
              children: [
                Expanded(
                  child: Divider(
                      thickness: 1, color: Theme.of(context).dividerColor),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child:
                      Text('OR', style: Theme.of(context).textTheme.bodySmall),
                ),
                Expanded(
                  child: Divider(
                    thickness: 1,
                    color: Theme.of(context).dividerColor,
                  ),
                ),
              ],
            ),
          ),
          lowSizedBox,
          Text('With your email and password.',
              style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 15),
          Textfield(
            text: 'Email',
            obsecureText: false,
            controller: widget.emailController,
          ),
          const SizedBox(height: 10),
          Textfield(
            text: 'Password',
            obsecureText: true,
            controller: widget.pwController,
          ),
          const SizedBox(height: 13),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Button(
              text: widget.isProcessing ? 'Logging in...' : 'Login',
              onTap: widget.isProcessing ? null : widget.onLoginPressed,
            ),
          ),
          lowSizedBox,
          // Don't have any account sign up
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Don't have an account?  ",
                  style: Theme.of(context).textTheme.bodySmall),
              GestureDetector(
                onTap: widget.onRegisterPressed,
                child: Text("Sign Up",
                    style: Theme.of(context).textTheme.titleMedium),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DeskRegisterPageContent extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final bool isProcessing;
  final VoidCallback onRegisterPressed;
  final VoidCallback onBackPressed;
  final VoidCallback onLoginPressed;

  const DeskRegisterPageContent({
    super.key,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.isProcessing,
    required this.onRegisterPressed,
    required this.onBackPressed,
    required this.onLoginPressed,
  });

  @override
  State<DeskRegisterPageContent> createState() =>
      _DeskRegisterPageContentState();
}

class _DeskRegisterPageContentState extends State<DeskRegisterPageContent>
    with TickerProviderStateMixin {
  late AnimationController _lottieController;

  @override
  void initState() {
    super.initState();
    _lottieController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _lottieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Lottie.asset(
            'asset/ani/auth.json',
            height: MediaQuery.of(context).size.height * 0.20,
            controller: _lottieController,
            onLoaded: (composition) {
              _lottieController
                ..duration = composition.duration
                ..repeat();
            },
          ),
          middleSizedBox,
          Container(
            height: 50,
            width: MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Theme.of(context).dividerColor),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Sign up with Google',
                        style: Theme.of(context).textTheme.bodyMedium),
                    Image.asset(
                      'asset/images/google.png',
                      height: 25,
                      width: 25,
                    ),
                  ],
                ),
              ),
            ),
          ),
          lowSizedBox,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: [
                Expanded(
                  child: Divider(
                      thickness: 1, color: Theme.of(context).dividerColor),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child:
                      Text('OR', style: Theme.of(context).textTheme.bodySmall),
                ),
                Expanded(
                  child: Divider(
                    thickness: 1,
                    color: Theme.of(context).dividerColor,
                  ),
                ),
              ],
            ),
          ),
          lowSizedBox,
          Text('With your email and password',
              style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 15),
          Textfield(
            text: 'Full Name',
            obsecureText: false,
            controller: widget.nameController,
          ),
          const SizedBox(height: 10),
          Textfield(
            text: 'Email',
            obsecureText: false,
            controller: widget.emailController,
          ),
          const SizedBox(height: 10),
          Textfield(
            text: 'Password',
            obsecureText: true,
            controller: widget.passwordController,
          ),
          const SizedBox(height: 10),
          Textfield(
            text: 'Confirm Password',
            obsecureText: true,
            controller: widget.confirmPasswordController,
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Button(
              text: widget.isProcessing ? 'Creating Account...' : 'Sign Up',
              onTap: widget.isProcessing ? null : widget.onRegisterPressed,
            ),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Already have an account? ",
                  style: Theme.of(context).textTheme.bodySmall),
              GestureDetector(
                onTap: widget.onLoginPressed,
                child: Text("Log In",
                    style: Theme.of(context).textTheme.titleMedium),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _FeatureItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                  color: Colors.transparent, shape: BoxShape.circle),
              child: Icon(icon, size: 28)),
          const SizedBox(height: 8),
          Text(label, style: Theme.of(context).textTheme.bodySmall),
        ],
      );
}

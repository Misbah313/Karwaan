import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karwaan_flutter/presentation/pages/mobile/login_page.dart';
import 'package:karwaan_flutter/presentation/widgets/utils/constant.dart';
import 'package:lottie/lottie.dart';
import 'package:slide_to_act/slide_to_act.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: myDeafultBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 24),
              // App Logo/Illustration
              Lottie.asset(
                'asset/ani/development.json', 
              ),

              const SizedBox(height: 32),

              // Welcome Message
              Text(
                "Welcome to Karwaan",
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue[800],
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 12),

              // Subtitle
              Text(
                "Organize tasks, stay focused, and achieve goals with your team",
                style: GoogleFonts.openSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 40),

              // Feature Icons Row
              _buildFeatureRow(),

              const SizedBox(height: 40),

              // Slide to Continue
              _buildSlideAction(context),

              const SizedBox(height: 24),

              // Legal Text
              _buildLegalText(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureRow() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _FeatureItem(
          icon: Icons.groups_rounded,
          label: "Collaborate",
        ),
        _FeatureItem(
          icon: Icons.person_rounded,
          label: "Personal Growth",
        ),
        _FeatureItem(
          icon: Icons.check_circle_rounded,
          label: "Stay Focused",
        ),
      ],
    );
  }

  Widget _buildSlideAction(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF1976D2), Color(0xFF2196F3)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: SlideAction(
          elevation: 0,
          innerColor: Colors.white.withOpacity(0.2),
          outerColor: Colors.transparent,
          text: "Slide to Continue",
          textStyle: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
          borderRadius: 12,
          onSubmit: () async => _navigateToLogin(context),
          submittedIcon: const Icon(Icons.check, color: Colors.white),
          sliderButtonIcon: const Icon(
            Icons.arrow_forward_rounded,
            color: Colors.white,
          ),
          sliderButtonIconSize: 20,
          sliderButtonIconPadding: 10,
        ),
      ),
    );
  }

  Widget _buildLegalText() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: GoogleFonts.openSans(
            fontSize: 12,
            color: Colors.grey[600],
          ),
          children: const [
            TextSpan(text: 'By continuing, you agree to our '),
            TextSpan(
              text: 'Privacy Policy',
              style: TextStyle(
                decoration: TextDecoration.underline,
                color: Colors.blue,
              ),
            ),
            TextSpan(text: ' and '),
            TextSpan(
              text: 'Terms of Service',
              style: TextStyle(
                decoration: TextDecoration.underline,
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToLogin(BuildContext context) {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 600),
        pageBuilder: (_, __, ___) => const LoginPage(),
        transitionsBuilder: (_, animation, __, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.5),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutQuad,
            )),
            child: FadeTransition(
              opacity: animation,
              child: child,
            ),
          );
        },
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _FeatureItem({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 28,
            color: Colors.blue[600],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: GoogleFonts.openSans(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

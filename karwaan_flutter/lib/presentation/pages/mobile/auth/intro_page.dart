import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karwaan_flutter/presentation/pages/mobile/auth/login_page.dart';
import 'package:karwaan_flutter/presentation/widgets/utils/constant.dart';
import 'package:lottie/lottie.dart';
import 'package:slide_to_act/slide_to_act.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              middleSizedBox,
              // App Logo/Illustration
              Lottie.asset(
                'asset/ani/work.json',
                height: MediaQuery.of(context).size.height * 0.3
              ),

              heighSizedBox,

              // Welcome Message
              Text(
                "Welcome to Karwaan",
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),

              middleSizedBox,

              // Subtitle
              Text(
                "Organize tasks, stay focused, and achieve goals with your team",
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),

              supperHeighSizedbox,

              // Feature Icons Row
              _buildFeatureRow(),

              supperHeighSizedbox,

              // Slide to Continue
              _buildSlideAction(context),

              middleSizedBox,

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
          gradient:  LinearGradient(
            colors: [Theme.of(context).colorScheme.surface, Theme.of(context).colorScheme.onSurface],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.secondary,
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
          textStyle: Theme.of(context).textTheme.bodyMedium,
          borderRadius: 12,
          onSubmit: () async => _navigateToLogin(context),
          submittedIcon:  Icon(Icons.check, color: Theme.of(context).iconTheme.color),
          sliderButtonIcon:  Icon(
            Icons.arrow_forward_rounded,
            color: Theme.of(context).iconTheme.color,
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
        pageBuilder: (context, animation, secondaryAnimation) =>
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
            color: Theme.of(context).colorScheme.primary,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 28,
            color: Theme.of(context).iconTheme.color,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall
        ),
      ],
    );
  }
}

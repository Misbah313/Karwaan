import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karwaan_flutter/presentation/widgets/utils/button.dart';
import 'package:karwaan_flutter/presentation/widgets/utils/constant.dart';
import 'package:lottie/lottie.dart';

class IntroContent extends StatelessWidget {
  final VoidCallback onTapToContinue;
  final ColorScheme colors;

  const IntroContent({
    super.key,
    required this.onTapToContinue,
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
          _buildCustomButton(context, onTapToContinue),
          middleSizedBox,
          _buildLegalText(colors),
        ],
      ),
    );
  }

  Widget _buildCustomButton(BuildContext context, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Button(text: "Let's Get Started", onTap: onPressed),
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

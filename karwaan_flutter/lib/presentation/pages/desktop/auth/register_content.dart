import 'package:flutter/material.dart';
import 'package:karwaan_flutter/presentation/widgets/utils/button.dart';
import 'package:karwaan_flutter/presentation/widgets/utils/constant.dart';
import 'package:karwaan_flutter/presentation/widgets/utils/textfield.dart';
import 'package:lottie/lottie.dart';

class DeskRegisterPageContent extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final bool isProcessing;
  final VoidCallback onRegisterPressed;
  final VoidCallback onBackPressed;
  final VoidCallback onLoginPressed;
  final VoidCallback onGooglePressed;

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
    required this.onGooglePressed,
  });

  @override
  State<DeskRegisterPageContent> createState() => _DeskRegisterPageContentState();
}

class _DeskRegisterPageContentState extends State<DeskRegisterPageContent>
    with TickerProviderStateMixin {
  late AnimationController _lottieController;

  @override
  void initState() {
    super.initState();
    _lottieController = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat();
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
              _lottieController..duration = composition.duration..repeat();
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
            child: InkWell(
              onTap: widget.isProcessing ? null : widget.onGooglePressed,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(widget.isProcessing ? 'Signing up with Google...' : 'Sign up with Google', style: Theme.of(context).textTheme.bodyMedium),
                      Image.asset('asset/images/google.png', height: 25, width: 25),
                    ],
                  ),
                ),
              ),
            ),
          ),
          lowSizedBox,
          // OR divider
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: [
                Expanded(child: Divider(thickness: 1, color: Theme.of(context).dividerColor)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Text('OR', style: Theme.of(context).textTheme.bodySmall),
                ),
                Expanded(child: Divider(thickness: 1, color: Theme.of(context).dividerColor)),
              ],
            ),
          ),
          lowSizedBox,
          Text('With your email and password', style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 15),
          Textfield(text: 'Full Name', obsecureText: false, controller: widget.nameController),
          const SizedBox(height: 10),
          Textfield(text: 'Email', obsecureText: false, controller: widget.emailController),
          const SizedBox(height: 10),
          Textfield(text: 'Password', obsecureText: true, controller: widget.passwordController),
          const SizedBox(height: 10),
          Textfield(text: 'Confirm Password', obsecureText: true, controller: widget.confirmPasswordController),
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
              Text("Already have an account? ", style: Theme.of(context).textTheme.bodySmall),
              GestureDetector(onTap: widget.onLoginPressed, child: Text("Log In", style: Theme.of(context).textTheme.titleMedium)),
            ],
          ),
        ],
      ),
    );
  }
}

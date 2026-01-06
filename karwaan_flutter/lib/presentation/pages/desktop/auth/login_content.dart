import 'package:flutter/material.dart';
import 'package:karwaan_flutter/presentation/widgets/utils/button.dart';
import 'package:karwaan_flutter/presentation/widgets/utils/constant.dart';
import 'package:karwaan_flutter/presentation/widgets/utils/textfield.dart';
import 'package:lottie/lottie.dart';

class DeskLoginPageContent extends StatefulWidget {
  final TextEditingController emailController;
  final TextEditingController pwController;
  final bool isProcessing;
  final VoidCallback onLoginPressed;
  final VoidCallback onBackPressed;
  final VoidCallback onRegisterPressed;
  final VoidCallback onGooglePressed;

  const DeskLoginPageContent({
    super.key,
    required this.emailController,
    required this.pwController,
    required this.isProcessing,
    required this.onLoginPressed,
    required this.onBackPressed,
    required this.onRegisterPressed,
    required this.onGooglePressed,
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
    _lottieController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2))
          ..repeat();
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
          // Google button
          Container(
            height: 50,
            width: MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Theme.of(context).dividerColor)),
            child: InkWell(
              onTap: widget.isProcessing ? null : widget.onGooglePressed,
              child: Center(
                  child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                        widget.isProcessing
                            ? 'Signing in with Google...'
                            : 'Login with Google',
                        style: Theme.of(context).textTheme.bodyMedium),
                    Image.asset('asset/images/google.png',
                        height: 25, width: 25)
                  ],
                ),
              )),
            ),
          ),
          // OR divider
          lowSizedBox,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Row(
              children: [
                Expanded(
                    child: Divider(
                        thickness: 1, color: Theme.of(context).dividerColor)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child:
                      Text('OR', style: Theme.of(context).textTheme.bodySmall),
                ),
                Expanded(
                    child: Divider(
                        thickness: 1, color: Theme.of(context).dividerColor)),
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
              controller: widget.emailController),
          const SizedBox(height: 10),
          Textfield(
              text: 'Password',
              obsecureText: true,
              controller: widget.pwController),
          const SizedBox(height: 13),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Button(
              text: widget.isProcessing ? 'Logging in...' : 'Login',
              onTap: widget.isProcessing ? null : widget.onLoginPressed,
            ),
          ),
          lowSizedBox,
          Wrap(
            alignment: WrapAlignment.center,
            children: [
              Text("Don't have an account?  ",
                  style: Theme.of(context).textTheme.bodySmall),
              GestureDetector(
                  onTap: widget.onRegisterPressed,
                  child: Text("Sign Up",
                      style: Theme.of(context).textTheme.titleMedium)),
            ],
          ),
        ],
      ),
    );
  }
}

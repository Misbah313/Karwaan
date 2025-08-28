import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:karwaan_flutter/domain/models/auth/auth_credentials.dart';
import 'package:karwaan_flutter/domain/repository/auth/auth_repo.dart';
import 'package:karwaan_flutter/presentation/cubits/auth/auth_cubit.dart';
import 'package:karwaan_flutter/presentation/cubits/auth/auth_gate.dart';
import 'package:karwaan_flutter/presentation/cubits/auth/auth_state_check.dart';
import 'package:karwaan_flutter/presentation/pages/mobile/auth/login_page.dart';
import 'package:karwaan_flutter/presentation/widgets/utils/button.dart';
import 'package:karwaan_flutter/presentation/widgets/utils/constant.dart';
import 'package:karwaan_flutter/presentation/widgets/utils/textfield.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isProcessing = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegistration() async {
    FocusScope.of(context).unfocus();

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Passwords do not match'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('All fields must be filled!'),
        backgroundColor: Colors.red,
      ));
      return;
    }

    setState(() => _isProcessing = true);

    final credentials = AuthCredential(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );
    context
        .read<AuthCubit>()
        .register(credentials, _nameController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthStateCheck>(
      listener: (context, state) {
        if (state is RegisterationSuccess) {
          setState(() => _isProcessing = false);
          if (mounted) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                        value: context.read<AuthCubit>(),
                        child: AuthGate(authRepo: context.read<AuthRepo>()),
                      )),
              (route) => false,
            );
          }
        } else if (state is AuthError) {
          setState(() => _isProcessing = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errormessage)),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.25,
                  child: Image.asset(
                    'asset/images/background.png',
                    fit: BoxFit.contain,
                  ),
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
                          Text(
                            'Sign up with Google',
                            style: Theme.of(context).textTheme.bodyMedium
                          ),
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
                          thickness: 1,
                          color: Theme.of(context).dividerColor
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Text(
                          'OR',
                          style: Theme.of(context).textTheme.bodySmall
                        ),
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
                Text(
                  'With your email and password',
                  style: Theme.of(context).textTheme.bodyMedium
                ),
                const SizedBox(height: 15),
                Textfield(
                  text: 'Full Name',
                  obsecureText: false,
                  controller: _nameController,
                ),
                const SizedBox(height: 10),
                Textfield(
                  text: 'Email',
                  obsecureText: false,
                  controller: _emailController,
                ),
                const SizedBox(height: 10),
                Textfield(
                  text: 'Password',
                  obsecureText: true,
                  controller: _passwordController,
                ),
                const SizedBox(height: 10),
                Textfield(
                  text: 'Confirm Password',
                  obsecureText: true,
                  controller: _confirmPasswordController,
                ),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Button(
                    text: _isProcessing ? 'Creating Account...' : 'Sign Up',
                    isLoading: _isProcessing,
                    onTap: _isProcessing ? null : _handleRegistration,
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account? ",
                      style: Theme.of(context).textTheme.bodySmall
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          PageRouteBuilder(
                            transitionDuration:
                                const Duration(milliseconds: 600),
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
                      child: Text(
                        "Log In",
                        style:Theme.of(context).textTheme.titleMedium
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

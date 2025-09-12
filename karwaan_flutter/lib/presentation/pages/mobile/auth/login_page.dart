import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:karwaan_flutter/data/mappers/auth/error/exception_mapper.dart';
import 'package:karwaan_flutter/domain/models/auth/auth_credentials.dart';
import 'package:karwaan_flutter/domain/repository/auth/auth_repo.dart';
import 'package:karwaan_flutter/presentation/cubits/auth/auth_cubit.dart';
import 'package:karwaan_flutter/presentation/cubits/auth/auth_gate.dart';
import 'package:karwaan_flutter/presentation/pages/mobile/auth/register_page.dart';
import 'package:karwaan_flutter/presentation/widgets/utils/button.dart';
import 'package:karwaan_flutter/presentation/widgets/utils/constant.dart';
import 'package:karwaan_flutter/presentation/widgets/utils/textfield.dart';
import 'package:lottie/lottie.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final pwController = TextEditingController();
  bool isProcessing = false;
  bool showHome = false;

  @override
  void dispose() {
    emailController.dispose();
    pwController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset('asset/ani/auth.json',
                    height: MediaQuery.of(context).size.height * 0.3),

                middleSizedBox,

                Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width * 0.8,
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(15),
                      border:
                          Border.all(color: Theme.of(context).dividerColor)),
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
                            thickness: 1,
                            color: Theme.of(context).dividerColor),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Text('OR',
                            style: Theme.of(context).textTheme.bodySmall),
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
                  controller: emailController,
                ),
                const SizedBox(height: 10),
                Textfield(
                  text: 'Password',
                  obsecureText: true,
                  controller: pwController,
                ),
                const SizedBox(height: 13),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Button(
                    text: isProcessing ? 'Logging in...' : 'Login',
                    onTap: isProcessing
                        ? null
                        : () async {
                            FocusScope.of(context).unfocus();

                            // ✅ Keep only the basic validation (empty fields)
                            if (emailController.text.isEmpty ||
                                pwController.text.isEmpty) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
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

                              // ✅ Let the cubit handle ALL server errors
                              await authCubit.login(credentials);

                              await Future.delayed(
                                  const Duration(milliseconds: 300));

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
                              // ✅ Use your ExceptionMapper to get user-friendly message
                              final userFriendlyMessage =
                                  ExceptionMapper.toMessage(e);
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text(userFriendlyMessage),
                                backgroundColor: Colors.red,
                              ));
                            } finally {
                              if (mounted) {
                                setState(() => isProcessing = false);
                              }
                            }
                          },
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
                      onTap: () async {
                        await Navigator.pushReplacement(
                          context,
                          PageRouteBuilder(
                            transitionDuration:
                                const Duration(milliseconds: 600),
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    const RegisterPage(),
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
                      child: Text("Sign Up",
                          style: Theme.of(context).textTheme.titleMedium),
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

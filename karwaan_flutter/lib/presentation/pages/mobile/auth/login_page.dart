import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karwaan_flutter/domain/models/auth/auth_credentials.dart';
import 'package:karwaan_flutter/domain/repository/auth/auth_repo.dart';
import 'package:karwaan_flutter/presentation/cubits/auth/auth_cubit.dart';
import 'package:karwaan_flutter/presentation/cubits/auth/auth_error_handler.dart';
import 'package:karwaan_flutter/presentation/cubits/auth/auth_gate.dart';
import 'package:karwaan_flutter/presentation/pages/mobile/auth/register_page.dart';
import 'package:karwaan_flutter/presentation/widgets/utils/button.dart';
import 'package:karwaan_flutter/presentation/widgets/utils/constant.dart';
import 'package:karwaan_flutter/presentation/widgets/utils/textfield.dart';

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
      backgroundColor: myDeafultBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('asset/images/background.png'),

                middleSizedBox,

                Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width * 0.8,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.blue.shade300)),
                  child: Center(
                      child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Login with your google account ',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w300,
                                color: Colors.grey.shade500,
                                fontSize: 15)),
                        Image.asset('asset/images/google.png', height: 25, width: 25,)
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
                          color: Colors.blue.shade300,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Text(
                          'OR',
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w300,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 1,
                          color: Colors.blue.shade300,
                        ),
                      ),
                    ],
                  ),
                ),
                lowSizedBox,
                Text(
                  'With your email and password.',
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w300,
                    color: Colors.grey.shade700,
                  ),
                ),
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
                            if (emailController.text.isEmpty ||
                                pwController.text.isEmpty) {
                              AuthErrorHandler.showErrorSnackBar(
                                  context, 'Please fill in all fields');
                              return;
                            }
                            setState(() => isProcessing = true);
                            try {
                              final authCubit = context.read<AuthCubit>();
                              final credentials = AuthCredential(
                                email: emailController.text.trim(),
                                password: pwController.text.trim(),
                              );
                              await authCubit.login(credentials);

                              await Future.delayed(Duration(milliseconds: 300));

                              // Critical change: Use pushAndRemoveUntil to completely reset navigation
                              if (mounted) {
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                    builder: (_) => BlocProvider.value(
                                      value: authCubit,
                                      child: AuthGate(
                                          authRepo: context.read<AuthRepo>()),
                                    ),
                                  ),
                                  (route) => false,
                                );
                              }
                            } catch (e) {
                              if (mounted) {
                                if (e
                                    .toString()
                                    .contains('invalid credentials')) {
                                  AuthErrorHandler.showErrorDialog(context, e);
                                } else {
                                  AuthErrorHandler.showErrorSnackBar(
                                      context, e);
                                }
                              }
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
                    Text(
                      "Don't have an account?  ",
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w300,
                        color: Colors.grey.shade600,
                      ),
                    ),
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
                      child: Text(
                        "Sign Up",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.blue.shade600,
                        ),
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

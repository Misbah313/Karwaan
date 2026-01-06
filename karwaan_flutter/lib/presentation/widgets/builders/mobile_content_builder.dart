import 'package:flutter/material.dart';
import 'package:karwaan_flutter/domain/repository/auth/auth_repo.dart';
import 'package:karwaan_flutter/domain/repository/workspace/workspace_repo.dart';
import 'package:karwaan_flutter/presentation/cubits/auth/auth_cubit.dart';
import 'package:karwaan_flutter/presentation/cubits/auth/auth_page.dart';
import 'package:karwaan_flutter/presentation/cubits/auth/auth_state_check.dart';
import 'package:karwaan_flutter/presentation/cubits/workspace/workspace_page.dart';
import 'package:karwaan_flutter/presentation/pages/mobile/auth/login_page.dart';
import 'package:karwaan_flutter/presentation/pages/mobile/workspace/home_page.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class MobileContentBuilder {
  static Widget buildContent({
    required BuildContext context,
    required AuthStateCheck state,
    required AuthRepo authRepo,
    required bool showLoading,
    required bool showContent,
  }) {
    // EXACT SAME LOGIC AS YOUR ORIGINAL MOBILE AUTHGATE
    if (showLoading) {
      return _buildLoadingScreen(context);
    }

    if (showContent) {
      if (state is AuthAuthenticated) {
        return WorkspacePage(
          workspaceRepo: context.read<WorkspaceRepo>(),
          child: const HomePage(),
        );
      }
      if (state is RegisterationSuccess) {
        return _buildRegistrationSuccessScreen(context, authRepo);
      }
      if (state is AuthError) {
        return _buildErrorScreen(
          context: context,
          title: 'Error',
          message: state.errormessage,
          asset: 'asset/ani/error.json',
          actionText: 'Retry',
          action: () => context.read<AuthCubit>().checkAuth(),
          showLoading: false,
        );
      }
      if (state is DeleteSuccessfully) {
        return _buildAccountDeletedScreen(context);
      }
      if (state is AuthUnAuthenticated) {
        return AuthPage(authRepo: authRepo);
      }
    }

    return const SizedBox.shrink();
  }

  static Widget _buildLoadingScreen(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'asset/ani/dataSecure.json',
              width: 300,
              height: 300,
            ),
            const SizedBox(height: 20),
            Text('Securing your session...',
                style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }

  static Widget _buildRegistrationSuccessScreen(
      BuildContext context, AuthRepo authRepo) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(
                  'asset/ani/registered.json',
                  width: 250,
                  height: 250,
                  repeat: false,
                ),
                const SizedBox(height: 32),
                Text('Welcome Aboard!',
                    style: Theme.of(context).textTheme.bodyLarge),
                const SizedBox(height: 16),
                Text(
                    'Your account has been successfully created.\nPlease Login with your credentials.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        PageRouteBuilder(
                          transitionDuration: const Duration(milliseconds: 600),
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
                    child: Text('Continue to Login',
                        style: Theme.of(context).textTheme.bodyMedium),
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AuthPage(authRepo: authRepo),
                    ),
                  ),
                  child: Text('Back to Home',
                      style: Theme.of(context).textTheme.bodySmall),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Widget _buildAccountDeletedScreen(BuildContext context) {
    return _buildErrorScreen(
      context: context,
      title: 'Account Deleted',
      message: 'Your account has been successfully deleted.',
      asset: 'asset/ani/deleted.json',
      actionText: 'Create New Account',
      action: () {
        context.read<AuthCubit>().resetToUnAuthenticated();
      },
      showLoading: false,
    );
  }

  static Widget _buildErrorScreen({
    required BuildContext context,
    required String title,
    required String message,
    required String asset,
    String? actionText,
    VoidCallback? action,
    required bool showLoading,
  }) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.asset(asset, width: 180, height: 180, repeat: false),
                    const SizedBox(height: 24),
                    Text(title, style: Theme.of(context).textTheme.bodyLarge),
                    const SizedBox(height: 12),
                    Text(message,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(height: 32),
                    if (actionText != null && action != null)
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            minimumSize: const Size(200, 50),
                            padding: const EdgeInsets.symmetric(horizontal: 32),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            backgroundColor:
                                Theme.of(context).colorScheme.primary),
                        onPressed: action,
                        child: Text(actionText,
                            style: Theme.of(context).textTheme.bodySmall),
                      ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          PageRouteBuilder(
                            transitionDuration:
                                const Duration(milliseconds: 600),
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    HomePage(),
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
                      child: Text('Return to Login',
                          style: Theme.of(context).textTheme.bodySmall),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (showLoading)
          const Center(
            child: CircularProgressIndicator.adaptive(),
          ),
      ],
    );
  }
}

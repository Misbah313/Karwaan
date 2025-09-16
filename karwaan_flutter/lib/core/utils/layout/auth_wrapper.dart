import 'package:flutter/material.dart';
import 'package:karwaan_flutter/core/utils/layout/responsive_layout.dart';
import 'package:karwaan_flutter/presentation/pages/desktop/auth/desk_on_auth_page.dart';
import 'package:karwaan_flutter/presentation/pages/mobile/auth/intro_page.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(mobile: IntroPage(), desktop: DeskOnAuthPage());
  }
}

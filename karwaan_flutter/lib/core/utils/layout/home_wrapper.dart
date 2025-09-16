import 'package:flutter/material.dart';
import 'package:karwaan_flutter/core/utils/layout/responsive_layout.dart';
import 'package:karwaan_flutter/presentation/pages/desktop/workspace/desk_home_page.dart';
import 'package:karwaan_flutter/presentation/pages/mobile/workspace/home_page.dart';

class HomeWrapper extends StatelessWidget {
  const HomeWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(mobile: HomePage(), desktop: DeskHomePage());
  }
}

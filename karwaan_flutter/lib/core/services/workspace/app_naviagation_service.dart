import 'package:flutter/material.dart';
import 'package:karwaan_flutter/core/services/workspace/logout_dialog_service.dart';
import 'package:karwaan_flutter/presentation/pages/desktop/auth/account_control_page.dart';

abstract class AppNavigationService {
  void navigateToPage(int index, String menuName);
  void showLogoutDialog(BuildContext context);
  void navigateToProfile(BuildContext context);
}

class AppNavigationServiceImpl implements AppNavigationService {
  final PageController mainContentController;
  // final PageController sidebarController;
  final Function(String) onMenuChange;
  final LogoutDialogService logoutDialogService;

  AppNavigationServiceImpl({
    required this.mainContentController,
    // required this.sidebarController,
    required this.onMenuChange,
    required this.logoutDialogService,
  });

  @override
  void navigateToPage(int index, String menuName) {

    onMenuChange(menuName);
    
    Future.delayed(Duration.zero, () {
      if (mainContentController.hasClients) {
        mainContentController.animateToPage(
          index,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    });

    // sidebarController.animateToPage(
    //   index,
    //   duration: const Duration(milliseconds: 400),
    //   curve: Curves.easeInOut,
    // );
  }

  @override
  void showLogoutDialog(BuildContext context) {
    logoutDialogService.showLogoutDialog(context);
  }

  @override
  void navigateToProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AccountControlPage(),
      ),
    );
  }
}

class DialogStateManager {
  bool showRegistrationDialog = false;
  bool showAccountDeletedDialog = false;

  void showRegistrationSuccess() {
    showRegistrationDialog = true;
    showAccountDeletedDialog = false;
  }

  void showAccountDeleted() {
    showAccountDeletedDialog = true;
    showRegistrationDialog = false;
  }

  void hideAllDialogs() {
    showRegistrationDialog = false;
    showAccountDeletedDialog = false;
  }

  void resetToUnauthenticated() {
    hideAllDialogs();
  }
}
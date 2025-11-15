import 'dart:async';
import 'package:flutter/material.dart';

class BannerManager extends ChangeNotifier {
  String? _message;
  bool _show = false;
  Timer? _timer;

  Color _backgroundColor = Colors.red;
  Color get backgroundColor => _backgroundColor;

  bool get isShowing => _show;
  String? get message => _message;

  void show(
    String message, {
    Color backgroundColor = Colors.red,
    Duration duration = const Duration(seconds: 4),
  }) {
    _timer?.cancel();

    _message = message;
    _backgroundColor = backgroundColor;
    _show = true;
    notifyListeners();

    _timer = Timer(duration, () {
      _show = false;
      _message = null;
      notifyListeners();
    });
  }

  void hide() {
    _timer?.cancel();
    _show = false;
    _message = null;
    notifyListeners();
  }
}

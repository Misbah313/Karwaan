import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityManager {
  StreamSubscription<List<ConnectivityResult>>? _subscription;
  bool _isConnected = true;
  ConnectivityResult _lastResult = ConnectivityResult.none;

  bool get isConnected => _isConnected;
  ConnectivityResult get lastResult => _lastResult;

  Future<void> initialize() async {
    await _checkInitialConnectivity();
    _subscription =
        Connectivity().onConnectivityChanged.listen(_handleConnectivityChange);
  }

  Future<void> _checkInitialConnectivity() async {
    final results = await Connectivity().checkConnectivity();
    _updateConnectionState(results);
  }

  void _handleConnectivityChange(List<ConnectivityResult> results) {
    _updateConnectionState(results);
  }

  void _updateConnectionState(List<ConnectivityResult> results) {
    _isConnected = results.isNotEmpty &&
        results.any((result) => result != ConnectivityResult.none);
    _lastResult = _isConnected
        ? results.firstWhere(
            (r) => r != ConnectivityResult.none,
            orElse: () => ConnectivityResult.none,
          )
        : ConnectivityResult.none;
  }

  void dispose() {
    _subscription?.cancel();
  }
}

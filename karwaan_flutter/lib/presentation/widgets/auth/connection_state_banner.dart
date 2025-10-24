// widgets/connection_state_banner.dart
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class ConnectionStateBanner extends StatelessWidget {
  final bool isConnected;
  final ConnectivityResult lastResult;
  final bool showBanner;

  const ConnectionStateBanner({
    super.key,
    required this.isConnected,
    required this.lastResult,
    required this.showBanner,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: showBanner ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 300),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 200),
        height: 40,
        decoration: BoxDecoration(
          color: isConnected ? Colors.green : Colors.redAccent,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isConnected ? _getIconForConnection(lastResult) : Icons.wifi_off,
              color: Colors.white,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconForConnection(ConnectivityResult result) {
    switch (result) {
      case ConnectivityResult.wifi:
        return Icons.wifi;
      case ConnectivityResult.mobile:
        return Icons.network_cell;
      case ConnectivityResult.ethernet:
        return Icons.settings_ethernet;
      default:
        return Icons.wifi_off;
    }
  }
}

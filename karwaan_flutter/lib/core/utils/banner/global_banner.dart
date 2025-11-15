import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'banner_manager.dart';

class GlobalBanner extends StatelessWidget {
  const GlobalBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BannerManager>(
      builder: (context, manager, _) {
        if (!manager.isShowing || manager.message == null) {
          return const SizedBox.shrink();
        }

        return Positioned(
          top: 40,
          left: 16,
          right: 16,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 500, // ✅ Wider for larger screens
                minWidth: 200, // ✅ Ensure small screens look okay
              ),
              child: Material(
                color: Colors.transparent,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  decoration: BoxDecoration(
                    color: manager.backgroundColor.withValues(alpha: 0.95),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.error_outline,
                          color: Colors.white, size: 22),
                      const SizedBox(width: 12),
                      Flexible(
                        child: Text(
                          manager.message!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                          ),
                          textAlign: TextAlign.center,
                          softWrap: true,
                        ),
                      ),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: () => manager.hide(),
                        child: const Icon(Icons.close,
                            color: Colors.white, size: 20),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

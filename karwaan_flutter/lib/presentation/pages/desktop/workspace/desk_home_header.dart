import 'dart:async';

import 'package:flutter/material.dart';
import 'package:karwaan_flutter/domain/models/auth/auth_user.dart';

class DeskHomeHeader extends StatefulWidget {
  final AuthUser user;
  const DeskHomeHeader({super.key, required this.user});

  @override
  State<DeskHomeHeader> createState() => _DeskHomeHeaderState();
}

class _DeskHomeHeaderState extends State<DeskHomeHeader> {
  String searchText = '';
  Timer? _debounceTimer;

  void _onSearchChange(String value) {
    if (_debounceTimer != null) {
      _debounceTimer!.cancel();
    }

    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      setState(() {
        searchText = value;
      });
      // Search functionality here(later)
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).dividerColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // greetings
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.user.name.isNotEmpty
                      ? 'Hello, ${widget.user.name} 👋'
                      : 'Hello, Guest 👋',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
                SizedBox(height: 8),
                Text(
                  'A great day to get better✨',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.7),
                      ),
                ),
              ],
            ),
          ),

          SizedBox(width: 20),

          // search bar + notifications
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // search bar
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.2,
                child: SearchBar(
                  constraints: BoxConstraints(
                    maxHeight: 45,
                    minHeight: 45,
                  ),
                  side: WidgetStateProperty.all(
                    BorderSide(
                      color:
                          Theme.of(context).dividerColor.withValues(alpha: 0.5),
                      width: 1,
                    ),
                  ),
                  backgroundColor: WidgetStateProperty.all(
                    Theme.of(context).colorScheme.surface,
                  ),
                  elevation: WidgetStateProperty.all(2),
                  leading: Icon(
                    Icons.search,
                    color: Theme.of(context)
                        .iconTheme
                        .color
                        ?.withValues(alpha: 0.7),
                  ),
                  hintText: 'Search boards, tasks...',
                  textStyle: WidgetStateProperty.all(
                    Theme.of(context).textTheme.bodyMedium,
                  ),
                  onChanged: _onSearchChange,
                ),
              ),

              SizedBox(width: 12),

              // notifications
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).colorScheme.surface,
                  border: Border.all(
                    color:
                        Theme.of(context).dividerColor.withValues(alpha: 0.3),
                  ),
                ),
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.notifications_outlined,
                    color: Theme.of(context).iconTheme.color,
                    size: 22,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

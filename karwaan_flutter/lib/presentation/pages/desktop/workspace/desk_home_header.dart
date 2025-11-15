import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:karwaan_flutter/core/utils/banner/banner_manager.dart';
import 'package:karwaan_flutter/core/utils/search_function/search_cubit.dart';
import 'package:karwaan_flutter/core/utils/search_function/search_service.dart';
import 'package:karwaan_flutter/domain/models/auth/auth_user.dart';
import 'package:karwaan_flutter/presentation/widgets/board_search_overaly.dart';

class DeskHomeHeader extends StatefulWidget {
  final AuthUser user;
  const DeskHomeHeader({super.key, required this.user});

  @override
  State<DeskHomeHeader> createState() => _DeskHomeHeaderState();
}

class _DeskHomeHeaderState extends State<DeskHomeHeader> {
  final TextEditingController searchController = TextEditingController();
  final SearchService _searchService = SearchService();

  void _onSearchChange(String value) {
    _searchService.debounceSearch(
      query: value,
      duration: const Duration(seconds: 2),
      onSearch: _performSearch,
    );
  }

  void _performSearch(String query) {
    context.read<SearchCubit>().search(query);
  }

  void _showSearchResults(BuildContext context, SearchLoaded state) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BoardSearchOverlay(
        query: searchController.text,
        boards: state.boards,
        cards: state.cards,
      ),
    );
  }

  void _showNotificationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          'Notifications',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        content: Text(
          'Coming soon...',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchService.dispose();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SearchCubit, SearchState>(
      listener: (context, state) {
        if (state is SearchLoaded) {
          _showSearchResults(context, state);
        } else if (state is SearchError) {
          context.read<BannerManager>().show(state.message);
        }
      },
      child: Container(
        padding: EdgeInsets.all(20),
        margin: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: Theme.of(context).dividerColor.withValues(alpha: 0.4),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Greetings section
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.user.name.isNotEmpty
                        ? 'Hello, ${widget.user.name} 👋'
                        : 'Hello, Guest 👋',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'A great day to get better✨',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            SizedBox(width: 20),
            // Search bar + notifications
            _buildSearchAndNotifications(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchAndNotifications(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Search bar
        SizedBox(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.2,
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white.withValues(alpha: 0.05)
                  : Colors.black.withValues(alpha: 0.03),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(context).dividerColor.withValues(alpha: 0.4),
              ),
            ),
            child: TextField(
              controller: searchController,
              style:
                  Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 14),
              cursorColor: Theme.of(context).colorScheme.primary,
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                isDense: false,
                filled: false,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                prefixIcon: Icon(
                  Icons.search,
                  size: 20,
                  color: Theme.of(context).iconTheme.color,
                ),
                hintText: 'Search boards, tasks...',
                hintStyle: Theme.of(context).textTheme.bodySmall,
              ),
              onChanged: _onSearchChange,
            ),
          ),
        ),
        SizedBox(width: 12),
        // Notifications
        _buildNotificationButton(context),
      ],
    );
  }

  Widget _buildNotificationButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.white.withValues(alpha: 0.05)
            : Colors.black.withValues(alpha: 0.03),
        border: Border.all(
          color: Theme.of(context).dividerColor.withValues(alpha: 0.4),
        ),
      ),
      child: IconButton(
        onPressed: () => _showNotificationDialog(context),
        icon: Icon(
          Icons.notifications_outlined,
          color: Theme.of(context).iconTheme.color,
          size: 22,
        ),
      ),
    );
  }
}

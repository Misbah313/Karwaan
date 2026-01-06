import 'dart:async';

class SearchService {
  Timer? _debounceTimer;

  void debounceSearch({
    required String query,
    required Duration duration,
    required Function(String) onSearch,
  }) {
    _debounceTimer?.cancel();

    if (query.trim().isNotEmpty) {
      _debounceTimer = Timer(duration, () {
        onSearch(query.trim());
      });
    }
  }

  void dispose() {
    _debounceTimer?.cancel();
  }
}

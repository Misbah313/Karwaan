import 'package:karwaan_flutter/core/services/client/serverpod_client_service.dart';

class ProfileImageService {
  final ServerpodClientService serverpodService;
  final Map<String, String> _cache = {};

  ProfileImageService({required this.serverpodService});

  Future<String> getProfileImageUrl(String? filename) async {
    if (filename == null) return '';

    if (_cache.containsKey(filename)) {
      return _cache[filename]!;
    }

    final url = await serverpodService.getProfilePictureUrl(filename);
    _cache[filename] = url;
    return url;
  }

  void clearCache() {
    _cache.clear();
  }
}

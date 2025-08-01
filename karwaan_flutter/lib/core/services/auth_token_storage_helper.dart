/*

  auth token storage:

    - It encapsulates secure storage operations, so other service code doesn’t deal with keys or storage details.
    - It gives a clear API for token management: save, get, delete.

*/

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthTokenStorageHelper {
  final _storage = const FlutterSecureStorage();
  final _key = 'auth_token';

  // save token
  Future<void> saveToken(String token) async {
    await _storage.write(key: _key, value: token);
  }

  // read token
  Future<String?> getToken() async {
    return await _storage.read(key: _key);
  }

  // delete token
  Future<void> deleteToken() async {
    try {
      debugPrint('Deleting token...');
      await _storage.delete(key: _key);

      // force clear web cache
      if (kIsWeb) {
        await _storage.write(
            key: 'cache_buster', value: DateTime.now().toString());
        await _storage.delete(key: 'cache_buster');
      }

      // verify deletion
      final verify = await _storage.read(key: _key);
      assert(verify == null, 'Token still exists after deletion!');
      debugPrint('TOKEN DELETION VERIFIED: ${verify ?? "Null"}');
    } catch (e) {
      debugPrint('Token Deletion Failed: $e');
      rethrow;
    }
  }
}

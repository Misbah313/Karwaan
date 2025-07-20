/*

  auth token storage:

    - It encapsulates secure storage operations, so other service code doesn’t deal with keys or storage details.
    - It gives a clear API for token management: save, get, delete.

*/

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
    await _storage.delete(key: _key);
  }
}

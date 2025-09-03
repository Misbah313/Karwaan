import 'package:test/test.dart';
import 'package:karwaan_server/src/endpoints/hashing_pw.dart';

void main() {
  test('encryptPassword produces consistent SHA-256 hash', () {
    final password = 'mypassword123';
    final hash1 = encryptPassword(password);
    final hash2 = encryptPassword(password);

    // Same input always produces same output
    expect(hash1, equals(hash2));

    // SHA-256 hashes should be 64 chars long
    expect(hash1.length, equals(64));
  });

  test('Different passwords produce different hashes', () {
    final hash1 = encryptPassword('password1');
    final hash2 = encryptPassword('password2');

    expect(hash1, isNot(equals(hash2)));
  });
}

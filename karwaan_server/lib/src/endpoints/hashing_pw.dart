
    // hash the password for security
    import 'dart:convert';

import 'package:crypto/crypto.dart';

String encryptPassword(String password) {
      final bytes = utf8.encode(password);
      final hash = sha256.convert(bytes);
      return hash.toString();
    }
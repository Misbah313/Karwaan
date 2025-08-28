import 'dart:io';
import 'package:serverpod/serverpod.dart';
import 'package:karwaan_server/src/generated/protocol.dart';

class FileEndpoint extends Endpoint {
  Future<String> uploadProfilePicture(
    Session session,
    int userId,
    String fileName,
    List<int> fileBytes,
  ) async {
    try {
      final user = await User.db.findById(session, userId);
      if (user == null) throw Exception('User not found');

      // Create directory if needed
      final uploadDir = Directory('uploads/profile_pictures');
      if (!await uploadDir.exists()) {
        await uploadDir.create(recursive: true);
      }

      // Generate filename
      final fileExtension = fileName.split('.').last;
      final uniqueFileName =
          '${userId}_${DateTime.now().millisecondsSinceEpoch}.$fileExtension';

      // Save file manually
      final file = File('uploads/profile_pictures/$uniqueFileName');
      await file.writeAsBytes(fileBytes);

      // Update user with just filename (not path)
      user.profileImage = uniqueFileName;
      await User.db.updateRow(session, user);

      return uniqueFileName;
    } catch (e) {
      session.log('Error: $e');
      throw Exception('Failed: $e');
    }
  }

  Future<bool> deleteProfilePicture(Session session, int userId) async {
    try {
      final user = await User.db.findById(session, userId);
      if (user == null || user.profileImage == null) return false;

      // Delete file manually
      final file = File('uploads/profile_pictures/${user.profileImage}');
      if (await file.exists()) await file.delete();

      user.profileImage = null;
      await User.db.updateRow(session, user);

      return true;
    } catch (e) {
      session.log('Error: $e');
      return false;
    }
  }
}

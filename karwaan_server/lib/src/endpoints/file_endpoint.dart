import 'dart:io'; // This import contains 'Platform'
import 'package:serverpod/serverpod.dart';
import 'package:karwaan_server/src/generated/protocol.dart';
import 'package:path/path.dart' as p;

class FileEndpoint extends Endpoint {
  Future<String> uploadProfilePicture(
    Session session,
    int userId,
    String fileName,
    List<int> fileBytes,
  ) async {
    try {
      final user = await User.db.findById(session, userId);
      if (user == null) throw AppAuthException(message: 'User not found');

      // --- SECURITY: Sanitize filename ---
      final fileExtension = p.extension(fileName).toLowerCase();
      const allowedExtensions = ['.jpg', '.jpeg', '.png', '.gif', '.bmp'];
      if (!allowedExtensions.contains(fileExtension)) {
        throw RandomAppException(
            message: 'Invalid file type. Only images are allowed.');
      }

      // --- RELIABILITY: Use a safe, unique name ---
      final uniqueFileName = 'user_${userId}_profile$fileExtension';

      // *** CRITICAL FIX: Build the absolute path reliably ***
      final scriptDir = File(Platform.script.toFilePath()).parent;
      final projectRoot = session.server.runMode == ServerpodRunMode.development
          ? scriptDir.parent
          : scriptDir.parent.parent;

      final uploadsDir = Directory(p.join(
        projectRoot.path,
        'uploads',
        'profile_pictures',
      ));

      if (!await uploadsDir.exists()) {
        await uploadsDir.create(recursive: true);
      }

      // Create the file object
      final file = File(p.join(uploadsDir.path, uniqueFileName));

      // --- SECURITY: Prevent Overwriting ---
      if (user.profileImage != null) {
        final oldFile = File(p.join(uploadsDir.path, user.profileImage!));
        if (await oldFile.exists()) {
          await oldFile.delete();
        }
      }

      // Write the new file
      await file.writeAsBytes(fileBytes);

      // Update user with the new filename
      user.profileImage = uniqueFileName;
      await User.db.updateRow(session, user);

      return uniqueFileName;
    } catch (e) {
      if (e is AppAuthException ||
          e is AppNotFoundException ||
          e is AppPermissionException ||
          e is RandomAppException) {
        rethrow;
      }
      throw AppException(message: 'Failed to upload profile picture');
    }
  }

  Future<List<int>> serveProfilePicture(
    Session session,
    String filename,
  ) async {
    try {
      // Use the EXACT SAME path calculation logic as the upload method
      final scriptDir = File(Platform.script.toFilePath()).parent;
      final projectRoot = session.server.runMode == ServerpodRunMode.development
          ? scriptDir.parent
          : scriptDir.parent.parent;

      final uploadsDir = Directory(p.join(
        projectRoot.path,
        'uploads',
        'profile_pictures',
      ));

      final file = File(p.join(uploadsDir.path, filename));

      if (!await file.exists()) {
        throw AppNotFoundException(resourceType: 'Profile image');
      }

      // Read the file bytes and return them
      return await file.readAsBytes();
    } catch (e) {
      if (e is AppAuthException ||
          e is AppNotFoundException ||
          e is AppPermissionException ||
          e is RandomAppException) {
        rethrow;
      }
      throw AppException(message: 'Failed to serve profile picture');
    }
  }

  Future<bool> deleteProfilePicture(Session session, int userId) async {
    try {
      final user = await User.db.findById(session, userId);
      if (user == null || user.profileImage == null) return false;

      // *** Use the same absolute path logic ***
      final scriptDir = File(Platform.script.toFilePath()).parent;
      // Use the RunMode enum from the session.server
      final projectRoot = session.server.runMode == ServerpodRunMode.development
          ? scriptDir.parent // Now gets the project root (bin's parent)
          : scriptDir.parent
              .parent; // Might need an extra .parent for production, we'll test later

      final uploadsDir = Directory(p.join(
        projectRoot.path,
        'uploads',
        'profile_pictures',
      ));

      // Delete file manually
      final file = File(p.join(uploadsDir.path, user.profileImage!));
      if (await file.exists()) await file.delete();

      user.profileImage = null;
      await User.db.updateRow(session, user);

      return true;
    } catch (e) {
      return false;
    }
  }
}

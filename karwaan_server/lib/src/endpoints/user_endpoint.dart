import 'package:karwaan_server/src/endpoints/hashing_pw.dart';

import 'package:karwaan_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart';

class UserEndpoint extends Endpoint {
  /* Create user
  Future<User> createUser(Session session, User user) async {
    User? existingUser = await User.db.findFirstRow(
      session,
      where: (u) => u.email.equals(user.email),
    );
    if (existingUser != null) {
      throw Exception('User with this email already exists');
    }
    try {
      final newUser = User(
          name: user.name,
          email: user.email,
          password: encryptPassword(user.password),
          id: user.id);

      await User.db.insertRow(session, newUser);
      return newUser;
    } catch (e) {
      throw Exception(e);
    }
  }
  */

  // Get user by Id
  Future<User?> getUserById(Session session, int userId) async {
    try {
      User? user = await User.db.findById(session, userId);
      return user;
    } catch (e) {
      throw Exception(e);
    }
  }

  // Get all users
  Future<List<User>> getAllUsers(Session session) async {
    try {
      final users = await User.db.find(session);
      for (final user in users) {
        user.password = '';
      }
      return users;
    } catch (e) {
      throw Exception(e);
    }
  }

  // Update user
  Future<User> updateUser(Session session, User updatedUser) async {
    try {
      // load the old user from the db by using id
      User? oldUser = await User.db.findById(session, updatedUser.id!);
      if (oldUser == null) {
        throw Exception('User not found');
      }
      // if the update user and old user passwords don't match hash the updated password
      if (updatedUser.password != oldUser.password) {
        updatedUser.password = encryptPassword(updatedUser.password);
      }

      // updated the user row with the updatedUser
      await User.db.updateRow(session, updatedUser);

      return updatedUser;
    } catch (e) {
      throw Exception(e);
    }
  }

  // Delete user
  Future<bool> deleteUser(Session session, int id) async {
    try {
      session.log('Attemping to delete user with id: $id');
      User? user = await User.db.findById(session, id);
      try {
        if (user == null) {
          return false;
        } else {
          await UserToken.db.deleteWhere(
            session,
            where: (p0) => p0.userId.equals(id),
          );
          await User.db.deleteRow(session, user);
          session.log('User deleted successfully');
          return true;
        }
      } catch (e) {
        throw Exception(e.toString());
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  // update user theme prefrence
  Future<bool> updateUserTheme(
      Session session, int userId, bool isDarkMode) async {
    try {
      final user = await User.db.findById(session, userId);
      if (user == null) return false;

      await User.db.updateRow(session, user.copyWith(isDarkMode: isDarkMode));
      return true;
    } catch (e) {
      throw Exception('Failed to update theme: ${e}');
    }
  }

  // get user theme
  Future<bool?> getUserTheme(Session session, int userId) async {
    try {
      final user = await User.db.findById(session, userId);
      return user?.isDarkMode;
    } catch (e) {
      return null;
    }
  }
}

/*

  What can i add later:
   
   ## Email verification & password reset flows (to handle user security properly).

   ## User roles/permissions (e.g., admin, member, guest) — for workspace management and access control.

   ## Authentication endpoints (login/logout/token refresh) — usually separate from this UserEndpoint.

   ## Search/filter users (e.g., search by name/email) for big teams.
 
   ## Pagination for getAllUsers() if user base grows large.

 */

import 'package:karwaan_server/src/endpoints/hashing_pw.dart';

import 'package:karwaan_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart';

class UserEndpoint extends Endpoint {
  
  

  // Create user
  Future<User> createUser(Session session, User user) async {
    User? existingUser = await User.db.findFirstRow(
      session,
      where: (u) => u.email.equals(user.email),
    );
    if (existingUser != null) {
      throw Exception('User with this email already exists');
    }

    final newUser = User(
        name: user.name,
        email: user.email,
        password: encryptPassword(user.password),
        id: user.id);

    await User.db.insertRow(session, newUser);
    return newUser;
  }

  // Get user by Id
  Future<User?> getUserById(Session session, int userId) async {
    User? user = await User.db.findById(session, userId);
    return user;
  }

  // Get all users
  Future<List<User>> getAllUsers(Session session) async {
    final users = await User.db.find(session);
    for (final user in users) {
      user.password = '';
    }
    return users;
  }

  // Update user
  Future<User> updateUser(Session session, User UpdatedUser) async {
    // load the old user from the db by using id
    User? oldUser = await User.db.findById(session, UpdatedUser.id!);
    if (oldUser == null) {
      throw Exception('User not found');
    }
    // if the update user and old user passwords don't match hash the updated password
    if (UpdatedUser.password != oldUser.password) {
      UpdatedUser.password = encryptPassword(UpdatedUser.password);
    }

    // updated the user row with the updatedUser
    await User.db.updateRow(session, UpdatedUser);

    return UpdatedUser;
  }

  // Delete user
  Future<bool> deleteUser(Session session, int id) async {
    User? user = await User.db.findById(session, id);
    try {
      if (user == null) {
        return false;
      } else {
        await User.db.deleteRow(session, user);
        return true;
      }
    } catch (e) {
      throw Exception(e.toString());
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

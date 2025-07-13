import 'package:karwaan_server/src/endpoints/token_endpoint.dart';
import 'package:karwaan_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart';

class LabelEndpoint extends Endpoint {
  // create a label
  Future<Label> creatLabel(Session session, int boardId, String token,
      String title, String color) async {
    // validate token(get current user)
    final currentUser = await TokenEndpoint().validateToken(session, token);
    if (currentUser == null || currentUser.id == null) {
      throw Exception('No user or invalid token!');
    }

    // make sure the board exists
    final board = await Board.db.findById(session, boardId);
    if (board == null) {
      throw Exception('No board found!');
    }

    // check member is a user of that board
    final membership = await BoardMember.db.findFirstRow(
      session,
      where: (m) => m.board.equals(boardId) & m.user.equals(currentUser.id!),
    );
    if (membership == null) {
      throw Exception('You are not a member of this board!');
    }

    // Trim & validate name / color
    final trimmedTitle = title.trim();
    final trimmedColor = color.trim();
    if (trimmedTitle.isEmpty) throw Exception('Label name cannot be empty!');
    // Very simple hex‑color check (#RRGGBB)
    final hexRegex = RegExp(r'^#[0-9A-Fa-f]{6}$');
    if (!hexRegex.hasMatch(trimmedColor)) {
      throw Exception('Color must be a hex value like #FF0000');
    }

    // check duplicate label name on the same board
    final duplicate = await Label.db.findFirstRow(
      session,
      where: (l) => l.board.equals(boardId) & l.name.equals(trimmedTitle),
    );
    if (duplicate != null) {
      throw Exception('A label with that title already exists!');
    }

    // create and insert label
    final label = Label(
        name: trimmedTitle,
        color: trimmedColor,
        board: boardId,
        createdBy: currentUser.id!);

    await Label.db.insertRow(session, label);
    return label;
  }

  // get all labels for a board
  Future<List<Label>> getLabelsForBoard(
      Session session, int boardId, String token) async {
    // validate token(get current user)
    final currentUser = await TokenEndpoint().validateToken(session, token);
    if (currentUser == null || currentUser.id == null) {
      throw Exception('No user or invalid token!');
    }

    // make sure the board exists
    final board = await Board.db.findById(session, boardId);
    if (board == null) {
      throw Exception('No board found!');
    }

    // member ship check
    final memberShip = await BoardMember.db.findFirstRow(
      session,
      where: (m) => m.board.equals(boardId) & m.user.equals(currentUser.id!),
    );
    if (memberShip == null) {
      throw Exception('You are not a member of the parent board!');
    }

    // fetch all label
    final labels = await Label.db.find(
      session,
      where: (l) => l.board.equals(boardId),
      orderBy: (l) => l.name,
    );

    return labels;
  }

  // update a label (name or color)
  Future<Label> updateLable(Session session, int labelId, String token,
      {String? newTitle, String? newColor}) async {
    // validate token(get current user)
    final currentUser = await TokenEndpoint().validateToken(session, token);
    if (currentUser == null || currentUser.id == null) {
      throw Exception('No user or invalid token!');
    }

    // fetch the label by labelID
    final label = await Label.db.findById(session, labelId);
    if (label == null) {
      throw Exception('No label found!');
    }

    // confirm the user is a member of label's board
    final member = await BoardMember.db.findFirstRow(
      session,
      where: (l) =>
          l.board.equals(label.board) & l.user.equals(currentUser.id!),
    );
    if (member == null) {
      throw Exception('You are not a member of parent board!');
    }

    // validate new values
    if (newTitle != null) {
      final name = newTitle.trim();
      if (name.isEmpty) {
        throw Exception("Label titles can't be empty");
      }

      final duplicate = await Label.db.findFirstRow(
        session,
        where: (l) =>
            l.board.equals(label.board) &
            l.name.equals(name) &
            l.id.notEquals(labelId),
      );
      if (duplicate != null) {
        throw Exception('A label with that title already exists!');
      }

      label.name = name;
    }

    if (newColor != null) {
      final color = newColor.trim();
      final hex = RegExp(r'^#[0-9A-Fa-f]{6}$');
      if (!hex.hasMatch(color)) throw Exception('Color must be #RRGGBB');
      label.color = color;
    }

    await Label.db.updateRow(session, label);
    return label;
  }

  // delete a lable
  Future<bool> deleteLable(Session session, int labelId, String token) async {
    // validate token(get current user)
    final currentUser = await TokenEndpoint().validateToken(session, token);
    if (currentUser == null || currentUser.id == null) {
      throw Exception('No user or invalid token!');
    }

    // fetch label by id
    final label = await Label.db.findById(session, labelId);
    if (label == null) {
      throw Exception('No label found!');
    }

    // check membership in the parent board
    final membership = await BoardMember.db.findFirstRow(
      session,
      where: (b) =>
          b.board.equals(label.board) & b.user.equals(currentUser.id!),
    );
    if (membership == null) {
      throw Exception('You are not a member of the parent board!');
    }

    final isOwnerOrAdmin =
        membership.role == 'Owner' || membership.role == 'Admin';

    final isCreator = label.createdBy == currentUser.id!;

    if (!isOwnerOrAdmin && !isCreator) {
      throw Exception(
          'Only owners, admins, or the label creator can delete it!');
    }

    // check if the label is in use
    final inUse = await CardLabel.db.findFirstRow(
      session,
      where: (l) => l.label.equals(labelId),
    );
    if (inUse != null) {
      throw Exception('Label is still assigned to one or more cards!');
    }

    await Label.db.deleteRow(session, label);
    return true;
  }
}

 /*

  Add later:

      🧩 getLabelById(...)
        Get a specific label’s full data by ID.
        Useful for editing or viewing label details in the UI.

      🔄 duplicateLabel(...)
        Copy a label from one board to another.
        Might be useful if your app allows label templates.

      🎨 getPopularLabelColors(...)
        Get most-used label colors on a board to suggest new ones.

      🧼 cleanUnusedLabels(...)
        Auto-delete all labels not assigned to any card.
        Nice admin/owner-only feature.

      📝 searchLabels(...)
        Filter labels by name or color (for large boards with many labels).

      📊 getLabelUsageStats(...)
        Return how many times each label is used on cards.
       Useful for showing graphs or managing labels efficiently.
 
 */
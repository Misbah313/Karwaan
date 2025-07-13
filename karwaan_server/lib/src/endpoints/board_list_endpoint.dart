import 'package:karwaan_server/src/endpoints/token_endpoint.dart';
import 'package:karwaan_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart';

class BoardListEndpoint extends Endpoint {
  // create board list
  Future<BoardList> createBoardList(
      Session session, int boardId, String token, String title) async {
    // validate user(get the current user)
    final currentUser = await TokenEndpoint().validateToken(session, token);
    if (currentUser == null || currentUser.id == null) {
      throw Exception('Invalid user or expired token!!');
    }

    // make sure the board exists
    final board = await Board.db.findById(session, boardId);
    if (board == null) {
      throw Exception('No board exists!');
    }

    // confirm the user is a member of that board
    final member = await BoardMember.db.findFirstRow(
      session,
      where: (m) => m.board.equals(boardId) & m.user.equals(currentUser.id!),
    );
    if (member == null) {
      throw Exception('You are not member!!');
    }

    // trim and make sure the title is not empty
    final trimmedTitle = title.trim();
    if (trimmedTitle.isEmpty) {
      throw Exception("List title can't be empty!!");
    }

    // make sure there is no duplicated title name
    final duplicated = await BoardList.db.findFirstRow(
      session,
      where: (d) => d.board.equals(boardId) & d.title.equals(trimmedTitle),
    );
    if (duplicated != null) {
      throw Exception('A ListBoard with that title already exists!!');
    }

    // insert the new board list
    final newList = BoardList(
        board: boardId,
        title: trimmedTitle,
        createdAt: DateTime.now(),
        createdBy: currentUser.id!);

    await BoardList.db.insertRow(session, newList);

    return newList;
  }

  // get board list
  Future<List<BoardList>> listBoardLists(
      Session session, int boardId, String token) async {
    // validate the token(get the current user)
    final currentUser = await TokenEndpoint().validateToken(session, token);
    if (currentUser == null || currentUser.id == null) {
      throw Exception('Invalid user or expired token');
    }

    // make sure the board exists
    final board = await Board.db.findById(session, boardId);
    if (board == null) {
      throw Exception('Board not found!!');
    }

    // check if the user is a member of the board
    final member = await BoardMember.db.findFirstRow(
      session,
      where: (m) => m.board.equals(boardId) & m.user.equals(currentUser.id!),
    );
    if (member == null) {
      throw Exception('You are not a member of the board!!');
    }

    // fetch all lists belonging to the board
    final lists = await BoardList.db.find(
      session,
      where: (l) => l.board.equals(boardId),
      orderBy: (c) => c.createdAt,
    );

    return lists;
  }

  // update board list
  Future<BoardList> updateBoardList(
      Session session, int listId, String token, String newTitle) async {
    // validate token(get user)
    final currentUser = await TokenEndpoint().validateToken(session, token);
    if (currentUser == null || currentUser.id == null) {
      throw Exception('Invalid user or expired token!!');
    }

    // find boardLIst by id
    final boardList = await BoardList.db.findById(session, listId);
    if (boardList == null) {
      throw Exception('No board list has been found!');
    }

    // check the current user membership
    final member = await BoardMember.db.findFirstRow(
      session,
      where: (m) =>
          m.board.equals(boardList.board) & m.user.equals(currentUser.id!),
    );
    if (member == null) {
      throw Exception('You are not a member of this board!');
    }

    // validate the new title
    final trimmedNewTitle = newTitle.trim();
    if (trimmedNewTitle.isEmpty) {
      throw Exception('Title cannot be empty!');
    }

    // check for duplicated title within the same board
    final duplicated = await BoardList.db.findFirstRow(
      session,
      where: (b) =>
          b.board.equals(boardList.board) &
          b.title.equals(trimmedNewTitle) &
          b.id.notEquals(listId),
    );
    if (duplicated != null) {
      throw Exception(
          'Another list with that title already exists in the board!');
    }

    boardList.title = trimmedNewTitle;

    // save and insert the upated row
    await BoardList.db.updateRow(session, boardList);

    return boardList;
  }

  // delete board list
  Future<bool> deleteBoardList(
      Session session, int listId, String token) async {
    // validate token(get user)
    final currentUser = await TokenEndpoint().validateToken(session, token);
    if (currentUser == null || currentUser.id == null) {
      throw Exception('Invalid user or expired token!');
    }

    // find boardList by listId
    final boardList = await BoardList.db.findById(session, listId);
    if (boardList == null) {
      throw Exception('No board found!');
    }

    // check user membership to that board
    final member = await BoardMember.db.findFirstRow(
      session,
      where: (m) =>
          m.board.equals(boardList.board) & m.user.equals(currentUser.id!),
    );
    if (member == null) {
      throw Exception('You are not a member to that board!');
    }
    if (member.role != 'Owner' && member.role != 'Admin') {
      throw Exception('Only owner and admin can delete the board list!');
    }

    //
    await BoardList.db.deleteRow(session, boardList);

    return true;
  }
}
   
   /*

     Add later:
         
       - Reorder Board Lists:
          Allow users to drag & drop board lists to change their order. Save the order in the database (e.g., add an order or position field) and fetch lists sorted by this field.

       - Archive Board Lists:
          Implement soft-delete by adding an isArchived flag. Allow users to archive and restore lists instead of deleting permanently.

       - Move Board Lists Between Boards:
          Enable moving a list from one board to another, with permission checks on the destination board.

       - Add Permissions per Board List:
          Set fine-grained permissions so specific users can view or edit particular lists.

       - Assign Labels or Tags to Lists:
          Allow adding labels/tags to categorize and filter lists.

       - List Descriptions or Notes:
          Add a description field to lists for extra context or instructions.

       - Activity Log / History:
          Track changes made to lists (edits, reorderings, archives) for audit and collaboration.

       - Notification Support:
          Send notifications when lists are created, updated, or archived.

       - Due Dates or Timelines:
          Add due dates to lists with reminders or visual indicators.

       - List Templates / Cloning:
          Allow duplicating lists for recurring workflows.
   
   
   */
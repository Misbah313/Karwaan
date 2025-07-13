import 'package:karwaan_server/src/endpoints/token_endpoint.dart';
import 'package:karwaan_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart';

class CardEndpoint extends Endpoint {
  // create card
  Future<Card> createCard(
      Session session, int boardListId, String token, String title,
      {String? dec}) async {
    // validate token(get current user)
    final currentUser = await TokenEndpoint().validateToken(session, token);
    if (currentUser == null || currentUser.id == null) {
      throw Exception('No user or expired token!');
    }

    // check if the boadlist you want to the card to actually exists
    final boardList = await BoardList.db.findById(session, boardListId);
    if (boardList == null) {
      throw Exception('No BoardList exists!');
    }

    // validate card data
    final trimmedTitle = title.trim();
    if (trimmedTitle.isEmpty) {
      throw Exception('Card title cannot be empty!');
    }

    // set the required fields and create the card obj
    final card = Card(
      title: trimmedTitle,
      createdBy: currentUser.id!,
      description: dec?.trim(),
      list: boardListId,
      createdAt: DateTime.now(),
      isCompleted: false,
    );

    // insert the created card into the db
    final insertedCard = await Card.db.insertRow(session, card);
    return insertedCard;
  }

  // get cards by list
  Future<List<Card>> getListByCard(
      Session session, int boardListId, String token) async {
    // validate token(get current user)
    final currentUser = await TokenEndpoint().validateToken(session, token);
    if (currentUser == null || currentUser.id == null) {
      throw Exception('No user or invalid token!');
    }

    // validate the board list exist
    final boardList = await BoardList.db.findById(session, boardListId);
    if (boardList == null) {
      throw Exception('No BoardList exists!');
    }

    // check user permission
    // make sure the current user is a member of the board that contains this board list
    final membership = await BoardMember.db.findFirstRow(
      session,
      where: (b) =>
          b.board.equals(boardList.board) & b.user.equals(currentUser.id!),
    );
    if (membership == null) {
      throw Exception('You are not a member of the parent board!');
    }

    // Query all cards linked to this board list
    // fetch all card
    final fetch = await Card.db.find(
      session,
      where: (c) => c.list.equals(boardListId),
      orderBy: (c) => c.createdAt,
    );

    return fetch;
  }

  // upadate cards
  Future<Card> updateCard(Session session, int cardId, String token,
      String newTitle, String? newDec, bool? completed) async {
    // validate token(get current user)
    final currentUser = await TokenEndpoint().validateToken(session, token);
    if (currentUser == null || currentUser.id == null) {
      throw Exception('No user or expired token!');
    }

    // fetch card by card id
    final card = await Card.db.findById(session, cardId);
    if (card == null) {
      throw Exception('No card found!');
    }

    // check user permission
    // Fetch the board/list that the card belongs to
    final boardList = await BoardList.db.findById(
      session,
      card.list,
    );
    if (boardList == null) {
      throw Exception('No BoardList!');
    }

    // Confirm the user is a member of the parent board
    final membership = await BoardMember.db.findFirstRow(
      session,
      where: (b) =>
          b.board.equals(boardList.board) & b.user.equals(currentUser.id!),
    );
    if (membership == null) {
      throw Exception('You are not a member of the parent board!');
    }

    // validate the updated data

    // make sure title is not empty
    final trimmedTitle = newTitle.trim();
    if (trimmedTitle.isEmpty) {
      throw Exception('Card title cannot be empty!');
    }

    card.title = trimmedTitle;

    // validate other fields
    if (newDec != null) {
      card.description = newDec.trim();
    }
    if (completed != null) {
      card.isCompleted = completed;
    }

    // save the changes
    await Card.db.updateRow(session, card);
    return card;
  }

  // delete cards
  Future<bool> deleteCard(Session session, int cardId, String token) async {
    // validate token(get current user)
    final currentUser = await TokenEndpoint().validateToken(session, token);
    if (currentUser == null || currentUser.id == null) {
      throw Exception('No user or invalid token!');
    }

    // fetch card by card id
    final card = await Card.db.findById(session, cardId);
    if (card == null) {
      throw Exception('No card found!');
    }

    // check user permission
    // Fetch the board list the card belongs to
    final boardList = await BoardList.db.findById(session, card.list);
    if (boardList == null) {
      throw Exception('No board list found!');
    }

    // Check if the user is a member of the parent board
    final membership = await BoardMember.db.findFirstRow(
      session,
      where: (m) =>
          m.board.equals(boardList.board) & m.user.equals(currentUser.id!),
    );
    if (membership == null) {
      throw Exception('You are not a member of the parent board!');
    }

    // check if the user role allow deleting
    if (membership.role == 'Owner' ||
        membership.role == 'Admin' ||
        card.createdBy == currentUser.id!) {
      // allow deletion

      await Card.db.deleteRow(session, card);
      return true;
    } else {
      throw Exception("You don't have the permission to delete this card!");
    }
  }
}

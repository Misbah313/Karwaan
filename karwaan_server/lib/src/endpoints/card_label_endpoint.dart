import 'package:karwaan_server/src/endpoints/token_endpoint.dart';
import 'package:karwaan_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart';

class CardLabelEndpoint extends Endpoint {
  // assgin label to card
  Future<CardLabel> assignLableToCard(
      Session session, int labelId, int cardId, String token) async {
    // validate token(get current user)
    final currentUser = await TokenEndpoint().validateToken(session, token);
    if (currentUser == null || currentUser.id == null) {
      throw Exception('No user or invalid token!');
    }

    // validate card and label exist
    final validateCard = await Card.db.findById(session, cardId);
    final validateLabel = await Label.db.findById(session, labelId);
    if (validateCard == null || validateLabel == null) {
      throw Exception('No cards and label found!');
    }

    // check user permmision on parrent board
    final list = await BoardList.db.findById(session, validateCard.list);
    if (list == null) {
      throw Exception('Parent list not found');
    }

    final membership = await BoardMember.db.findFirstRow(
      session,
      where: (l) => l.board.equals(list.board) & l.user.equals(currentUser.id!),
    );
    if (membership == null) {
      throw Exception('You are not a member of the parent board!');
    }

    // avoid duplicated assigns
    final duplicate = await CardLabel.db.findFirstRow(
      session,
      where: (c) => c.card.equals(cardId) & c.label.equals(labelId),
    );
    if (duplicate != null) {
      throw Exception('Label already assigned to this card!');
    }

    // insert the label
    final link = CardLabel(card: cardId, label: labelId);
    await CardLabel.db.insertRow(session, link);
    return link;
  }

  // remove label from card
  Future<void> removeLabelFromCard(
      Session session, int cardId, int labelId, String token) async {
    // validate token(get current user)
    final currentUser = await TokenEndpoint().validateToken(session, token);
    if (currentUser == null || currentUser.id == null) {
      throw Exception('No user or invalid token!');
    }

    // fetch card label link by (card id , label id)
    final fetched = await CardLabel.db.findFirstRow(
      session,
      where: (c) => c.card.equals(cardId) & c.label.equals(labelId),
    );
    if (fetched == null) {
      throw Exception('Label not assigned');
    }

    // fetch the card
    final card = await Card.db.findById(session, fetched.card);
    if (card == null) {
      throw Exception('No card found!');
    }

    // fetch the list to get the board id
    final boardlist = await BoardList.db.findById(session, card.list);
    if (boardlist == null) {
      throw Exception('BoardList not found!');
    }

    // membership check
    final member = await BoardMember.db.findFirstRow(
      session,
      where: (b) =>
          b.board.equals(boardlist.board) & b.user.equals(currentUser.id!),
    );
    if (member == null) {
      throw Exception('You are not a member of the parent board!');
    }

    // delete
    await CardLabel.db.deleteRow(session, fetched);
  }

  // get labels for card
  Future<List<Label>> getLabelForCard(
      Session session, int cardId, String token) async {
    final currentUser = await TokenEndpoint().validateToken(session, token);
    if (currentUser == null) {
      throw Exception('No user or invalid token!');
    }

    // fetch the card
    final card = await Card.db.findById(session, cardId);
    if (card == null) throw Exception('Card not found!');

    // fetch board list to get the board
    final boardList = await BoardList.db.findById(session, card.list);
    if (boardList == null) throw Exception('BoardList not found!');

    // check membership
    final member = await BoardMember.db.findFirstRow(
      session,
      where: (m) =>
          m.board.equals(boardList.board) & m.user.equals(currentUser.id!),
    );
    if (member == null) {
      throw Exception('You are not a member of the parent board!');
    }

    // fetch links
    final links = await CardLabel.db.find(
      session,
      where: (c) => c.card.equals(cardId),
    );
    if (links.isEmpty) return [];

    // fetch labels
    final labelIds = links.map((e) => e.label).toSet();
    final labels = await Label.db.find(
      session,
      where: (l) => l.id.inSet(labelIds),
      orderBy: (l) => l.name,
    );
    return labels;
  }

  // get cards for label
  Future<List<Card>> getCardForLabel(
      Session session, int labelId, String token) async {
    final currentUser = await TokenEndpoint().validateToken(session, token);
    if (currentUser == null || currentUser.id == null) {
      throw Exception('No user or invalid token!');
    }

    // fetch label
    final label = await Label.db.findById(session, labelId);
    if (label == null) {
      throw Exception('Lable not found!');
    }

    // check user is a member of the parent baord
    final member = await BoardMember.db.findFirstRow(
      session,
      where: (m) =>
          m.board.equals(label.board) & m.user.equals(currentUser.id!),
    );
    if (member == null) {
      throw Exception('You are not a member of the parent board!');
    }

    // get all card label with this label id
    final cardLabel = await CardLabel.db.find(
      session,
      where: (c) => c.label.equals(labelId),
    );

    // extract card ids
    final extracted = cardLabel.map((e) => e.card).toSet();

    // fetch cards
    final cards = await Card.db.find(
      session,
      where: (c) => c.id.inSet(extracted),
    );
    return cards;
  }
}


 /*

   Add later:
       // ✅ Bulk assign multiple labels to a card
        Future<void> bulkAssignLabelsToCard(Session session, int cardId, List<int> labelIds, String token) async {
       // TODO: Loop through labelIds and reuse assignLabelToCard logic with validation
      }

       // ✅ Bulk remove multiple labels from a card
         Future<void> bulkRemoveLabelsFromCard(Session session, int cardId, List<int> labelIds, String token) async {
       // TODO: Loop through labelIds and reuse removeLabelFromCard logic
      }

       // ✅ Replace all labels on a card
        Future<void> replaceLabelsOnCard(Session session, int cardId, List<int> newLabelIds, String token) async {
       // TODO: Remove all existing CardLabel entries for cardId, then assign new ones
      }

       // ✅ Get how many cards use each label on a board
        Future<Map<int, int>> getLabelUsageCounts(Session session, int boardId, String token) async {
       // TODO: Count how many CardLabel rows exist for each label in the given board
      }

       // ✅ Get cards that match multiple labels (AND / OR)
        Future<List<Card>> getCardsForMultipleLabels(Session session, List<int> labelIds, String token, {bool matchAll = false}) async {
       // TODO: If matchAll is true, return cards that have all labels, else any label
      }

       // ✅ Toggle label on card (add if missing, remove if exists)
        Future<void> toggleLabel(Session session, int cardId, int labelId, String token) async {
       // TODO: If exists → delete, else → insert
      }

       // ✅ Get audit log for label (optional: store changes in a log table)
        Future<List<LabelAuditLog>> getLabelAuditLog(Session session, int labelId, String token) async {
       // TODO: Return audit history if you're storing label assign/unassign events
      }

       // ✅ Paginated version of getCardsForLabel
         Future<List<Card>> getCardsForLabelPaged(Session session, int labelId, String token, {int limit = 20, int offset = 0}) async {
       // TODO: Same as getCardsForLabel but include limit and offset
      }

       // ✅ Paginated version of getLabelForCard
        Future<List<Label>> getLabelForCardPaged(Session session, int cardId, String token, {int limit = 20, int offset = 0}) async {
       // TODO: Same as getLabelForCard but paginated
      }

 */
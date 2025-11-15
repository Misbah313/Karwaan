import 'package:karwaan_flutter/domain/models/board/board.dart';
import 'package:karwaan_flutter/domain/models/boardcard/board_card.dart';
import 'package:karwaan_flutter/domain/repository/board/board_repo.dart';
import 'package:karwaan_flutter/domain/repository/boardcard/boardcard_repo.dart';

class SearchUseCase {
  final BoardRepo boardRepo;
  final BoardcardRepo boardcardRepo;

  SearchUseCase({required this.boardRepo, required this.boardcardRepo});

  Future<({List<Board> boards, List<BoardCard> cards})> execute(
      String query) async {
    final boards = await boardRepo.getUserBoards();
    final cards = await boardcardRepo.getAllUserCards();

    final filteredBoards = boards.where((board) {
      return board.boardName.toLowerCase().contains(query.toLowerCase()) ||
          board.boardDescription.toLowerCase().contains(query.toLowerCase());
    }).toList();

    final filteredCards = cards.where((card) {
      return card.title.toLowerCase().contains(query.toLowerCase()) ||
          card.description.toLowerCase().contains(query.toLowerCase());
    }).toList();

    return (boards: filteredBoards, cards: filteredCards);
  }
}

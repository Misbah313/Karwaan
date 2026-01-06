import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:karwaan_flutter/core/utils/search_function/search_use_case.dart';
import 'package:karwaan_flutter/domain/models/board/board.dart';
import 'package:karwaan_flutter/domain/models/boardcard/board_card.dart';

class SearchCubit extends Cubit<SearchState> {
  final SearchUseCase searchUseCase;

  SearchCubit(this.searchUseCase) : super(SearchInitial());

  Future<void> search(String query) async {
    if (query.isEmpty) return;

    emit(SearchLoading());

    try {
      final results = await searchUseCase.execute(query);
      emit(SearchLoaded(results.boards, results.cards));
    } catch (e) {
      emit(SearchError(e.toString()));
    }
  }

  void clearSearch() {
    emit(SearchInitial());
  }
}

abstract class SearchState {}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchLoaded extends SearchState {
  final List<Board> boards;
  final List<BoardCard> cards;

  SearchLoaded(this.boards, this.cards);
}

class SearchError extends SearchState {
  final String message;
  SearchError(this.message);
}

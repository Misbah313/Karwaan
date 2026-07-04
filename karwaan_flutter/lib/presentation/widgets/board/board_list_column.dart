import 'package:flutter/material.dart';
import 'package:karwaan_flutter/domain/models/board/board_member_details.dart';
import 'package:karwaan_flutter/domain/models/boardcard/board_card_state.dart';
import 'package:karwaan_flutter/domain/models/boardlist/boardlist.dart';
import 'package:karwaan_flutter/domain/repository/boardcard/boardcard_repo.dart';
import 'package:karwaan_flutter/presentation/cubits/board/board_member_cubit.dart';
import 'package:karwaan_flutter/presentation/cubits/boardcard/board_card_cubit.dart';
import 'package:karwaan_flutter/presentation/cubits/boardcard/card_assignee_cubit.dart';
import 'package:karwaan_flutter/presentation/cubits/boardlist/boardlist_cubit.dart';
import 'package:karwaan_flutter/presentation/cubits/comment/comment_cubit.dart';
import 'package:karwaan_flutter/presentation/cubits/label/label_cubit.dart';
import 'package:karwaan_flutter/presentation/widgets/board/list_header.dart';
import 'package:karwaan_flutter/presentation/widgets/board/list_cards_view.dart';
import 'package:karwaan_flutter/presentation/widgets/cards/create_card_dialog.dart';

class BoardListColumn extends StatefulWidget {
  final Boardlist list;
  final int boardId;
  final BoardcardRepo boardcardRepo;
  final Map<int, BoardCardCubit> cardCubits;
  final BoardlistCubit boardlistCubit;
  final BoardMemberCubit memberCubit;
  final LabelCubit labelCubit;
  final List<BoardMemberDetails> boardMembers;
  final CommentCubit commentCubit;
  final CardAssigneeCubit cardAssigneeCubit;
  const BoardListColumn(
      {super.key,
      required this.list,
      required this.boardId,
      required this.boardcardRepo,
      required this.cardCubits,
      required this.boardlistCubit,
      required this.memberCubit,
      required this.labelCubit,
      required this.boardMembers,
      required this.commentCubit, required this.cardAssigneeCubit});

  @override
  State<BoardListColumn> createState() => _BoardListColumnState();
}

class _BoardListColumnState extends State<BoardListColumn> {
  late final BoardCardCubit _cardCubit;

  @override
  void initState() {
    super.initState();
    _cardCubit = widget.cardCubits.putIfAbsent(
      widget.list.id,
      () => BoardCardCubit(widget.boardcardRepo),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_cardCubit.state is! BoardCardListLoaded) {
        _cardCubit.getListByBoardCard(widget.list.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.white.withAlpha(13)
            : Colors.black.withAlpha(5),
        border:
            Border.all(color: Theme.of(context).dividerColor.withAlpha(102)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListHeader(
            list: widget.list,
            boardId: widget.boardId,
            boardlistCubit: widget.boardlistCubit,
          ),
          Expanded(
            child: ListCardsView(
              listId: widget.list.id,
              boardId: widget.boardId,
              cardCubit: _cardCubit,
              boardcardRepo: widget.boardcardRepo,
              boardMembers: widget.boardMembers,
              commentCubit: widget.commentCubit,
              cardAssigneeCubit: widget.cardAssigneeCubit,
            ),
          ),
          _buildAddButton(),
        ],
      ),
    );
  }

  Widget _buildAddButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: Theme.of(context).dividerColor),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
          onPressed: _showCreateCardDialog,
          icon: Icon(
            Icons.add,
            color: Theme.of(context).iconTheme.color,
          ),
          label: Text(
            'Add card',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
      ),
    );
  }

  void _showCreateCardDialog() {
    // Implement create card dialog
    showDialog(
      context: context,
      builder: (context) => CreateCardDialog(
        boardId: widget.boardId,
        cardCubit: _cardCubit,
        listId: widget.list.id,
        memberCubit: widget.memberCubit,
        labelCubit: widget.labelCubit,
        boardMembers: widget.boardMembers,
      ),
    );
  }
}

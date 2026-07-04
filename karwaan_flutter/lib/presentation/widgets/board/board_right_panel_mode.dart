import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:karwaan_flutter/core/services/board/board_member_dialog_service.dart';
import 'package:karwaan_flutter/core/services/workspace/workspace_member/member_service.dart';
import 'package:karwaan_flutter/core/utils/search_function/search_cubit.dart';
import 'package:karwaan_flutter/core/utils/search_function/search_service.dart';
import 'package:karwaan_flutter/domain/models/auth/auth_user.dart';
import 'package:karwaan_flutter/domain/models/board/board_wrapper.dart';
import 'package:karwaan_flutter/presentation/cubits/board/board_member_cubit.dart';
import 'package:karwaan_flutter/presentation/cubits/label/label_cubit.dart';
import 'package:karwaan_flutter/presentation/pages/desktop/board/board_label_section.dart';
import 'package:karwaan_flutter/presentation/pages/desktop/board/board_member_section.dart';
import 'package:karwaan_flutter/presentation/widgets/board/board_chat.dart';
import 'package:karwaan_flutter/presentation/widgets/board/board_search_panel.dart';

class BoardRightPanelMode extends StatefulWidget {
  final AuthUser user;
  final BoardWrapper board;
  final int boardId;
  final LabelCubit labelCubit;
  const BoardRightPanelMode(
      {super.key,
      required this.user,
      required this.board,
      required this.boardId,
      required this.labelCubit});

  @override
  State<BoardRightPanelMode> createState() => _BoardRightPanelModeState();
}

enum RightPanelMode { chat, members, labels, filter }

class _BoardRightPanelModeState extends State<BoardRightPanelMode> {
  final TextEditingController searchController = TextEditingController();
  final SearchService _searchService = SearchService();

  RightPanelMode _mode = RightPanelMode.chat;
  bool _isVisible = true;

  @override
  void dispose() {
    searchController.dispose();
    _searchService.dispose();
    super.dispose();
  }

  void changeMode(RightPanelMode mode) {
    setState(() {
      _mode = mode;
      _isVisible = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedPositioned(
          duration: const Duration(milliseconds: 300),
          left: _isVisible ? 0 : -400,
          top: 0,
          bottom: 0,
          child: SizedBox(
            width: 400,
            child: _buildContent(),
          ),
        ),
        AnimatedPositioned(
          duration: const Duration(milliseconds: 300),
          left: _isVisible ? 385 : 0,
          top: 0,
          bottom: 0,
          child: _buildPanelTab(),
        ),
      ],
    );
  }

  Widget _buildContent() {
    switch (_mode) {
      case RightPanelMode.chat:
        BoardChat();
      case RightPanelMode.members:
        return BoardMemberSection(
          boardId: widget.boardId,
          memberCubit: context.read<BoardMemberCubit>(),
          dialogService: BoardMemberDialogServiceImpl(),
          memberService: MemberService(),
          currentUserEmail: widget.user.email,
        );

      case RightPanelMode.labels:
        return BoardLabelSection(
          boardId: widget.board.id,
          labelCubit: widget.labelCubit,
        );

      case RightPanelMode.filter:
        return _buildSearchPanel();
    }

    return Container();
  }

  Widget _buildSearchPanel() {
    return Column(
      children: [
        TextField(
          controller: searchController,
          onChanged: (value) {
            _searchService.debounceSearch(
              query: value,
              duration: const Duration(seconds: 2),
              onSearch: (q) => context.read<SearchCubit>().search(q),
            );
          },
        ),
        Expanded(
          child: BlocBuilder<SearchCubit, SearchState>(
            builder: (context, state) {
              if (state is SearchLoaded) {
                return BoardSearchPanel(
                  query: searchController.text,
                  boards: state.boards,
                  cards: state.cards,
                  onClose: () {},
                );
              }
              return const SizedBox();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPanelTab() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isVisible = !_isVisible;
        });
      },
      child: Container(
        width: 20,
        color: Colors.transparent,
      ),
    );
  }
}

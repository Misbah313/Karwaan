import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:karwaan_flutter/core/services/board/board_member_dialog_service.dart';
import 'package:karwaan_flutter/core/services/client/profile_image_service.dart';
import 'package:karwaan_flutter/core/services/workspace/workspace_member/member_service.dart';
import 'package:karwaan_flutter/core/utils/search_function/search_cubit.dart';
import 'package:karwaan_flutter/core/utils/search_function/search_service.dart';
import 'package:karwaan_flutter/domain/models/auth/auth_user.dart';
import 'package:karwaan_flutter/domain/models/board/board_member_details.dart';
import 'package:karwaan_flutter/domain/models/board/board_member_state.dart';
import 'package:karwaan_flutter/domain/models/board/board_wrapper.dart';
import 'package:karwaan_flutter/domain/models/boardlist/boardlist.dart';
import 'package:karwaan_flutter/domain/models/boardlist/boardlist_state.dart';
import 'package:karwaan_flutter/domain/repository/boardcard/boardcard_repo.dart';
import 'package:karwaan_flutter/presentation/cubits/board/board_member_cubit.dart';
import 'package:karwaan_flutter/presentation/cubits/boardcard/board_card_cubit.dart';
import 'package:karwaan_flutter/presentation/cubits/boardcard/card_assignee_cubit.dart';
import 'package:karwaan_flutter/presentation/cubits/boardlist/boardlist_cubit.dart';
import 'package:karwaan_flutter/presentation/cubits/comment/comment_cubit.dart';
import 'package:karwaan_flutter/presentation/cubits/label/label_cubit.dart';
import 'package:karwaan_flutter/presentation/pages/desktop/board/board_label_section.dart';
import 'package:karwaan_flutter/presentation/pages/desktop/board/board_member_section.dart';
import 'package:karwaan_flutter/presentation/pages/desktop/board_list/desk_boardlist_header.dart';
import 'package:karwaan_flutter/presentation/widgets/board/board_chat.dart';
import 'package:karwaan_flutter/presentation/widgets/board/board_list_column.dart';
import 'package:karwaan_flutter/presentation/widgets/board/board_search_panel.dart';
import 'package:karwaan_flutter/presentation/widgets/profile_avatar.dart';
import 'package:karwaan_flutter/presentation/widgets/utils/textfield.dart';
import 'package:lottie/lottie.dart';

class DeskBoardlist extends StatefulWidget {
  final AuthUser user;
  final ProfileImageService imageService;
  final BoardWrapper board;
  final BoardcardRepo boardcardRepo;
  final int boardId;
  final LabelCubit labelCubit;
  final CommentCubit commentCubit;
  final CardAssigneeCubit cardAssigneeCubit;
  const DeskBoardlist(
      {super.key,
      required this.user,
      required this.imageService,
      required this.board,
      required this.boardId,
      required this.boardcardRepo,
      required this.labelCubit,
      required this.commentCubit,
      required this.cardAssigneeCubit});

  @override
  State<DeskBoardlist> createState() => _DeskBoardlistState();
}

enum RightPanelMode { chat, members, labels, filter }

class _DeskBoardlistState extends State<DeskBoardlist> {
  final TextEditingController searchController = TextEditingController();
  final SearchService _searchService = SearchService();
  List<Boardlist>? _cacheBoardLists;
  final Map<int, BoardCardCubit> _cardCubit = {};
  final ScrollController _listController = ScrollController();

  static const double _rightPanelWidth = 400;
  static const int _panelAnimationDurationMs = 300;
  static const double _boardHeightFactor = 0.85;
  static const double _boardWidthFactor = 0.72;

  RightPanelMode _rightPanelMode = RightPanelMode.chat;
  bool _isRightPanelVisible = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BoardlistCubit>().listBoardLists(widget.boardId);
      context.read<BoardMemberCubit>().getBoardMembers(widget.boardId);
    });
  }

  void _onSearchChange(String value) {
    _searchService.debounceSearch(
      query: value,
      duration: const Duration(seconds: 2),
      onSearch: _performSearch,
    );
  }

  void _performSearch(String query) {
    context.read<SearchCubit>().search(query);
  }

  @override
  void dispose() {
    _searchService.dispose();
    searchController.dispose();
    for (final c in _cardCubit.values) {
      c.close();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              _buildHeader(),
              const SizedBox(height: 15),
              Stack(
                children: [
                  Row(
                    children: [
                      AnimatedContainer(
                        duration:
                            Duration(milliseconds: _panelAnimationDurationMs),
                        width: _isRightPanelVisible ? _rightPanelWidth + 5 : 0,
                      ),
                      // board page content
                      _buildBoardContainer()
                    ],
                  ),
                  const SizedBox(width: 5),
                  // rigt panel
                  AnimatedPositioned(
                    duration:
                        const Duration(milliseconds: _panelAnimationDurationMs),
                    left: _isRightPanelVisible ? 0 : -_rightPanelWidth,
                    top: 0,
                    bottom: 0,
                    child: SizedBox(
                      width: _rightPanelWidth,
                      child: _buildRightPanelContent(),
                    ),
                  ),
                  // right panel tab
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 300),
                    left: _isRightPanelVisible ? _rightPanelWidth - 15 : 0,
                    top: 0,
                    bottom: 0,
                    child: _buildPanelTab(),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  // board page
  Widget _buildBoardContainer() {
    return Expanded(
      child: Container(
        height: MediaQuery.of(context).size.height * _boardHeightFactor,
        width: MediaQuery.of(context).size.width * _boardWidthFactor,
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).dividerColor.withValues(alpha: 0.4),
          ),
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.black.withValues(alpha: 0.05)
              : Colors.white.withValues(alpha: 0.05),
        ),
        child: Column(
          children: [
            DeskBoardlistHeader(
              board: widget.board,
              dialogService: BoardMemberDialogServiceImpl(),
              memberCubit: context.read<BoardMemberCubit>(),
              labelCubit: widget.labelCubit,
              onPanelChanged: (mode) {
                setState(() {
                  _rightPanelMode = mode;
                  _isRightPanelVisible = true;
                });
              },
              currentPanelMode: _rightPanelMode,
            ),
            _buildBoardArea(),
            _buildScrollTrack(),
          ],
        ),
      ),
    );
  }

  // board page area
  Widget _buildBoardArea() {
    return Expanded(
      child: BlocBuilder<BoardlistCubit, BoardlistState>(
        builder: (context, state) {
          if (state is BoardlistLoading || state is BoardlistInitial) {
            return _boardlistLoadingState();
          }
          if (state is BoardlistError) {
            return _boardlistErrorState(state.error);
          }
          if (state is BoardlistLoaded) {
            _cacheBoardLists = state.boardlist;
            return _buildBoardLists(state.boardlist);
          }
          return Container();
        },
      ),
    );
  }

  // scroll tracker
  Widget _buildScrollTrack() {
    return AnimatedBuilder(
      animation: _listController,
      builder: (context, _) {
        if (!_listController.hasClients ||
            _listController.position.maxScrollExtent <= 0) {
          return const SizedBox.shrink();
        }

        final maxScroll = _listController.position.maxScrollExtent;
        final offset = _listController.offset;
        final trackWidth =
            MediaQuery.of(context).size.width * _boardWidthFactor - 40;

        final handleMinWidth = 40.0;
        final handleMaxWidth = trackWidth * 0.3;

        final handleWidth = (trackWidth *
                (_listController.position.viewportDimension /
                    (_listController.position.viewportDimension + maxScroll)))
            .clamp(handleMinWidth, handleMaxWidth);

        final handleLeft = (offset / maxScroll) * (trackWidth - handleWidth);

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Stack(
            children: [
              Container(
                width: trackWidth,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Positioned(
                left: handleLeft,
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onHorizontalDragUpdate: (details) {
                    final deltaRatio = details.delta.dx / trackWidth;
                    final newOffset = offset + deltaRatio * maxScroll;

                    _listController.jumpTo(
                      newOffset.clamp(0.0, maxScroll),
                    );
                  },
                  child: Container(
                    width: handleWidth,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // panel content switch
  Widget _buildRightPanelContent() {
    switch (_rightPanelMode) {
      case RightPanelMode.chat:
        return BoardChat();
      case RightPanelMode.members:
        return _buildMembersPanel();
      case RightPanelMode.labels:
        return _buildLabelsPanel();
      case RightPanelMode.filter:
        return _buildFilterPanel();
    }
  }

  // panel decoration
  BoxDecoration _panelDecoration() {
    return BoxDecoration(
      border: Border.all(
        color: Theme.of(context).dividerColor.withValues(alpha: 0.4),
      ),
      borderRadius: BorderRadius.circular(10),
      color: Theme.of(context).brightness == Brightness.dark
          ? Colors.black.withValues(alpha: 0.05)
          : Colors.white.withValues(alpha: 0.05),
    );
  }

  // right panel tab
  Widget _buildPanelTab() {
    return Tooltip(
      message: _isRightPanelVisible ? 'Collapse Panel' : 'Expand Right Panel',
      textStyle: Theme.of(context).textTheme.bodySmall,
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.black.withValues(alpha: 0.04)
            : Colors.white.withValues(alpha: 0.04),
      ),
      waitDuration: Duration(milliseconds: 500),
      showDuration: Duration(seconds: 2),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _isRightPanelVisible = !_isRightPanelVisible;
          });
        },
        child: Container(
          width: 20,
          color: Colors.transparent,
          child: Center(
            child: Container(
              width: 2,
              height: 40,
              color: Theme.of(context).disabledColor.withAlpha(100),
            ),
          ),
        ),
      ),
    );
  }

  // boardlists
  Widget _buildBoardLists(List<Boardlist> list) {
    if (list.isEmpty) {
      return Center(
        child: Column(
          children: [
            Text('No lists yet!',
                style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: () {},
              label: Text('Create your first list',
                  style: Theme.of(context).textTheme.bodySmall),
              icon: Icon(
                Icons.add,
                color: Theme.of(context).iconTheme.color,
              ),
            )
          ],
        ),
      );
    }

    return ListView.separated(
        controller: _listController,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        itemBuilder: (context, index) => _buildListColumn(list[index]),
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemCount: list.length);
  }

  // list columns
  Widget _buildListColumn(Boardlist list) {
    return BlocBuilder<BoardMemberCubit, BoardMemberState>(
      builder: (context, state) {
        if (state is BoardMemberLoaded) {
          return BoardListColumn(
            list: list,
            boardId: widget.boardId,
            boardcardRepo: widget.boardcardRepo,
            cardCubits: _cardCubit,
            boardlistCubit: context.read<BoardlistCubit>(),
            memberCubit: context.read<BoardMemberCubit>(),
            labelCubit: widget.labelCubit,
            boardMembers: state.members,
            commentCubit: widget.commentCubit,
            cardAssigneeCubit: widget.cardAssigneeCubit,
          );
        }

        return const SizedBox(); // or loading placeholder
      },
    );
  }

  // board list states
  Widget _boardlistLoadingState() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _boardlistErrorState(String error) {
    return Center(
      child: Column(
        children: [
          Lottie.asset('asset/ani/error.json', repeat: false),
          const SizedBox(height: 10),
          Text(
            error,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: Colors.red),
          ),
          const SizedBox(height: 10),
          ElevatedButton.icon(
              onPressed: () {},
              label:
                  Text('Retry', style: Theme.of(context).textTheme.bodySmall))
        ],
      ),
    );
  }

  // page header
  Widget _buildHeader() {
    return Row(
      children: [
        Row(
          children: [
            IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: Icon(
                  Icons.arrow_back,
                  size: 20,
                )),
            const SizedBox(width: 1),
            CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage(
                  Theme.of(context).brightness == Brightness.dark
                      ? 'asset/images/k-dark.png'
                      : 'asset/images/k-light.png'),
            ),
            const SizedBox(width: 10),
            Text(
              widget.board.name,
              style: Theme.of(context).textTheme.bodyLarge,
            )
          ],
        ),
        Spacer(),
        ProfileAvatar(
          user: widget.user,
          profileImageService: widget.imageService,
          size: 50,
        )
      ],
    );
  }

  // panel contents
  Widget _buildMembersPanel() {
    return Container(
      height: MediaQuery.of(context).size.height * _boardHeightFactor,
      decoration: _panelDecoration(),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: BoardMemberSection(
            boardId: widget.boardId,
            memberCubit: context.read<BoardMemberCubit>(),
            dialogService: BoardMemberDialogServiceImpl(),
            memberService: MemberService(),
            currentUserEmail: widget.user.email,
          ),
        ),
      ),
    );
  }

  Widget _buildLabelsPanel() {
    return Container(
      height: MediaQuery.of(context).size.height * _boardHeightFactor,
      decoration: _panelDecoration(),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: BoardLabelSection(
            boardId: widget.board.id,
            labelCubit: widget.labelCubit,
          ),
        ),
      ),
    );
  }

  Widget _buildFilterPanel() {
    return Container(
      height: MediaQuery.of(context).size.height * _boardHeightFactor,
      decoration: _panelDecoration(),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                    child: Textfield(
                  text: 'Search boards or tasks',
                  obsecureText: false,
                  controller: searchController,
                  onChanged: _onSearchChange,
                )),
                const SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.close, size: 18),
                  onPressed: () {
                    searchController.clear();
                    context.read<SearchCubit>().clearSearch();
                    setState(() {
                      _rightPanelMode = RightPanelMode.chat;
                    });
                  },
                  tooltip: 'Close search',
                ),
              ],
            ),
          ),
          Divider(height: 1, thickness: 0.5),
          Expanded(
            child: BlocBuilder<SearchCubit, SearchState>(
              builder: (context, state) {
                if (state is SearchLoading) {
                  return _buildSearchLoading();
                }
                if (state is SearchLoaded) {
                  return BoardSearchPanel(
                    query: searchController.text,
                    boards: state.boards,
                    cards: state.cards,
                    onClose: () {},
                  );
                }
                if (state is SearchError) {
                  return _buildSearchError(state.message);
                }
                return _buildSearchEmpty();
              },
            ),
          ),
        ],
      ),
    );
  }

  // search states
  Widget _buildSearchLoading() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(strokeWidth: 2),
          SizedBox(height: 12),
          Text(
            'Searching...',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _buildSearchError(String message) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline, size: 32, color: Colors.red),
          SizedBox(height: 12),
          Text(
            message,
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSearchEmpty() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search, size: 32, color: Colors.grey),
          SizedBox(height: 12),
          Text(
            'Type to search',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          SizedBox(height: 4),
          Text(
            'Search for boards or tasks',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey,
                  fontSize: 11,
                ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:karwaan_flutter/core/utils/banner/banner_manager.dart';
import 'package:karwaan_flutter/data/mappers/auth/error/exception_mapper.dart';
import 'package:karwaan_flutter/domain/models/board/create_board_credentials.dart';
import 'package:karwaan_flutter/presentation/cubits/board/board_cubit.dart';
import 'package:karwaan_flutter/presentation/widgets/utils/textfield.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateBoardDialog extends StatefulWidget {
  final int workspaceId;
  final BoardCubit boardCubit;
  final BannerManager bannerManager;

  const CreateBoardDialog({
    super.key,
    required this.workspaceId,
    required this.boardCubit,
    required this.bannerManager
  });

  @override
  State<CreateBoardDialog> createState() => _CreateBoardDialogState();
}

class _CreateBoardDialogState extends State<CreateBoardDialog> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController desController = TextEditingController();
  bool _isCreatingBoard = false;

  @override
  void dispose() {
    nameController.dispose();
    desController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return StatefulBuilder(
      builder: (context, setState) {
        return BlocProvider.value(
          value: widget.boardCubit,
          child: Dialog(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            insetPadding: EdgeInsets.all(40),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.5,
              height: MediaQuery.of(context).size.height * 0.7,
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Theme.of(context)
                        .colorScheme
                        .surface
                        .withValues(alpha: 0.9),
                    Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.7)
                  ], begin: Alignment.topLeft, end: Alignment.bottomRight),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 30,
                        offset: Offset(0, 10))
                  ]),
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Create New Board',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: Icon(
                              Icons.close,
                              size: 24,
                            ))
                      ],
                    ),
          
                    const SizedBox(height: 32),
          
                    Expanded(
                        child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // name
                          Text('Board Name',
                              style: Theme.of(context).textTheme.bodyMedium),
                          const SizedBox(height: 8),
                          Textfield(
                              text: 'Enter board name...',
                              obsecureText: false,
                              controller: nameController),
          
                          const SizedBox(height: 24),
          
                          // description
                          Text('Description',
                              style: Theme.of(context).textTheme.bodyMedium),
                          const SizedBox(height: 8),
                          Textfield(
                              text: "What's the board for?...",
                              obsecureText: false,
                              controller: desController,
                              maxline: 3),
                        ],
                      ),
                    )),
                    const SizedBox(height: 32),
          
                    // actions
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                            onPressed: () => Navigator.pop(context),
                            style: TextButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 32, vertical: 12)),
                            child: Text(
                              'Cancel',
                              style: TextStyle(color: Colors.grey),
                            )),
                        const SizedBox(width: 16),
                        ElevatedButton(
                            onPressed: _isCreatingBoard
                                ? null
                                : () async {
                                    if (nameController.text.isEmpty ||
                                        desController.text.isEmpty) {
                                      widget.bannerManager.show(
                                          'Board name & description is required!');
                                      return;
                                    }
                                    setState(() {
                                      _isCreatingBoard = true;
                                    });
          
                                    try {
                                      final credentails = CreateBoardCredentials(
                                          workspaceId: widget.workspaceId,
                                          boardName: nameController.text.trim(),
                                          boardDescription:
                                              desController.text.trim(),
                                          createdAt: DateTime.now());
          
                                      await widget.boardCubit.createBoard(credentails);
                                      await widget.boardCubit.getBoardsByWorkspace(
                                          widget.workspaceId);
                                      Navigator.pop(context);
                                    } catch (e) {
                                      final mapper = ExceptionMapper.toMessage(e);
                                      widget.bannerManager.show(mapper);
                                    } finally {
                                      setState(() {
                                        _isCreatingBoard = false;
                                      });
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Theme.of(context).colorScheme.primary,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 32, vertical: 12),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    side: BorderSide(
                                        color:
                                            Theme.of(context).dividerColor))),
                            child: _isCreatingBoard
                                ? SizedBox(
                                    height: 20,
                                    width: 20,
                                    child:
                                        CircularProgressIndicator(strokeWidth: 2),
                                  )
                                : Text(
                                    'Create Board',
                                    style: Theme.of(context).textTheme.bodySmall,
                                  ))
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
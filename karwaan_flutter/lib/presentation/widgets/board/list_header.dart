import 'package:flutter/material.dart';
import 'package:karwaan_flutter/domain/models/boardlist/boardlist.dart';
import 'package:karwaan_flutter/domain/models/boardlist/boardlist_credentails.dart';
import 'package:karwaan_flutter/presentation/cubits/boardlist/boardlist_cubit.dart';
import 'package:karwaan_flutter/presentation/widgets/board/list_actions.dart';
import 'package:karwaan_flutter/presentation/widgets/board/list_dialogs.dart';
import 'package:karwaan_flutter/presentation/widgets/utils/textfield.dart';

class ListHeader extends StatefulWidget {
  final Boardlist list;
  final int boardId;
  final BoardlistCubit boardlistCubit;

  const ListHeader({
    super.key,
    required this.list,
    required this.boardId,
    required this.boardlistCubit,
  });

  @override
  State<ListHeader> createState() => _ListHeaderState();
}

class _ListHeaderState extends State<ListHeader> {
  bool _isEditing = false;
  final TextEditingController editController = TextEditingController();

  @override
  void dispose() {
    editController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isEditing) {
      return _buildEditHeader();
    }
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
      title: Text(
        widget.list.boardlistTitle,
        style: Theme.of(context)
            .textTheme
            .bodyMedium
            ?.copyWith(fontWeight: FontWeight.bold),
      ),
      trailing: ListActions(
        onEdit: () {
          setState(() {
            _isEditing = true;
            editController.text = widget.list.boardlistTitle;
          });
        },
        onDelete: () => _showDeleteDialog(),
      ),
    );
  }

  Widget _buildEditHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      child: Row(
        children: [
          Expanded(
            child: Textfield(
              text: widget.list.boardlistTitle,
              obsecureText: false,
              controller: editController,
              onSubmit: (_) => _saveEdit(),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                  icon: const Icon(Icons.check, size: 20),
                  onPressed: _saveEdit,
                  tooltip: 'Save',
                  color: Colors.green),
              IconButton(
                  icon: const Icon(Icons.close, size: 20),
                  onPressed: () {
                    setState(() {
                      _isEditing = false;
                      editController.clear();
                    });
                  },
                  tooltip: 'Cancel',
                  color: Colors.red)
            ],
          )
        ],
      ),
    );
  }

  void _saveEdit() {
    final newTitle = editController.text.trim();
    if (newTitle.isNotEmpty && newTitle != widget.list.boardlistTitle) {
      final credentials =
          BoardlistCredentails(id: widget.list.id, newTitle: newTitle);
      widget.boardlistCubit
          .updateBoardListOptimized(credentials, widget.boardId);

      setState(() {
        widget.list.boardlistTitle = newTitle;
        _isEditing = false;
      });
    } else {
      setState(() {
        _isEditing = false;
        editController.clear();
      });
    }
  }

  void _showDeleteDialog() {
    ListDialogs.showDeleteDialog(
      context,
      widget.list.boardlistTitle,
      () {
        widget.boardlistCubit
            .deleteBoardListOptimized(widget.list.id, widget.boardId);
      },
    );
  }
}

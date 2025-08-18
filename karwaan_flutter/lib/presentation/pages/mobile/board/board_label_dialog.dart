import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karwaan_flutter/domain/models/label/create_label_credentails.dart';
import 'package:karwaan_flutter/domain/models/label/label_state.dart';
import 'package:karwaan_flutter/domain/models/label/update_label_credentails.dart';
import 'package:karwaan_flutter/presentation/cubits/label/label_cubit.dart';

class LabelDialogContent extends StatelessWidget {
  final int boardId;
  final TextEditingController nameController;
  final Color? selectedColor;
  final List<Color> labelColors;
  final Function(Color?) onColorSelected;

  const LabelDialogContent({
    super.key,
    required this.boardId,
    required this.nameController,
    required this.selectedColor,
    required this.labelColors,
    required this.onColorSelected,
  });

  static const double _colorCircleSize = 36.0;
  static const double _selectedBorderWidth = 3.0;
  static const Color _selectedBorderColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LabelCubit, LabelState>(
      listener: (context, state) {
        if (state is LabelError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        } else if (state is LabelCreated ||
            state is LabelUpdated ||
            state is LabelDeleted) {
          context.read<LabelCubit>().getLabelsForBoard(boardId);
          if (state is LabelCreated) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Label has been created.'),
              backgroundColor: Colors.green,
            ));
            nameController.clear();
            onColorSelected(null);
          }
          if (state is LabelUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Label has been updated.'),
              backgroundColor: Colors.green,
            ));
          }
          if (state is LabelDeleted) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Label has been deleted.'),
              backgroundColor: Colors.green,
            ));
          }
        }
      },
      builder: (context, state) {
        List labels = [];
        if (state is LabelListLoaded) labels = state.labels;

        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          backgroundColor: Colors.grey.shade300,
          title: const Text(
            'Labels',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (labels.isNotEmpty)
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: labels
                        .map((label) => _buildLabelTile(context, label))
                        .toList(),
                  ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Close',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  backgroundColor: Colors.grey.shade200),
              onPressed: () => _showCreateDialog(context),
              child: Text(
                'Create Label',
                style: TextStyle(color: Colors.grey.shade500, fontSize: 16),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildLabelTile(BuildContext context, label) {
    // Convert backend color "#RRGGBB" to Flutter Color
    String hex = label.color.replaceFirst('#', '');
    Color labelColor = Color(int.parse('FF$hex', radix: 16));

    return GestureDetector(
      onTap: () => _showUpdateDialog(context, label, labelColor),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: labelColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label.title,
              style: GoogleFonts.alef(
                  color: Colors.grey.shade200, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () => context.read<LabelCubit>().deleteLabel(label.id),
              child: Icon(Icons.close, size: 18, color: Colors.grey.shade200),
            ),
          ],
        ),
      ),
    );
  }

  // create label dialog
  void _showCreateDialog(BuildContext parentContext) {
    final createController = TextEditingController();
    Color? createColor;

    showDialog(
        context: parentContext,
        builder: (dialogContext) => StatefulBuilder(
              builder: (statefulContext, setState) => AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                backgroundColor: Colors.grey.shade300,
                title: const Text('Create Label'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: createController,
                      decoration:
                          const InputDecoration(hintText: 'Label title'),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: labelColors.map((color) {
                        return GestureDetector(
                          onTap: () {
                            createColor = color;
                            (dialogContext as Element).markNeedsBuild();
                          },
                          child: Container(
                            width: _colorCircleSize,
                            height: _colorCircleSize,
                            margin: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: createColor == color
                                    ? _selectedBorderColor
                                    : Colors.transparent,
                                width: _selectedBorderWidth,
                              ),
                              boxShadow: [
                                if (createColor == color)
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 6,
                                    spreadRadius: 1,
                                  )
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(dialogContext),
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        backgroundColor: Colors.grey.shade400),
                    onPressed: () {
                      if (createController.text.trim().isNotEmpty) {
                        parentContext.read<LabelCubit>().createLabel(
                              CreateLabelCredentails(
                                boardId: boardId,
                                title: createController.text.trim(),
                                color: _convertColorToServerFormat(createColor),
                              ),
                            );
                      }
                      Navigator.pop(dialogContext);
                    },
                    child: Text(
                      'Create',
                      style:
                          TextStyle(color: Colors.grey.shade700, fontSize: 15),
                    ),
                  ),
                ],
              ),
            ));
  }

  // updated label dialog
  void _showUpdateDialog(BuildContext parentContext, label, Color labelColor) {
    final updateController = TextEditingController(text: label.title);

    showDialog(
      context: parentContext,
      builder: (dialogContext) => StatefulBuilder(
        builder: (statefulContext, setState) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          backgroundColor: Colors.grey.shade300,
          title: const Text('Update Label'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: updateController),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: labelColors.map((color) {
                  return GestureDetector(
                    onTap: () => setState(() => labelColor = color),
                    child: Container(
                      width: _colorCircleSize,
                      height: _colorCircleSize,
                      margin: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: labelColor == color
                                ? _selectedBorderColor
                                : Colors.transparent,
                            width: _selectedBorderWidth,
                          ),
                          boxShadow: [
                            if (labelColor == color)
                              BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 6,
                                  spreadRadius: 1)
                          ]),
                    ),
                  );
                }).toList(),
              )
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  backgroundColor: Colors.grey.shade400),
              onPressed: () {
                parentContext.read<LabelCubit>().updateLabel(
                      UpdateLabelCredentails(
                        labelId: label.id,
                        newTitle: updateController.text.trim(),
                        newColor: _convertColorToServerFormat(labelColor),
                      ),
                    );
                Navigator.pop(dialogContext);
              },
              child: Text(
                'Update',
                style: TextStyle(color: Colors.grey.shade700, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Converts Flutter [Color] → "#RRGGBB"
  String _convertColorToServerFormat(Color? color) {
    if (color == null) return '#FFFFFF';
    final argb = color.toARGB32().toRadixString(16).padLeft(8, '0');
    final rgb = argb.substring(2);
    return '#$rgb'.toUpperCase();
  }
}

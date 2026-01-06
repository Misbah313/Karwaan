import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:karwaan_flutter/core/utils/banner/banner_manager.dart';
import 'package:karwaan_flutter/domain/models/label/create_label_credentails.dart';
import 'package:karwaan_flutter/domain/models/label/label.dart';
import 'package:karwaan_flutter/domain/models/label/label_state.dart';
import 'package:karwaan_flutter/domain/models/label/update_label_credentails.dart';
import 'package:karwaan_flutter/presentation/cubits/label/label_cubit.dart';
import 'package:karwaan_flutter/presentation/widgets/label_color_picker.dart';
import 'package:karwaan_flutter/presentation/widgets/label_display_item.dart';
import 'package:karwaan_flutter/presentation/widgets/utils/textfield.dart';

class BoardLabelSection extends StatefulWidget {
  final int boardId;
  final LabelCubit labelCubit;
  const BoardLabelSection({
    super.key,
    required this.boardId,
    required this.labelCubit,
  });

  @override
  State<BoardLabelSection> createState() => _BoardLabelSectionState();
}

class _BoardLabelSectionState extends State<BoardLabelSection> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _editNameController = TextEditingController();
  Color? _selectedColor;
  Label? _editingLabel;
  List<Label> _cachedLabels = [];

  // Available colors
  final List<Color> _labelColors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.orange,
    Colors.purple,
    Colors.teal,
    Colors.pink,
    Colors.brown,
    Colors.cyan,
  ];

  @override
  void initState() {
    super.initState();
    widget.labelCubit.getLabelsForBoard(widget.boardId);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _editNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(context, 'Board Labels'),
          const SizedBox(height: 16),
          _buildCreateForm(context),
          const SizedBox(height: 20),
          _buildLabelList(context),
        ],
      ),
    );
  }

  // Widgets
  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context)
          .textTheme
          .bodyLarge
          ?.copyWith(fontWeight: FontWeight.w200, fontSize: 22),
    );
  }

  Widget _buildCreateForm(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Create New Label',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),

          // Label Name
          Textfield(
            text: 'Label title',
            obsecureText: false,
            controller: _nameController,
          ),
          const SizedBox(height: 16),

          // Color Picker
          Text(
            'Select Color',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 8),
          LabelColorPicker(
              colors: _labelColors,
              selectedColor: _selectedColor,
              onColorSelected: (color) {
                setState(() {
                  _selectedColor = color;
                });
              }),
          const SizedBox(height: 20),

          // Form Actions
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12))),
                onPressed:
                    _selectedColor == null || _nameController.text.isEmpty
                        ? null
                        : _createLabel,
                child: Text(
                  'Create Label',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLabelList(BuildContext context) {
    return BlocConsumer<LabelCubit, LabelState>(
      bloc: widget.labelCubit,
      // Separate listener for side effects
      listener: (context, state) {
        if (state is LabelListLoaded) {
          // Cache labels when successfully loaded
          _cachedLabels = state.labels;
        }

        if (state is LabelCreated ||
            state is LabelUpdated ||
            state is LabelDeleted) {
          _resetForm();
          // Show success banner with green color
          context.read<BannerManager>().show(
                state is LabelCreated
                    ? 'Label created successfully'
                    : state is LabelUpdated
                        ? 'Label updated successfully'
                        : 'Label deleted successfully',
                backgroundColor: Colors.green,
              );
          // Refresh the list
          widget.labelCubit.getLabelsForBoard(widget.boardId);
        }

        if (state is LabelError) {
          // Show error banner with red color
          context.read<BannerManager>().show(
                state.error,
                backgroundColor: Colors.red,
              );
          // Don't clear the cache on error - keep showing previous data
        }
      },
      // Builder for UI rendering
      builder: (context, state) {
        if (state is LabelLoading && _cachedLabels.isEmpty) {
          // Only show loading if we don't have cached data
          return _buildLoadingState();
        } else if (state is LabelListLoaded) {
          return _buildLabelListView(context, state.labels);
        } else if (state is LabelError) {
          // On error, show cached data or empty state
          return _cachedLabels.isNotEmpty
              ? _buildLabelListView(context, _cachedLabels)
              : _buildEmptyState(context);
        } else {
          // For any other state (including LabelError with cached data)
          return _cachedLabels.isNotEmpty
              ? _buildLabelListView(context, _cachedLabels)
              : _buildEmptyState(context);
        }
      },
    );
  }

  Widget _buildLabelListView(BuildContext context, List<Label> labels) {
    if (labels.isEmpty) {
      return _buildEmptyState(context);
    }

    return Column(
      children: labels.map((label) => _buildLabelItem(context, label)).toList(),
    );
  }

  Widget _buildLabelItem(BuildContext context, Label label) {
    final isEditing = _editingLabel?.id == label.id;

    if (isEditing) {
      return _buildEditForm(context, label);
    }

    return LabelDisplayItem(
      label: label,
      onEdit: () => _startEditing(label),
      onDelete: () => _showDeleteDialog(context, label),
    );
  }

  Widget _buildEditForm(BuildContext context, Label label) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Edit Label',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),

          // Label Name
          Textfield(
            text: 'Label title',
            obsecureText: false,
            controller: _editNameController,
          ),
          const SizedBox(height: 16),

          // Color Picker
          Text(
            'Select Color',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 8),
          LabelColorPicker(
              colors: _labelColors,
              selectedColor: _selectedColor,
              onColorSelected: (color) {
                setState(() {
                  _selectedColor = color;
                });
              }),
          const SizedBox(height: 20),

          // Edit Actions
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: _cancelEdit,
                child: Text(
                  'Cancel',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12))),
                onPressed: _editNameController.text.isEmpty
                    ? null
                    : () {
                        _updateLabel(label, _editNameController.text.trim());
                      },
                child: Text(
                  'Update Label',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Methods for widgets
  void _startEditing(Label label) {
    setState(() {
      _editingLabel = label;
      _selectedColor = null;
      _editNameController.text = label.title;
      _editNameController.selection =
          TextSelection.collapsed(offset: label.title.length);
    });
  }

  void _cancelEdit() {
    setState(() {
      _editingLabel = null;
      _selectedColor = null;
      _editNameController.clear();
    });
  }

  void _createLabel() {
    if (_selectedColor == null) return;

    final credentials = CreateLabelCredentails(
      boardId: widget.boardId,
      title: _nameController.text.trim(),
      color: _convertColorToServerFormat(_selectedColor!),
    );

    widget.labelCubit.createLabel(credentials);
    _nameController.clear();
    setState(() {
      _selectedColor = null;
    });
  }

  void _updateLabel(Label label, String newTitle) {
    final updateColor = _selectedColor ??
        Color(int.parse('FF${label.color.replaceFirst('#', '')}', radix: 16));

    final credentials = UpdateLabelCredentails(
      labelId: label.id!,
      newTitle: newTitle,
      newColor: _convertColorToServerFormat(updateColor),
    );

    widget.labelCubit.updateLabel(credentials);
    _cancelEdit();
  }

  void _showDeleteDialog(BuildContext context, Label label) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        insetPadding: const EdgeInsets.all(30),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.3,
          height: MediaQuery.of(context).size.height * 0.25,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Delete Label',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Are you sure you want to delete this label?',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),

                // Actions
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Cancel',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ),
                    const SizedBox(width: 6),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor:
                              Theme.of(context).colorScheme.primary),
                      onPressed: () {
                        widget.labelCubit.deleteLabel(label.id!);
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Delete',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _resetForm() {
    setState(() {
      _editingLabel = null;
      _selectedColor = null;
    });
  }

  // Helper Methods
  String _convertColorToServerFormat(Color color) {
    final argb = color.toARGB32().toRadixString(16).padLeft(8, '0');
    final rgb = argb.substring(2);
    return '#$rgb'.toUpperCase();
  }

  // State Builders
  Widget _buildLoadingState() => const Center(
        child: CircularProgressIndicator(),
      );

  Widget _buildEmptyState(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Text(
          'No labels created yet. Create one above!',
          style: Theme.of(context).textTheme.bodySmall,
          textAlign: TextAlign.center,
        ));
  }
}

// editable_field_with_save.dart
import 'package:flutter/material.dart';

class EditableFieldWithSave extends StatefulWidget {
  final String initialValue;
  final String label;
  final int maxLines;
  final Function(String) onSave;

  const EditableFieldWithSave({
    super.key,
    required this.initialValue,
    required this.label,
    this.maxLines = 1,
    required this.onSave,
  });

  @override
  State<EditableFieldWithSave> createState() => _EditableFieldWithSaveState();
}

class _EditableFieldWithSaveState extends State<EditableFieldWithSave> {
  late TextEditingController _controller;
  bool _hasChanged = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          fit: FlexFit.loose,
          child: TextFormField(
            maxLines: widget.maxLines,
            style: Theme.of(context).textTheme.bodyMedium,
            controller: _controller,
            decoration: InputDecoration(
              labelText: widget.label,
              labelStyle: Theme.of(context).textTheme.bodySmall,
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide:
                      BorderSide(color: Theme.of(context).dividerColor)),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: _hasChanged
                      ? Colors.green
                      : Theme.of(context).dividerColor,
                  width: _hasChanged ? 1.5 : 1.0,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Theme.of(context).dividerColor),
              ),
            ),
            onChanged: (value) {
              setState(() {
                _hasChanged = value != widget.initialValue;
              });
            },
          ),
        ),
        const SizedBox(width: 8),
        if (_hasChanged)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () {
                  _controller.text = widget.initialValue; // Reset to original
                  setState(() => _hasChanged = false);
                },
                icon: Icon(
                  Icons.close,
                  color: Colors.red,
                  size: 20,
                ),
                tooltip: 'Cancel',
              ),
              IconButton(
                onPressed: () {
                  widget.onSave(_controller.text);
                  setState(() => _hasChanged = false);
                },
                icon: Icon(
                  Icons.check,
                  color: Colors.green,
                  size: 20,
                ),
                tooltip: 'Save',
              ),
            ],
          ),
      ],
    );
  }
}

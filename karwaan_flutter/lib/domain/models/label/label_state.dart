import 'package:karwaan_flutter/domain/models/label/label.dart';

abstract class LabelState {}

class LabelLoading extends LabelState {}

class LabelInitial extends LabelState {}

class LabelListLoaded extends LabelState {
  final List<Label> labels;

  LabelListLoaded(this.labels);
}

class LableListNotLoaded extends LabelState {}

class LabelUpdated extends LabelState {
  final Label label;

  LabelUpdated(this.label);
}

class LabelCreated extends LabelState {
  final Label label;

  LabelCreated(this.label);
}

class LabelDeleted extends LabelState {
  final int labelId;

  LabelDeleted(this.labelId);
}

class LabelError extends LabelState {
  final String error;

  LabelError(this.error);
}

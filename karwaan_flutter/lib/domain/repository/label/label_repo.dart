import 'package:karwaan_flutter/domain/models/label/create_label_credentails.dart';
import 'package:karwaan_flutter/domain/models/label/label.dart';
import 'package:karwaan_flutter/domain/models/label/update_label_credentails.dart';

abstract class LabelRepo {
  Future<Label> createLabel(CreateLabelCredentails credentails);
  Future<List<Label>> getLabelsForBoard(int boardId);
  Future<Label> updateLabel(UpdateLabelCredentails credentails);
  Future<bool> deleteLabel(int labelId);
}

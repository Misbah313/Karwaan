import 'package:karwaan_flutter/domain/models/cardlabel/cardlabel.dart';
import 'package:karwaan_flutter/domain/models/cardlabel/cardlabel_credentails.dart';
import 'package:karwaan_flutter/domain/models/label/label.dart';

abstract class CardlabelRepo {
  Future<Cardlabel> assignLabelToCard(CardlabelCredentails credentails);
  Future<void> removeLabelFromCard(CardlabelCredentails credentails);
  Future<List<Label>> getLabelsforCard(int cardId);
  Future<List<Cardlabel>> getCardsForLabel(int labelId);
}

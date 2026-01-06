import 'package:flutter/material.dart';
import 'package:karwaan_flutter/domain/models/board/board.dart';
import 'package:karwaan_flutter/domain/models/board/board_details.dart';
@immutable
class BoardWrapper {
  final dynamic _board;
  
  const BoardWrapper(this._board);
  
  String get name {
    if (_board is Board) {
      return (_board).boardName;
    } else if (_board is BoardDetails) {
      return (_board).name;
    }
    throw StateError('Unknown board type: ${_board.runtimeType}');
  }
  
  String get description {
    if (_board is Board) {
      return (_board).boardDescription;
    } else if (_board is BoardDetails) {
      return (_board).description;
    }
    throw StateError('Unknown board type: ${_board.runtimeType}');
  }
  
  int get id {
    if (_board is Board) {
      return (_board).id;
    } else if (_board is BoardDetails) {
      return (_board).id;
    }
    throw StateError('Unknown board type: ${_board.runtimeType}');
  }
  
  DateTime get createdAt {
    if (_board is Board) {
      return (_board).createAt;
    } else if (_board is BoardDetails) {
      return (_board).createdAt;
    }
    throw StateError('Unknown board type: ${_board.runtimeType}');
  }
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BoardWrapper &&
          runtimeType == other.runtimeType &&
          _board == other._board;

  @override
  int get hashCode => _board.hashCode;
}
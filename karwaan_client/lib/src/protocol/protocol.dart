/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'greeting.dart' as _i2;
import 'attachment.dart' as _i3;
import 'auth_response.dart' as _i4;
import 'board.dart' as _i5;
import 'board_details.dart' as _i6;
import 'board_list.dart' as _i7;
import 'board_member.dart' as _i8;
import 'card.dart' as _i9;
import 'card_label.dart' as _i10;
import 'checklist.dart' as _i11;
import 'checklist_item.dart' as _i12;
import 'comment.dart' as _i13;
import 'label.dart' as _i14;
import 'user.dart' as _i15;
import 'user_token.dart' as _i16;
import 'workspace.dart' as _i17;
import 'workspace_member.dart' as _i18;
import 'package:karwaan_client/src/protocol/board_details.dart' as _i19;
import 'package:karwaan_client/src/protocol/board_list.dart' as _i20;
import 'package:karwaan_client/src/endpoints/board_member_details.dart' as _i21;
import 'package:karwaan_client/src/protocol/card.dart' as _i22;
import 'package:karwaan_client/src/protocol/label.dart' as _i23;
import 'package:karwaan_client/src/protocol/user.dart' as _i24;
import 'package:karwaan_client/src/protocol/workspace.dart' as _i25;
import 'package:karwaan_client/src/endpoints/workspace_member_details.dart'
    as _i26;
export 'greeting.dart';
export 'attachment.dart';
export 'auth_response.dart';
export 'board.dart';
export 'board_details.dart';
export 'board_list.dart';
export 'board_member.dart';
export 'card.dart';
export 'card_label.dart';
export 'checklist.dart';
export 'checklist_item.dart';
export 'comment.dart';
export 'label.dart';
export 'user.dart';
export 'user_token.dart';
export 'workspace.dart';
export 'workspace_member.dart';
export 'client.dart';

class Protocol extends _i1.SerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;
    if (t == _i2.Greeting) {
      return _i2.Greeting.fromJson(data) as T;
    }
    if (t == _i3.Attachment) {
      return _i3.Attachment.fromJson(data) as T;
    }
    if (t == _i4.AuthResponse) {
      return _i4.AuthResponse.fromJson(data) as T;
    }
    if (t == _i5.Board) {
      return _i5.Board.fromJson(data) as T;
    }
    if (t == _i6.BoardDetails) {
      return _i6.BoardDetails.fromJson(data) as T;
    }
    if (t == _i7.BoardList) {
      return _i7.BoardList.fromJson(data) as T;
    }
    if (t == _i8.BoardMember) {
      return _i8.BoardMember.fromJson(data) as T;
    }
    if (t == _i9.Card) {
      return _i9.Card.fromJson(data) as T;
    }
    if (t == _i10.CardLabel) {
      return _i10.CardLabel.fromJson(data) as T;
    }
    if (t == _i11.CheckList) {
      return _i11.CheckList.fromJson(data) as T;
    }
    if (t == _i12.CheckListItem) {
      return _i12.CheckListItem.fromJson(data) as T;
    }
    if (t == _i13.Comment) {
      return _i13.Comment.fromJson(data) as T;
    }
    if (t == _i14.Label) {
      return _i14.Label.fromJson(data) as T;
    }
    if (t == _i15.User) {
      return _i15.User.fromJson(data) as T;
    }
    if (t == _i16.UserToken) {
      return _i16.UserToken.fromJson(data) as T;
    }
    if (t == _i17.Workspace) {
      return _i17.Workspace.fromJson(data) as T;
    }
    if (t == _i18.WorkspaceMember) {
      return _i18.WorkspaceMember.fromJson(data) as T;
    }
    if (t == _i1.getType<_i2.Greeting?>()) {
      return (data != null ? _i2.Greeting.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i3.Attachment?>()) {
      return (data != null ? _i3.Attachment.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i4.AuthResponse?>()) {
      return (data != null ? _i4.AuthResponse.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i5.Board?>()) {
      return (data != null ? _i5.Board.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i6.BoardDetails?>()) {
      return (data != null ? _i6.BoardDetails.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i7.BoardList?>()) {
      return (data != null ? _i7.BoardList.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i8.BoardMember?>()) {
      return (data != null ? _i8.BoardMember.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i9.Card?>()) {
      return (data != null ? _i9.Card.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i10.CardLabel?>()) {
      return (data != null ? _i10.CardLabel.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i11.CheckList?>()) {
      return (data != null ? _i11.CheckList.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i12.CheckListItem?>()) {
      return (data != null ? _i12.CheckListItem.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i13.Comment?>()) {
      return (data != null ? _i13.Comment.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i14.Label?>()) {
      return (data != null ? _i14.Label.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i15.User?>()) {
      return (data != null ? _i15.User.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i16.UserToken?>()) {
      return (data != null ? _i16.UserToken.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i17.Workspace?>()) {
      return (data != null ? _i17.Workspace.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i18.WorkspaceMember?>()) {
      return (data != null ? _i18.WorkspaceMember.fromJson(data) : null) as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == List<_i19.BoardDetails>) {
      return (data as List)
          .map((e) => deserialize<_i19.BoardDetails>(e))
          .toList() as T;
    }
    if (t == List<_i20.BoardList>) {
      return (data as List).map((e) => deserialize<_i20.BoardList>(e)).toList()
          as T;
    }
    if (t == List<_i21.BoardMemberDetails>) {
      return (data as List)
          .map((e) => deserialize<_i21.BoardMemberDetails>(e))
          .toList() as T;
    }
    if (t == List<_i22.Card>) {
      return (data as List).map((e) => deserialize<_i22.Card>(e)).toList() as T;
    }
    if (t == List<_i23.Label>) {
      return (data as List).map((e) => deserialize<_i23.Label>(e)).toList()
          as T;
    }
    if (t == List<_i24.User>) {
      return (data as List).map((e) => deserialize<_i24.User>(e)).toList() as T;
    }
    if (t == List<_i25.Workspace>) {
      return (data as List).map((e) => deserialize<_i25.Workspace>(e)).toList()
          as T;
    }
    if (t == List<_i26.WorkspaceMemberDetails>) {
      return (data as List)
          .map((e) => deserialize<_i26.WorkspaceMemberDetails>(e))
          .toList() as T;
    }
    return super.deserialize<T>(data, t);
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;
    if (data is _i2.Greeting) {
      return 'Greeting';
    }
    if (data is _i3.Attachment) {
      return 'Attachment';
    }
    if (data is _i4.AuthResponse) {
      return 'AuthResponse';
    }
    if (data is _i5.Board) {
      return 'Board';
    }
    if (data is _i6.BoardDetails) {
      return 'BoardDetails';
    }
    if (data is _i7.BoardList) {
      return 'BoardList';
    }
    if (data is _i8.BoardMember) {
      return 'BoardMember';
    }
    if (data is _i9.Card) {
      return 'Card';
    }
    if (data is _i10.CardLabel) {
      return 'CardLabel';
    }
    if (data is _i11.CheckList) {
      return 'CheckList';
    }
    if (data is _i12.CheckListItem) {
      return 'CheckListItem';
    }
    if (data is _i13.Comment) {
      return 'Comment';
    }
    if (data is _i14.Label) {
      return 'Label';
    }
    if (data is _i15.User) {
      return 'User';
    }
    if (data is _i16.UserToken) {
      return 'UserToken';
    }
    if (data is _i17.Workspace) {
      return 'Workspace';
    }
    if (data is _i18.WorkspaceMember) {
      return 'WorkspaceMember';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'Greeting') {
      return deserialize<_i2.Greeting>(data['data']);
    }
    if (dataClassName == 'Attachment') {
      return deserialize<_i3.Attachment>(data['data']);
    }
    if (dataClassName == 'AuthResponse') {
      return deserialize<_i4.AuthResponse>(data['data']);
    }
    if (dataClassName == 'Board') {
      return deserialize<_i5.Board>(data['data']);
    }
    if (dataClassName == 'BoardDetails') {
      return deserialize<_i6.BoardDetails>(data['data']);
    }
    if (dataClassName == 'BoardList') {
      return deserialize<_i7.BoardList>(data['data']);
    }
    if (dataClassName == 'BoardMember') {
      return deserialize<_i8.BoardMember>(data['data']);
    }
    if (dataClassName == 'Card') {
      return deserialize<_i9.Card>(data['data']);
    }
    if (dataClassName == 'CardLabel') {
      return deserialize<_i10.CardLabel>(data['data']);
    }
    if (dataClassName == 'CheckList') {
      return deserialize<_i11.CheckList>(data['data']);
    }
    if (dataClassName == 'CheckListItem') {
      return deserialize<_i12.CheckListItem>(data['data']);
    }
    if (dataClassName == 'Comment') {
      return deserialize<_i13.Comment>(data['data']);
    }
    if (dataClassName == 'Label') {
      return deserialize<_i14.Label>(data['data']);
    }
    if (dataClassName == 'User') {
      return deserialize<_i15.User>(data['data']);
    }
    if (dataClassName == 'UserToken') {
      return deserialize<_i16.UserToken>(data['data']);
    }
    if (dataClassName == 'Workspace') {
      return deserialize<_i17.Workspace>(data['data']);
    }
    if (dataClassName == 'WorkspaceMember') {
      return deserialize<_i18.WorkspaceMember>(data['data']);
    }
    return super.deserializeByClassName(data);
  }
}

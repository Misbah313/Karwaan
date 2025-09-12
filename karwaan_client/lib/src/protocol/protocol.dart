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
import 'app_auth_exception.dart' as _i3;
import 'app_exception.dart' as _i4;
import 'app_not_found_exception.dart' as _i5;
import 'app_permission_exception.dart' as _i6;
import 'attachment.dart' as _i7;
import 'auth_response.dart' as _i8;
import 'board.dart' as _i9;
import 'board_card.dart' as _i10;
import 'board_details.dart' as _i11;
import 'board_list.dart' as _i12;
import 'board_member.dart' as _i13;
import 'board_member_details.dart' as _i14;
import 'card_label.dart' as _i15;
import 'checklist.dart' as _i16;
import 'checklist_item.dart' as _i17;
import 'comment.dart' as _i18;
import 'comment_withauthor.dart' as _i19;
import 'label.dart' as _i20;
import 'random_app_exception.dart' as _i21;
import 'user.dart' as _i22;
import 'user_token.dart' as _i23;
import 'workspace.dart' as _i24;
import 'workspace_member.dart' as _i25;
import 'workspace_member_details.dart' as _i26;
import 'package:karwaan_client/src/protocol/attachment.dart' as _i27;
import 'package:karwaan_client/src/protocol/board_card.dart' as _i28;
import 'package:karwaan_client/src/protocol/board_details.dart' as _i29;
import 'package:karwaan_client/src/protocol/board_list.dart' as _i30;
import 'package:karwaan_client/src/protocol/board_member_details.dart' as _i31;
import 'package:karwaan_client/src/protocol/label.dart' as _i32;
import 'package:karwaan_client/src/protocol/checklist.dart' as _i33;
import 'package:karwaan_client/src/protocol/checklist_item.dart' as _i34;
import 'package:karwaan_client/src/protocol/comment_withauthor.dart' as _i35;
import 'package:karwaan_client/src/protocol/user.dart' as _i36;
import 'package:karwaan_client/src/protocol/workspace.dart' as _i37;
import 'package:karwaan_client/src/protocol/workspace_member_details.dart'
    as _i38;
export 'greeting.dart';
export 'app_auth_exception.dart';
export 'app_exception.dart';
export 'app_not_found_exception.dart';
export 'app_permission_exception.dart';
export 'attachment.dart';
export 'auth_response.dart';
export 'board.dart';
export 'board_card.dart';
export 'board_details.dart';
export 'board_list.dart';
export 'board_member.dart';
export 'board_member_details.dart';
export 'card_label.dart';
export 'checklist.dart';
export 'checklist_item.dart';
export 'comment.dart';
export 'comment_withauthor.dart';
export 'label.dart';
export 'random_app_exception.dart';
export 'user.dart';
export 'user_token.dart';
export 'workspace.dart';
export 'workspace_member.dart';
export 'workspace_member_details.dart';
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
    if (t == _i3.AppAuthException) {
      return _i3.AppAuthException.fromJson(data) as T;
    }
    if (t == _i4.AppException) {
      return _i4.AppException.fromJson(data) as T;
    }
    if (t == _i5.AppNotFoundException) {
      return _i5.AppNotFoundException.fromJson(data) as T;
    }
    if (t == _i6.AppPermissionException) {
      return _i6.AppPermissionException.fromJson(data) as T;
    }
    if (t == _i7.Attachment) {
      return _i7.Attachment.fromJson(data) as T;
    }
    if (t == _i8.AuthResponse) {
      return _i8.AuthResponse.fromJson(data) as T;
    }
    if (t == _i9.Board) {
      return _i9.Board.fromJson(data) as T;
    }
    if (t == _i10.BoardCard) {
      return _i10.BoardCard.fromJson(data) as T;
    }
    if (t == _i11.BoardDetails) {
      return _i11.BoardDetails.fromJson(data) as T;
    }
    if (t == _i12.BoardList) {
      return _i12.BoardList.fromJson(data) as T;
    }
    if (t == _i13.BoardMember) {
      return _i13.BoardMember.fromJson(data) as T;
    }
    if (t == _i14.BoardMemberDetails) {
      return _i14.BoardMemberDetails.fromJson(data) as T;
    }
    if (t == _i15.CardLabel) {
      return _i15.CardLabel.fromJson(data) as T;
    }
    if (t == _i16.CheckList) {
      return _i16.CheckList.fromJson(data) as T;
    }
    if (t == _i17.CheckListItem) {
      return _i17.CheckListItem.fromJson(data) as T;
    }
    if (t == _i18.Comment) {
      return _i18.Comment.fromJson(data) as T;
    }
    if (t == _i19.CommentWithAuthor) {
      return _i19.CommentWithAuthor.fromJson(data) as T;
    }
    if (t == _i20.Label) {
      return _i20.Label.fromJson(data) as T;
    }
    if (t == _i21.RandomAppException) {
      return _i21.RandomAppException.fromJson(data) as T;
    }
    if (t == _i22.User) {
      return _i22.User.fromJson(data) as T;
    }
    if (t == _i23.UserToken) {
      return _i23.UserToken.fromJson(data) as T;
    }
    if (t == _i24.Workspace) {
      return _i24.Workspace.fromJson(data) as T;
    }
    if (t == _i25.WorkspaceMember) {
      return _i25.WorkspaceMember.fromJson(data) as T;
    }
    if (t == _i26.WorkspaceMemberDetails) {
      return _i26.WorkspaceMemberDetails.fromJson(data) as T;
    }
    if (t == _i1.getType<_i2.Greeting?>()) {
      return (data != null ? _i2.Greeting.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i3.AppAuthException?>()) {
      return (data != null ? _i3.AppAuthException.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i4.AppException?>()) {
      return (data != null ? _i4.AppException.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i5.AppNotFoundException?>()) {
      return (data != null ? _i5.AppNotFoundException.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i6.AppPermissionException?>()) {
      return (data != null ? _i6.AppPermissionException.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i7.Attachment?>()) {
      return (data != null ? _i7.Attachment.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i8.AuthResponse?>()) {
      return (data != null ? _i8.AuthResponse.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i9.Board?>()) {
      return (data != null ? _i9.Board.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i10.BoardCard?>()) {
      return (data != null ? _i10.BoardCard.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i11.BoardDetails?>()) {
      return (data != null ? _i11.BoardDetails.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i12.BoardList?>()) {
      return (data != null ? _i12.BoardList.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i13.BoardMember?>()) {
      return (data != null ? _i13.BoardMember.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i14.BoardMemberDetails?>()) {
      return (data != null ? _i14.BoardMemberDetails.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i15.CardLabel?>()) {
      return (data != null ? _i15.CardLabel.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i16.CheckList?>()) {
      return (data != null ? _i16.CheckList.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i17.CheckListItem?>()) {
      return (data != null ? _i17.CheckListItem.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i18.Comment?>()) {
      return (data != null ? _i18.Comment.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i19.CommentWithAuthor?>()) {
      return (data != null ? _i19.CommentWithAuthor.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i20.Label?>()) {
      return (data != null ? _i20.Label.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i21.RandomAppException?>()) {
      return (data != null ? _i21.RandomAppException.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i22.User?>()) {
      return (data != null ? _i22.User.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i23.UserToken?>()) {
      return (data != null ? _i23.UserToken.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i24.Workspace?>()) {
      return (data != null ? _i24.Workspace.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i25.WorkspaceMember?>()) {
      return (data != null ? _i25.WorkspaceMember.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i26.WorkspaceMemberDetails?>()) {
      return (data != null ? _i26.WorkspaceMemberDetails.fromJson(data) : null)
          as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == List<_i27.Attachment>) {
      return (data as List).map((e) => deserialize<_i27.Attachment>(e)).toList()
          as T;
    }
    if (t == List<_i28.BoardCard>) {
      return (data as List).map((e) => deserialize<_i28.BoardCard>(e)).toList()
          as T;
    }
    if (t == List<_i29.BoardDetails>) {
      return (data as List)
          .map((e) => deserialize<_i29.BoardDetails>(e))
          .toList() as T;
    }
    if (t == List<_i30.BoardList>) {
      return (data as List).map((e) => deserialize<_i30.BoardList>(e)).toList()
          as T;
    }
    if (t == List<_i31.BoardMemberDetails>) {
      return (data as List)
          .map((e) => deserialize<_i31.BoardMemberDetails>(e))
          .toList() as T;
    }
    if (t == List<_i32.Label>) {
      return (data as List).map((e) => deserialize<_i32.Label>(e)).toList()
          as T;
    }
    if (t == List<_i33.CheckList>) {
      return (data as List).map((e) => deserialize<_i33.CheckList>(e)).toList()
          as T;
    }
    if (t == List<_i34.CheckListItem>) {
      return (data as List)
          .map((e) => deserialize<_i34.CheckListItem>(e))
          .toList() as T;
    }
    if (t == List<_i35.CommentWithAuthor>) {
      return (data as List)
          .map((e) => deserialize<_i35.CommentWithAuthor>(e))
          .toList() as T;
    }
    if (t == List<int>) {
      return (data as List).map((e) => deserialize<int>(e)).toList() as T;
    }
    if (t == List<_i36.User>) {
      return (data as List).map((e) => deserialize<_i36.User>(e)).toList() as T;
    }
    if (t == List<_i37.Workspace>) {
      return (data as List).map((e) => deserialize<_i37.Workspace>(e)).toList()
          as T;
    }
    if (t == List<_i38.WorkspaceMemberDetails>) {
      return (data as List)
          .map((e) => deserialize<_i38.WorkspaceMemberDetails>(e))
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
    if (data is _i3.AppAuthException) {
      return 'AppAuthException';
    }
    if (data is _i4.AppException) {
      return 'AppException';
    }
    if (data is _i5.AppNotFoundException) {
      return 'AppNotFoundException';
    }
    if (data is _i6.AppPermissionException) {
      return 'AppPermissionException';
    }
    if (data is _i7.Attachment) {
      return 'Attachment';
    }
    if (data is _i8.AuthResponse) {
      return 'AuthResponse';
    }
    if (data is _i9.Board) {
      return 'Board';
    }
    if (data is _i10.BoardCard) {
      return 'BoardCard';
    }
    if (data is _i11.BoardDetails) {
      return 'BoardDetails';
    }
    if (data is _i12.BoardList) {
      return 'BoardList';
    }
    if (data is _i13.BoardMember) {
      return 'BoardMember';
    }
    if (data is _i14.BoardMemberDetails) {
      return 'BoardMemberDetails';
    }
    if (data is _i15.CardLabel) {
      return 'CardLabel';
    }
    if (data is _i16.CheckList) {
      return 'CheckList';
    }
    if (data is _i17.CheckListItem) {
      return 'CheckListItem';
    }
    if (data is _i18.Comment) {
      return 'Comment';
    }
    if (data is _i19.CommentWithAuthor) {
      return 'CommentWithAuthor';
    }
    if (data is _i20.Label) {
      return 'Label';
    }
    if (data is _i21.RandomAppException) {
      return 'RandomAppException';
    }
    if (data is _i22.User) {
      return 'User';
    }
    if (data is _i23.UserToken) {
      return 'UserToken';
    }
    if (data is _i24.Workspace) {
      return 'Workspace';
    }
    if (data is _i25.WorkspaceMember) {
      return 'WorkspaceMember';
    }
    if (data is _i26.WorkspaceMemberDetails) {
      return 'WorkspaceMemberDetails';
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
    if (dataClassName == 'AppAuthException') {
      return deserialize<_i3.AppAuthException>(data['data']);
    }
    if (dataClassName == 'AppException') {
      return deserialize<_i4.AppException>(data['data']);
    }
    if (dataClassName == 'AppNotFoundException') {
      return deserialize<_i5.AppNotFoundException>(data['data']);
    }
    if (dataClassName == 'AppPermissionException') {
      return deserialize<_i6.AppPermissionException>(data['data']);
    }
    if (dataClassName == 'Attachment') {
      return deserialize<_i7.Attachment>(data['data']);
    }
    if (dataClassName == 'AuthResponse') {
      return deserialize<_i8.AuthResponse>(data['data']);
    }
    if (dataClassName == 'Board') {
      return deserialize<_i9.Board>(data['data']);
    }
    if (dataClassName == 'BoardCard') {
      return deserialize<_i10.BoardCard>(data['data']);
    }
    if (dataClassName == 'BoardDetails') {
      return deserialize<_i11.BoardDetails>(data['data']);
    }
    if (dataClassName == 'BoardList') {
      return deserialize<_i12.BoardList>(data['data']);
    }
    if (dataClassName == 'BoardMember') {
      return deserialize<_i13.BoardMember>(data['data']);
    }
    if (dataClassName == 'BoardMemberDetails') {
      return deserialize<_i14.BoardMemberDetails>(data['data']);
    }
    if (dataClassName == 'CardLabel') {
      return deserialize<_i15.CardLabel>(data['data']);
    }
    if (dataClassName == 'CheckList') {
      return deserialize<_i16.CheckList>(data['data']);
    }
    if (dataClassName == 'CheckListItem') {
      return deserialize<_i17.CheckListItem>(data['data']);
    }
    if (dataClassName == 'Comment') {
      return deserialize<_i18.Comment>(data['data']);
    }
    if (dataClassName == 'CommentWithAuthor') {
      return deserialize<_i19.CommentWithAuthor>(data['data']);
    }
    if (dataClassName == 'Label') {
      return deserialize<_i20.Label>(data['data']);
    }
    if (dataClassName == 'RandomAppException') {
      return deserialize<_i21.RandomAppException>(data['data']);
    }
    if (dataClassName == 'User') {
      return deserialize<_i22.User>(data['data']);
    }
    if (dataClassName == 'UserToken') {
      return deserialize<_i23.UserToken>(data['data']);
    }
    if (dataClassName == 'Workspace') {
      return deserialize<_i24.Workspace>(data['data']);
    }
    if (dataClassName == 'WorkspaceMember') {
      return deserialize<_i25.WorkspaceMember>(data['data']);
    }
    if (dataClassName == 'WorkspaceMemberDetails') {
      return deserialize<_i26.WorkspaceMemberDetails>(data['data']);
    }
    return super.deserializeByClassName(data);
  }
}

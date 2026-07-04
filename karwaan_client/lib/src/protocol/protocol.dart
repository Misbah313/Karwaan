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
import 'board_analytics.dart' as _i10;
import 'board_card.dart' as _i11;
import 'board_card_assignment.dart' as _i12;
import 'board_details.dart' as _i13;
import 'board_list.dart' as _i14;
import 'board_member.dart' as _i15;
import 'board_member_details.dart' as _i16;
import 'card_label.dart' as _i17;
import 'checklist.dart' as _i18;
import 'checklist_item.dart' as _i19;
import 'comment.dart' as _i20;
import 'comment_withauthor.dart' as _i21;
import 'label.dart' as _i22;
import 'overall_analytics.dart' as _i23;
import 'pinned_board.dart' as _i24;
import 'random_app_exception.dart' as _i25;
import 'user.dart' as _i26;
import 'user_recent_boards.dart' as _i27;
import 'user_token.dart' as _i28;
import 'workspace.dart' as _i29;
import 'workspace_member.dart' as _i30;
import 'workspace_member_details.dart' as _i31;
import 'package:karwaan_client/src/protocol/board_analytics.dart' as _i32;
import 'package:karwaan_client/src/protocol/attachment.dart' as _i33;
import 'package:karwaan_client/src/protocol/board_card.dart' as _i34;
import 'package:karwaan_client/src/protocol/board_card_assignment.dart' as _i35;
import 'package:karwaan_client/src/protocol/user.dart' as _i36;
import 'package:karwaan_client/src/protocol/board_details.dart' as _i37;
import 'package:karwaan_client/src/protocol/board_list.dart' as _i38;
import 'package:karwaan_client/src/protocol/board_member_details.dart' as _i39;
import 'package:karwaan_client/src/protocol/label.dart' as _i40;
import 'package:karwaan_client/src/protocol/checklist.dart' as _i41;
import 'package:karwaan_client/src/protocol/checklist_item.dart' as _i42;
import 'package:karwaan_client/src/protocol/comment_withauthor.dart' as _i43;
import 'package:karwaan_client/src/protocol/board.dart' as _i44;
import 'package:karwaan_client/src/protocol/workspace.dart' as _i45;
import 'package:karwaan_client/src/protocol/workspace_member_details.dart'
    as _i46;
import 'package:serverpod_auth_client/serverpod_auth_client.dart' as _i47;
export 'greeting.dart';
export 'app_auth_exception.dart';
export 'app_exception.dart';
export 'app_not_found_exception.dart';
export 'app_permission_exception.dart';
export 'attachment.dart';
export 'auth_response.dart';
export 'board.dart';
export 'board_analytics.dart';
export 'board_card.dart';
export 'board_card_assignment.dart';
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
export 'overall_analytics.dart';
export 'pinned_board.dart';
export 'random_app_exception.dart';
export 'user.dart';
export 'user_recent_boards.dart';
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
    if (t == _i10.BoardAnalytics) {
      return _i10.BoardAnalytics.fromJson(data) as T;
    }
    if (t == _i11.BoardCard) {
      return _i11.BoardCard.fromJson(data) as T;
    }
    if (t == _i12.BoardCardAssignment) {
      return _i12.BoardCardAssignment.fromJson(data) as T;
    }
    if (t == _i13.BoardDetails) {
      return _i13.BoardDetails.fromJson(data) as T;
    }
    if (t == _i14.BoardList) {
      return _i14.BoardList.fromJson(data) as T;
    }
    if (t == _i15.BoardMember) {
      return _i15.BoardMember.fromJson(data) as T;
    }
    if (t == _i16.BoardMemberDetails) {
      return _i16.BoardMemberDetails.fromJson(data) as T;
    }
    if (t == _i17.CardLabel) {
      return _i17.CardLabel.fromJson(data) as T;
    }
    if (t == _i18.CheckList) {
      return _i18.CheckList.fromJson(data) as T;
    }
    if (t == _i19.CheckListItem) {
      return _i19.CheckListItem.fromJson(data) as T;
    }
    if (t == _i20.Comment) {
      return _i20.Comment.fromJson(data) as T;
    }
    if (t == _i21.CommentWithAuthor) {
      return _i21.CommentWithAuthor.fromJson(data) as T;
    }
    if (t == _i22.Label) {
      return _i22.Label.fromJson(data) as T;
    }
    if (t == _i23.OverAllAnalytics) {
      return _i23.OverAllAnalytics.fromJson(data) as T;
    }
    if (t == _i24.PinnedBoard) {
      return _i24.PinnedBoard.fromJson(data) as T;
    }
    if (t == _i25.RandomAppException) {
      return _i25.RandomAppException.fromJson(data) as T;
    }
    if (t == _i26.User) {
      return _i26.User.fromJson(data) as T;
    }
    if (t == _i27.UserRecentBoards) {
      return _i27.UserRecentBoards.fromJson(data) as T;
    }
    if (t == _i28.UserToken) {
      return _i28.UserToken.fromJson(data) as T;
    }
    if (t == _i29.Workspace) {
      return _i29.Workspace.fromJson(data) as T;
    }
    if (t == _i30.WorkspaceMember) {
      return _i30.WorkspaceMember.fromJson(data) as T;
    }
    if (t == _i31.WorkspaceMemberDetails) {
      return _i31.WorkspaceMemberDetails.fromJson(data) as T;
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
    if (t == _i1.getType<_i10.BoardAnalytics?>()) {
      return (data != null ? _i10.BoardAnalytics.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i11.BoardCard?>()) {
      return (data != null ? _i11.BoardCard.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i12.BoardCardAssignment?>()) {
      return (data != null ? _i12.BoardCardAssignment.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i13.BoardDetails?>()) {
      return (data != null ? _i13.BoardDetails.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i14.BoardList?>()) {
      return (data != null ? _i14.BoardList.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i15.BoardMember?>()) {
      return (data != null ? _i15.BoardMember.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i16.BoardMemberDetails?>()) {
      return (data != null ? _i16.BoardMemberDetails.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i17.CardLabel?>()) {
      return (data != null ? _i17.CardLabel.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i18.CheckList?>()) {
      return (data != null ? _i18.CheckList.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i19.CheckListItem?>()) {
      return (data != null ? _i19.CheckListItem.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i20.Comment?>()) {
      return (data != null ? _i20.Comment.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i21.CommentWithAuthor?>()) {
      return (data != null ? _i21.CommentWithAuthor.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i22.Label?>()) {
      return (data != null ? _i22.Label.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i23.OverAllAnalytics?>()) {
      return (data != null ? _i23.OverAllAnalytics.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i24.PinnedBoard?>()) {
      return (data != null ? _i24.PinnedBoard.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i25.RandomAppException?>()) {
      return (data != null ? _i25.RandomAppException.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i26.User?>()) {
      return (data != null ? _i26.User.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i27.UserRecentBoards?>()) {
      return (data != null ? _i27.UserRecentBoards.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i28.UserToken?>()) {
      return (data != null ? _i28.UserToken.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i29.Workspace?>()) {
      return (data != null ? _i29.Workspace.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i30.WorkspaceMember?>()) {
      return (data != null ? _i30.WorkspaceMember.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i31.WorkspaceMemberDetails?>()) {
      return (data != null ? _i31.WorkspaceMemberDetails.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<Map<String, int>?>()) {
      return (data != null
          ? (data as Map).map(
              (k, v) => MapEntry(deserialize<String>(k), deserialize<int>(v)))
          : null) as T;
    }
    if (t == _i1.getType<List<int>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<int>(e)).toList()
          : null) as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == _i1.getType<Map<String, int>?>()) {
      return (data != null
          ? (data as Map).map(
              (k, v) => MapEntry(deserialize<String>(k), deserialize<int>(v)))
          : null) as T;
    }
    if (t == _i1.getType<Map<String, int>?>()) {
      return (data != null
          ? (data as Map).map(
              (k, v) => MapEntry(deserialize<String>(k), deserialize<int>(v)))
          : null) as T;
    }
    if (t == List<_i32.BoardAnalytics>) {
      return (data as List)
          .map((e) => deserialize<_i32.BoardAnalytics>(e))
          .toList() as T;
    }
    if (t == List<int>) {
      return (data as List).map((e) => deserialize<int>(e)).toList() as T;
    }
    if (t == List<_i33.Attachment>) {
      return (data as List).map((e) => deserialize<_i33.Attachment>(e)).toList()
          as T;
    }
    if (t == _i1.getType<List<int>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<int>(e)).toList()
          : null) as T;
    }
    if (t == List<_i34.BoardCard>) {
      return (data as List).map((e) => deserialize<_i34.BoardCard>(e)).toList()
          as T;
    }
    if (t == List<_i35.BoardCardAssignment>) {
      return (data as List)
          .map((e) => deserialize<_i35.BoardCardAssignment>(e))
          .toList() as T;
    }
    if (t == List<_i36.User>) {
      return (data as List).map((e) => deserialize<_i36.User>(e)).toList() as T;
    }
    if (t == List<_i37.BoardDetails>) {
      return (data as List)
          .map((e) => deserialize<_i37.BoardDetails>(e))
          .toList() as T;
    }
    if (t == List<_i38.BoardList>) {
      return (data as List).map((e) => deserialize<_i38.BoardList>(e)).toList()
          as T;
    }
    if (t == List<_i39.BoardMemberDetails>) {
      return (data as List)
          .map((e) => deserialize<_i39.BoardMemberDetails>(e))
          .toList() as T;
    }
    if (t == List<_i40.Label>) {
      return (data as List).map((e) => deserialize<_i40.Label>(e)).toList()
          as T;
    }
    if (t == List<_i41.CheckList>) {
      return (data as List).map((e) => deserialize<_i41.CheckList>(e)).toList()
          as T;
    }
    if (t == List<_i42.CheckListItem>) {
      return (data as List)
          .map((e) => deserialize<_i42.CheckListItem>(e))
          .toList() as T;
    }
    if (t == List<_i43.CommentWithAuthor>) {
      return (data as List)
          .map((e) => deserialize<_i43.CommentWithAuthor>(e))
          .toList() as T;
    }
    if (t == List<_i44.Board>) {
      return (data as List).map((e) => deserialize<_i44.Board>(e)).toList()
          as T;
    }
    if (t == List<_i45.Workspace>) {
      return (data as List).map((e) => deserialize<_i45.Workspace>(e)).toList()
          as T;
    }
    if (t == List<_i46.WorkspaceMemberDetails>) {
      return (data as List)
          .map((e) => deserialize<_i46.WorkspaceMemberDetails>(e))
          .toList() as T;
    }
    try {
      return _i47.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
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
    if (data is _i10.BoardAnalytics) {
      return 'BoardAnalytics';
    }
    if (data is _i11.BoardCard) {
      return 'BoardCard';
    }
    if (data is _i12.BoardCardAssignment) {
      return 'BoardCardAssignment';
    }
    if (data is _i13.BoardDetails) {
      return 'BoardDetails';
    }
    if (data is _i14.BoardList) {
      return 'BoardList';
    }
    if (data is _i15.BoardMember) {
      return 'BoardMember';
    }
    if (data is _i16.BoardMemberDetails) {
      return 'BoardMemberDetails';
    }
    if (data is _i17.CardLabel) {
      return 'CardLabel';
    }
    if (data is _i18.CheckList) {
      return 'CheckList';
    }
    if (data is _i19.CheckListItem) {
      return 'CheckListItem';
    }
    if (data is _i20.Comment) {
      return 'Comment';
    }
    if (data is _i21.CommentWithAuthor) {
      return 'CommentWithAuthor';
    }
    if (data is _i22.Label) {
      return 'Label';
    }
    if (data is _i23.OverAllAnalytics) {
      return 'OverAllAnalytics';
    }
    if (data is _i24.PinnedBoard) {
      return 'PinnedBoard';
    }
    if (data is _i25.RandomAppException) {
      return 'RandomAppException';
    }
    if (data is _i26.User) {
      return 'User';
    }
    if (data is _i27.UserRecentBoards) {
      return 'UserRecentBoards';
    }
    if (data is _i28.UserToken) {
      return 'UserToken';
    }
    if (data is _i29.Workspace) {
      return 'Workspace';
    }
    if (data is _i30.WorkspaceMember) {
      return 'WorkspaceMember';
    }
    if (data is _i31.WorkspaceMemberDetails) {
      return 'WorkspaceMemberDetails';
    }
    className = _i47.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth.$className';
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
    if (dataClassName == 'BoardAnalytics') {
      return deserialize<_i10.BoardAnalytics>(data['data']);
    }
    if (dataClassName == 'BoardCard') {
      return deserialize<_i11.BoardCard>(data['data']);
    }
    if (dataClassName == 'BoardCardAssignment') {
      return deserialize<_i12.BoardCardAssignment>(data['data']);
    }
    if (dataClassName == 'BoardDetails') {
      return deserialize<_i13.BoardDetails>(data['data']);
    }
    if (dataClassName == 'BoardList') {
      return deserialize<_i14.BoardList>(data['data']);
    }
    if (dataClassName == 'BoardMember') {
      return deserialize<_i15.BoardMember>(data['data']);
    }
    if (dataClassName == 'BoardMemberDetails') {
      return deserialize<_i16.BoardMemberDetails>(data['data']);
    }
    if (dataClassName == 'CardLabel') {
      return deserialize<_i17.CardLabel>(data['data']);
    }
    if (dataClassName == 'CheckList') {
      return deserialize<_i18.CheckList>(data['data']);
    }
    if (dataClassName == 'CheckListItem') {
      return deserialize<_i19.CheckListItem>(data['data']);
    }
    if (dataClassName == 'Comment') {
      return deserialize<_i20.Comment>(data['data']);
    }
    if (dataClassName == 'CommentWithAuthor') {
      return deserialize<_i21.CommentWithAuthor>(data['data']);
    }
    if (dataClassName == 'Label') {
      return deserialize<_i22.Label>(data['data']);
    }
    if (dataClassName == 'OverAllAnalytics') {
      return deserialize<_i23.OverAllAnalytics>(data['data']);
    }
    if (dataClassName == 'PinnedBoard') {
      return deserialize<_i24.PinnedBoard>(data['data']);
    }
    if (dataClassName == 'RandomAppException') {
      return deserialize<_i25.RandomAppException>(data['data']);
    }
    if (dataClassName == 'User') {
      return deserialize<_i26.User>(data['data']);
    }
    if (dataClassName == 'UserRecentBoards') {
      return deserialize<_i27.UserRecentBoards>(data['data']);
    }
    if (dataClassName == 'UserToken') {
      return deserialize<_i28.UserToken>(data['data']);
    }
    if (dataClassName == 'Workspace') {
      return deserialize<_i29.Workspace>(data['data']);
    }
    if (dataClassName == 'WorkspaceMember') {
      return deserialize<_i30.WorkspaceMember>(data['data']);
    }
    if (dataClassName == 'WorkspaceMemberDetails') {
      return deserialize<_i31.WorkspaceMemberDetails>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth.')) {
      data['className'] = dataClassName.substring(15);
      return _i47.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }
}

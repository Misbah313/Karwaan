
import 'package:karwaan_flutter/domain/models/auth/auth_user.dart';

abstract class CardAssigneeState {}

class CardAssigneeInitial extends CardAssigneeState {}

class CardAssigneeLoading extends CardAssigneeState {}

class CardAssigneeLoaded extends CardAssigneeState {
  final List<AuthUser> assignees;

  CardAssigneeLoaded(this.assignees);
}

class CardAssigneeError extends CardAssigneeState {
  final String error;

  CardAssigneeError(this.error);
}
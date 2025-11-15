import 'package:flutter_bloc/flutter_bloc.dart';

class MainLayoutCubit extends Cubit<MainLayoutState> {
  MainLayoutCubit() : super(MainLayoutInitial());

  void changeMenu(String menuName) {
    emit(MainLayoutMenuChanged(menuName));
  }
}

abstract class MainLayoutState {}

class MainLayoutInitial extends MainLayoutState {
  final String currentMenu = 'Dashboard';
}

class MainLayoutMenuChanged extends MainLayoutState {
  final String currentMenu;
  
  MainLayoutMenuChanged(this.currentMenu);
}
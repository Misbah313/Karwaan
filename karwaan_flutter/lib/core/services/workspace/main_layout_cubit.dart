import 'package:flutter_bloc/flutter_bloc.dart';

class MainLayoutCubit extends Cubit<MainLayoutState> {
  MainLayoutCubit() : super(MainLayoutInitial());

  void changeMenu(String menuName) {
    emit(MainLayoutMenuChanged(menuName));
  }
}

abstract class MainLayoutState {
  String get currentMenu;
}

class MainLayoutInitial extends MainLayoutState {
  @override
  String get currentMenu => 'Dashboard';
}

class MainLayoutMenuChanged extends MainLayoutState {
  @override
  final String currentMenu;

  MainLayoutMenuChanged(this.currentMenu);
}

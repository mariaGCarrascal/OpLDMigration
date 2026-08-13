import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_5/navegation/navigation_state.dart';

class NavigationCubit extends Cubit<NavigationState> {
  NavigationCubit() : super(const NavigationState());

  void changeTab(int index) {
    emit(NavigationState(index: index));
  }
}
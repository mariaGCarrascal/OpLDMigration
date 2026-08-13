import 'package:equatable/equatable.dart';

class NavigationState extends Equatable {
  final int index;

  const NavigationState({this.index = 2});

  @override
  List<Object> get props => [index];
}
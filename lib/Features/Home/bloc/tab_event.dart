part of 'tab_bloc.dart';

class TabEvent extends Equatable {
  const TabEvent();

  @override
  List<Object> get props => [];
}

class ChangeTab extends TabEvent {
  final int index;

  const ChangeTab(this.index);
}

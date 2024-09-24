part of 'tab_bloc.dart';

// @immutable
// sealed class TabState extends Equatable {}

// final class TabInitial extends TabState {
//   @override
//   List<Object?> get props => [];
// }

// final class TabChanged extends TabState {
//   final int index;

//   @override
//   List<Object?> get props => [index];

//   TabChanged({this.index = 0});
// }

enum TabStatus {
  initial,
  changed,
}

class TabState extends Equatable {
  final TabStatus status;
  final int index;

  const TabState({
    this.status = TabStatus.initial,
    this.index = 0,
  });

  TabState copyWith({
    TabStatus? status,
    int? index,
  }) =>
      TabState(
        index: index ?? this.index,
        status: status ?? this.status,
      );
  @override
  List<Object?> get props => [status, index];
}

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'tab_event.dart';
part 'tab_state.dart';

class TabBloc extends Bloc<TabEvent, TabState> {
  TabBloc() : super(const TabState()) {
    on<ChangeTab>(_changeTab);
  }

  _changeTab(ChangeTab event, Emitter<TabState> emit) {
    emit(state.copyWith(status: TabStatus.changed, index: event.index));
  }
}

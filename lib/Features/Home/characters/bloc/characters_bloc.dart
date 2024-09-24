import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:think/Core/Models/character_model.dart';
import 'package:think/Core/data/API/api_manager.dart';
import 'package:think/Features/Home/characters/bloc/characters_event.dart';
import 'package:think/Features/Home/characters/bloc/characters_state.dart';

class CharactersBloc extends Bloc<CharactersEvent, CharactersState> {
  CharactersBloc() : super(const CharactersState()) {
    on<GetCharacters>(_getCharacters);
    on<SearchForCharacters>(_searchForCharacters);
    on<ClearCharacters>(clearCharacters);
  }

  Future<void> _getCharacters(
    GetCharacters event,
    Emitter<CharactersState> emit,
  ) async {
    emit(state.copyWith(status: CharactersStatus.loading));
    try {
      Characters? characters = await ApiManager.getCharacters();

      emit(state.copyWith(
        status: CharactersStatus.success,
        characters: characters,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: CharactersStatus.error,
        message: e.toString(),
      ));
    }
  }

  Future<void> _searchForCharacters(
      SearchForCharacters event, Emitter<CharactersState> emit) async {
    List<Result> searchedCharacters = [];
    try {
      searchedCharacters = state.characters?.results
              .where((character) => character.name
                  .toLowerCase()
                  .contains(event.searchedCharacter))
              .toList() ??
          [];
      emit(state.copyWith(
        status: CharactersStatus.searching,
        searchedCharacters: searchedCharacters,
      ));
    } catch (e) {
      emit(state.copyWith(
          status: CharactersStatus.error, message: e.toString()));
    }
  }

  Future<void> clearCharacters(
      ClearCharacters event, Emitter<CharactersState> emit) async {
    emit(state.copyWith(
      status: CharactersStatus.clear,
    ));
  }
}

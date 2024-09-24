import 'package:equatable/equatable.dart';
import 'package:think/Core/Models/character_model.dart';

enum CharactersStatus {
  initial,
  loading,
  success,
  error,
  searching,
  clear,
}

class CharactersState extends Equatable {
  final Characters? characters;
  final String message;
  final CharactersStatus status;
  final List<Result>? searchedCharacters;
  final List<Result>? localCharacters;

  const CharactersState({
    this.localCharacters,
    this.searchedCharacters,
    this.characters,
    this.message = '',
    this.status = CharactersStatus.initial,
  });

  CharactersState copyWith(
          {CharactersStatus? status,
          String? message,
          Characters? characters,
          List<Result>? localCharacters,
          List<Result>? searchedCharacters}) =>
      CharactersState(
        status: status ?? this.status,
        message: message ?? this.message,
        characters: characters ?? this.characters,
        searchedCharacters: searchedCharacters ?? this.searchedCharacters,
        localCharacters: localCharacters ?? this.localCharacters,
      );

  @override
  List<Object?> get props =>
      [status, characters, message, searchedCharacters, localCharacters];
}

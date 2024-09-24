import 'package:think/Core/Models/character_model.dart';

abstract class CharactersEvent {}

class GetCharacters extends CharactersEvent {}

class SearchForCharacters extends CharactersEvent {
  String searchedCharacter;
  SearchForCharacters({
    required this.searchedCharacter,
  });
}

class ClearCharacters extends CharactersEvent {
  ClearCharacters();
}

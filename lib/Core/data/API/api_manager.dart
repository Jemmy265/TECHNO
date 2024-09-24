import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:think/Core/Models/character_model.dart';

class ApiManager {
  static Future<Characters?> getCharacters() async {
    const String baseUrl = 'rickandmortyapi.com';

    var url = Uri.https(baseUrl, '/api/character');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return charactersFromJson(response.body);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }
}

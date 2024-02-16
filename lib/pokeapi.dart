import 'dart:convert';
import 'package:http/http.dart' as http;

class Pokemon {
  final String name;
  final int dexNumber;

  const Pokemon({required this.name, required this.dexNumber});

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'name': String name,
        'id': int id,
      } =>
        Pokemon(name: name, dexNumber: id),
      _ => throw const FormatException('Failed to parse Pokemon'),
    };
  }
}

class PokemonDetail {
  final String name;
  final int dexNumber;
  final int height;
  final int weight;
  final int baseExperience;

  const PokemonDetail(
      {required this.name,
      required this.dexNumber,
      required this.height,
      required this.weight,
      required this.baseExperience});

  factory PokemonDetail.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'name': String name,
        'id': int dexNumber,
        'height': int height,
        'weight': int weight,
        'base_experience': int baseExperience
      } =>
        PokemonDetail(
            name: name,
            dexNumber: dexNumber,
            weight: weight,
            height: height,
            baseExperience: baseExperience),
      _ => throw const FormatException('Failed to parse Pokemon'),
    };
  }
}

Future<PokemonDetail> fetchPokemon(int dexNumber) async {
  final pokemonResponse =
      await http.get(Uri.parse('https://pokeapi.co/api/v2/pokemon/$dexNumber'));

  if (pokemonResponse.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    // print(jsonDecode(response.body));
    return PokemonDetail.fromJson(jsonDecode(pokemonResponse.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to get pokemon');
  }
}

Future<List<Pokemon>> fetchPokemons() async {
  List<Pokemon> pokemons = [];

  for (int i = 1; i < 7; i++) {
    final url = 'https://pokeapi.co/api/v2/pokemon/$i';
    final pokemonResponse = await http.get(Uri.parse(url));

    if (pokemonResponse.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      // print(jsonDecode(response.body));
      final pokemon = Pokemon.fromJson(jsonDecode(pokemonResponse.body));
      pokemons.add(pokemon);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to get pokemon');
    }
  }

  return pokemons;
}

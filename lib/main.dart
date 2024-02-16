import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Mons'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<List<Pokemon>> futurePokemons;
  var selectedPokemon = <int, bool>{};

  void toggleSelection(int dexNumber, bool isSelected) {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values.
      selectedPokemon[dexNumber] = isSelected;
    });
  }

  @override
  void initState() {
    super.initState();
    futurePokemons = fetchPokemons();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        backgroundColor: Colors.blueGrey,
        appBar: AppBar(
          // TRY THIS: Try changing the color here to a specific color (to
          // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
          // change color while the other colors stay the same.
          backgroundColor:
              Colors.black54, //Theme.of(context).colorScheme.inversePrimary,
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
          foregroundColor: Colors.white,
        ),
        body: FutureBuilder<List<Pokemon>>(
            future: futurePokemons,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final item = snapshot.data![index];

                      return Card(
                          color: Colors.black54,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ListTile(
                                textColor: Colors.white,
                                leading: Image.network(
                                    'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/${item.dexNumber}.png'),
                                title: Text(item.name.capitalize()),
                                subtitle:
                                    Text('# ${item.dexNumber.toString()}'),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  IconButton(
                                    icon: const Image(
                                        image:
                                            AssetImage('images/pokeball.png')),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                PokemonDetailPage(
                                                    title: item.name,
                                                    dexNumber: item.dexNumber)),
                                      );
                                    },
                                  ),
                                  Switch(
                                      value: selectedPokemon[item.dexNumber] ==
                                          true,
                                      onChanged: (bool? isSelected) {
                                        toggleSelection(item.dexNumber,
                                            isSelected ?? false);
                                      }),
                                  const SizedBox(width: 8),
                                ],
                              ),
                            ],
                          ));
                    });
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }

              // By default, show a loading spinner.
              return const CircularProgressIndicator();
            })
        // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}

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

class PokemonDetailPage extends StatefulWidget {
  final String title;
  final int dexNumber;

  const PokemonDetailPage(
      {super.key, required this.title, required this.dexNumber});

  @override
  State<PokemonDetailPage> createState() => _PokemonDetailPageState();
}

class _PokemonDetailPageState extends State<PokemonDetailPage> {
  late Future<PokemonDetail> pokemon;

  @override
  void initState() {
    super.initState();
    pokemon = fetchPokemon(widget.dexNumber);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blueGrey,
        appBar: AppBar(
          // TRY THIS: Try changing the color here to a specific color (to
          // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
          // change color while the other colors stay the same.
          backgroundColor:
              Colors.black54, //Theme.of(context).colorScheme.inversePrimary,
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title.capitalize()),
          foregroundColor: Colors.white,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 30,
            ),
            const SizedBox(width: double.infinity),
            Card(
              color: Colors.black54,
              child: Row(children: [
                Image.network(
                    'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/${widget.dexNumber}.png'),
                FutureBuilder<PokemonDetail>(
                    future: pokemon,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              Text(
                                widget.title.capitalize(),
                                style: const TextStyle(color: Colors.white),
                              ),
                              Text(
                                '# ${widget.dexNumber}',
                                style: const TextStyle(color: Colors.white),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                'Height: ${snapshot.data!.height.toString()}',
                                style: const TextStyle(color: Colors.white),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                'Weight: ${snapshot.data!.weight.toString()}',
                                style: const TextStyle(color: Colors.white),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                'Base Experience: ${snapshot.data!.baseExperience.toString()}',
                                style: const TextStyle(color: Colors.white),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                            ]);
                      } else if (snapshot.hasError) {
                        return Text(snapshot.error.toString());
                      }
                      return const Text('');
                    }),
              ]),
            )
          ],
        )
        //
        );
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

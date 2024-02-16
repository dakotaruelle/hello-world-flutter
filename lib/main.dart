import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'pokeapi.dart';
import 'pokemon_detail_page.dart';
import 'extensions.dart';
import 'pokemon_state.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => PokemonState(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Mons'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({super.key, required this.title});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<List<Pokemon>> futurePokemons;

  @override
  void initState() {
    super.initState();
    futurePokemons = fetchPokemons();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blueGrey,
        appBar: AppBar(
          backgroundColor: Colors.black54,
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
                                  Consumer<PokemonState>(
                                    builder: (context, pokemonState, child) {
                                      return Switch(
                                          value: pokemonState.getSelectionState(
                                                  item.dexNumber) ==
                                              true,
                                          onChanged: (bool? isSelected) {
                                            pokemonState.toggleSelection(
                                                item.dexNumber,
                                                isSelected ?? false);
                                          });
                                    },
                                  ),
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

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'extensions.dart';
import 'pokeapi.dart';
import 'pokemon_state.dart';

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
                              Consumer<PokemonState>(
                                builder: (context, pokemonState, child) {
                                  return Switch(
                                      value: pokemonState.getSelectionState(
                                              widget.dexNumber) ==
                                          true,
                                      onChanged: (bool? isSelected) {
                                        pokemonState.toggleSelection(
                                            widget.dexNumber,
                                            isSelected ?? false);
                                      });
                                },
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

import 'package:flutter/material.dart';
import 'package:flutter_pokemon/widgets/create_pokemon_card.dart';
import 'package:flutter_pokemon/widgets/menu.dart';
import 'package:flutter_pokemon/mocks/pokemon_mock.dart';
import 'package:google_fonts/google_fonts.dart';

class PokemonList extends StatelessWidget {
  const PokemonList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pokedex', 
          style: GoogleFonts.pressStart2p(fontSize: 16),
          ),
        centerTitle: true,
        leadingWidth: 40,
        toolbarHeight: 80,
        backgroundColor: Colors.red[400],
        shadowColor: Colors.purple[400],
        elevation: 5,
      ),
      drawer: Menu(),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: listarPokemones()
        )
    );
  }

  GridView listarPokemones() {
  return GridView.count(
    crossAxisCount: 2, // num columnas
    children: List.generate(elements.length, (index) {
      var pokemon = elements[index];
      int id = pokemon[0];
      String name = pokemon[1];
      int xp = pokemon[2];
      String sprite = pokemon[3];

      return PokemonCard(id: id, name: name, sprite: sprite, xp: xp,);
    }),
  );
}
  }
import 'package:flutter/material.dart';
import 'package:flutter_pokemon/helpers/pokemon_preferences.dart';
import 'package:flutter_pokemon/screens/habilidades_screen.dart';
import 'package:flutter_pokemon/screens/pokemon_list.dart';
import 'package:flutter_pokemon/widgets/create_pokemon_card.dart';
import 'package:flutter_pokemon/widgets/menu.dart';
import 'dart:developer';
import 'package:flutter_pokemon/mocks/pokemon_mock.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    log(' ${size.width} ${size.height}');

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
      body:  SingleChildScrollView(
        child: Column(
        children: [
          CarusselImagenes(size: size),
          const Divider(thickness: 3),
          Padding(
            padding: const EdgeInsets.all(10),
            child: HorizontalSwipper(size: size, lista:elements, titulo: 'Lista de Pokemones', vinculo: const PokemonList())
            ),
            const Divider(thickness: 3),
            const Padding(
              padding: EdgeInsets.all(10),
              child: SwipperHeader(titulo: 'Habilidades', vinculo: PokemonListScreen())),
              const Divider(thickness: 3),
          Padding(
            padding: const EdgeInsets.all(10),
            child: HorizontalSwipper(size: size, lista:PokemonPreferences.getAllFavouritePokemon(), titulo: 'Favoritos', vinculo: null)
            ),
            const SizedBox(height: 20)
        ],
        ),
      )
    );
  }
}

//carrusel de imagenes
class CarusselImagenes extends StatelessWidget {
  const CarusselImagenes({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
          items: [
            // aca van las rutas de las imagenes, fijarme is puedo ponerle el loading
            Image.asset('assets/logo.png'),
            Image.asset('assets/icon_pokeball.png'),
          ],
          options: CarouselOptions(
            height: size.height * 0.30, 
            enlargeCenterPage: true,
            autoPlay: true,
            enableInfiniteScroll: true,
            autoPlayInterval: const Duration(seconds: 3),
            viewportFraction: 0.8, 
          )
    );
  }
}


// swippers
class HorizontalSwipper extends StatelessWidget {
  const HorizontalSwipper({
    super.key,
    required this.size,
    required this.lista,
    required this.titulo,
    required this.vinculo,
  });

  final Size size;
  final List lista;
  final String titulo;
  final Widget? vinculo;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: size.height * 0.35,
      child: Column(
        crossAxisAlignment:  CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SwipperHeader(titulo: titulo, vinculo: vinculo),
            ),
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: lista.length,
              itemBuilder: (context, index) {
                var pokemon = lista[index];
                int id = pokemon[0];
                String name = pokemon[1];
                int xp = pokemon[2];  
                String sprite = pokemon[3];
                
                return PokemonCard(id: id, name: name, sprite: sprite, xp: xp);
              },
            )
            )
        ],
      ),
    );
  }
}

class SwipperHeader extends StatelessWidget {
  const SwipperHeader({
    super.key,
    required this.titulo,
    required this.vinculo,
  });

  final String titulo;
  final Widget? vinculo;

  //agregarlo de los size y extended

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(titulo, style: GoogleFonts.pressStart2p(fontSize: 12)),
         if (vinculo != null)
         ElevatedButton(
          onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => vinculo!),
        );
      },
          child: Text('Ver todos', style: GoogleFonts.pressStart2p(fontSize: 8))
        ),
      ],
    );
  }
}

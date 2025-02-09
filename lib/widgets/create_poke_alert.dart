import 'package:flutter/material.dart';
import 'package:flutter_pokemon/helpers/pokemon_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

class PokemonAlert extends StatefulWidget {
  int id;
  String name;
  int xp;
  String sprite;

  PokemonAlert({super.key, required this.id, required this.name, required this.xp, required this.sprite});

  @override
  State<PokemonAlert> createState() => _PokemonAlertState();
}

class _PokemonAlertState extends State<PokemonAlert> {
  late bool isFavourite;
  late String apodo;

  final TextEditingController _apodoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    isFavourite = PokemonPreferences.isFavourite(widget.id);
    apodo = PokemonPreferences.getApodo(widget.id);
    _apodoController.text = apodo;
  }
  
  void _onFavouriteChanged(bool value) {
    setState(() {
      isFavourite = value;
    });
    PokemonPreferences.setFavourite(widget.id, value);
  }

  void _onApodoChanged(String value) {
    setState(() {
      apodo = value;
    });
    PokemonPreferences.setApodo(widget.id, value);
  }  
  
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: 5,
      title: Text('Información del Pokémon', style: GoogleFonts.pressStart2p(fontSize: 16)),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusDirectional.circular(10),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ContenidoPokeAlerta(id: widget.id, sprite: widget.sprite, name: widget.name, xp: widget.xp),
          const SizedBox(height: 10),
          const Divider(thickness: 3),
          Column(
            children: [
              Text(
                'Agregar a favoritos:',
                style: GoogleFonts.pressStart2p(fontSize: 12)),
              Switch(
                value: isFavourite, 
                onChanged: _onFavouriteChanged,
                ),
            ],
          ),
          TextFormField(
            textAlign: TextAlign.center,
            controller: _apodoController,
            onChanged: _onApodoChanged,
            style: GoogleFonts.pressStart2p(fontSize: 12),
            decoration: InputDecoration(
              label: 
              Text(
                'Apodo del Pokemon:', 
                style: GoogleFonts.pressStart2p(fontSize: 14),
                //agregar algo para que quede centrado este texto
                )
                ),
            )
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Volver', style: GoogleFonts.pressStart2p(fontSize: 16)),
        ),
      ],
    );
  }
}

class ContenidoPokeAlerta extends StatefulWidget {
  const ContenidoPokeAlerta({
    super.key,
    required this.id,
    required this.sprite,
    required this.name,
    required this.xp,
  });

  final int id;
  final String sprite;
  final String name;
  final int xp;

  @override
  State<ContenidoPokeAlerta> createState() => _ContenidoPokeAlertaState();
}

class _ContenidoPokeAlertaState extends State<ContenidoPokeAlerta> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Colors.purple[400],
      elevation: 10,
    
      child:  Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '#${widget.id}',
                    textAlign: TextAlign.start,
                    style: GoogleFonts.pressStart2p(),
                    ),
                    _buildFavorite(widget.id),
                ],
              ),
              FadeInImage.assetNetwork(
                placeholder: 'assets/loading_pokeball.gif',
                image: widget.sprite,
                height: 150,
                width: 150,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 10),
              Text(widget.name, style: GoogleFonts.pressStart2p(fontSize: 18)),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                Text('XP: ', style: GoogleFonts.pressStart2p(fontSize: 16)),
                Text('${widget.xp}', style: GoogleFonts.pressStart2p(fontSize: 16)),
          ],
        ),
      ],
      )
      )
    );
  }
}

Widget _buildFavorite(int id) {
  bool isFavorite = PokemonPreferences.isFavourite(id);

  return Icon(
    isFavorite ? Icons.star : Icons.star_border,
    color: isFavorite ? Colors.yellow : Colors.grey,
    size: 30,
  );
}

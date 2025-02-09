import 'package:flutter/material.dart';
import 'package:flutter_pokemon/helpers/pokemon_preferences.dart';
import 'package:flutter_pokemon/widgets/create_poke_alert.dart';
import 'package:google_fonts/google_fonts.dart';

class PokemonCard extends StatefulWidget {
  int id;
  String name;
  String sprite;
  int xp;

  PokemonCard({super.key, required this.id, required this.name, required this.sprite, required this.xp});

  @override
  State<PokemonCard> createState() => _PokemonCardState();
}

class _PokemonCardState extends State<PokemonCard> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _animationController.forward().then((_) {
          _animationController.reverse();
        });
        Future.delayed(const Duration(milliseconds: 200), () {
          _PokemonAlert(context, widget.id, widget.name, widget.sprite, widget.xp);
        });
      },
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          );
        },
      child: Card(
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
                    height: 100,
                    width: 100,
                    fit: BoxFit.contain,
                  ),
                  Expanded(
                    child: Container(
                      width: 150,
                      height: 45,
                      decoration: BoxDecoration(
                        color: Colors.blue[200],
                        border: Border.all(
                      ),
                      borderRadius: BorderRadius.circular(10)
                  ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.name,
                            style: GoogleFonts.pressStart2p(),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
          ),
        ),
      )
    );
  }
}

void _PokemonAlert(BuildContext context, int id, String name, String sprite, int xp) {
   showDialog(
    context: context,
    builder: (BuildContext context) {
      return PokemonAlert(
        id: id,  
        name: name,
        sprite: sprite,
        xp: xp,
      );
    },
  );

}

Widget _buildFavorite(int id) {
  bool isFavorite = PokemonPreferences.isFavourite(id);

  return Icon(
    isFavorite ? Icons.star : Icons.star_border,
    color: isFavorite ? Colors.yellow : Colors.grey,
    size: 30,
  );
}
  

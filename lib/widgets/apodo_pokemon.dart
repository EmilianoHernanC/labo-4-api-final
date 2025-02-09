import 'package:flutter/material.dart';

class ApodoPokemon extends StatefulWidget {
  const ApodoPokemon({super.key});

  @override
  ApodoPokemonState createState() => ApodoPokemonState();
}

class ApodoPokemonState extends State<ApodoPokemon> {
  String apodo = '';

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Ingresa un apodo',
      ),
      onChanged: (value) {
        setState(() {
          apodo = value;
        });
      },
    );
  }
}
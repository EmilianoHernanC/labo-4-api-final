  import 'dart:convert';
  import 'package:flutter/foundation.dart';
  import 'package:http/http.dart' as http;
  import 'package:flutter_dotenv/flutter_dotenv.dart';

  class PokemonApiService {
    static const String _pokeApiBaseUrl = 'https://pokeapi.co/api/v2';
    static final String? _customApiBaseUrl = dotenv.env['API_URL'];

    Future<List<String>> getPokemonMoves() async {
      final url = Uri.parse('$_customApiBaseUrl/movimientos-totales'); // Llamando a tu API

      try {
        final response = await http.get(url);

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          return List<String>.from(data['data']); // Usando la estructura de respuesta de tu API
        } else {
          throw Exception('Error al obtener los movimientos desde la API personalizada');
        }
      } catch (e) {
        if (kDebugMode) {
          print('Error: $e');
        }
        return [];
      }
    }

    /// Obtiene los movimientos desde TU API personalizada
    Future<List<String>> getCustomPokemonMoves() async {
      final url = Uri.parse('$_customApiBaseUrl/movimientos-totales');
      try {
        final response = await http.get(url);

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          return List<String>.from(data['data']); 
        } else {
          throw Exception('Error al obtener los movimientos desde la API personalizada');
        }
      } catch (e) {
        if (kDebugMode) {
          print('Error: $e');
        }
        return [];
      }
    }

    /// Obtiene los detalles de un movimiento por ID desde TU API personalizada
    Future<Map<String, dynamic>> getCustomMoveById(int id) async {
      final url = Uri.parse('$_customApiBaseUrl/$id');
      try {
        final response = await http.get(url);

        if (response.statusCode == 200) {
          return jsonDecode(response.body)['data'];
        } else {
          throw Exception('Movimiento no encontrado en la API personalizada');
        }
      } catch (e) {
        if (kDebugMode) {
          print('Error: $e');
        }
        return {};
      }
    }

    /// Obtiene movimientos filtrados por tipo desde TU API personalizada
    Future<List<Map<String, dynamic>>> getCustomMovesByType(String type) async {
      // Usar allorigins como proxy CORS
      final encodedUrl = Uri.encodeComponent('https://tp-api-pokemon.onrender.com/movimientos/movimientos-tipo?type=$type');
      final url = Uri.parse('https://api.allorigins.win/raw?url=$encodedUrl');
      
      try {
        final response = await http.get(url);

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          return List<Map<String, dynamic>>.from(data['data']);
        } else {
          throw Exception('Error al obtener movimientos por tipo desde la API personalizada');
        }
      } catch (e) {
        return [];
      }
    }

    /// Obtiene la lista de Pokémon desde la API oficial de Pokémon
    Future<List<Map<String, dynamic>>> getAllPokemon() async {
      final url = Uri.parse('$_pokeApiBaseUrl/pokemon?limit=200');
      try {
        final response = await http.get(url);

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final List results = data['results'];

          final detailedPokemon = await Future.wait(results.map((pokemon) async {
            final detailResponse = await http.get(Uri.parse(pokemon['url']));
            if (detailResponse.statusCode == 200) {
              final detailData = jsonDecode(detailResponse.body);
              return {
                'name': detailData['name'],
                'type': detailData['types'][0]['type']['name'],
                'number': detailData['id'],
                'image': detailData['sprites']['front_default'],
                'moves': (detailData['moves'] as List)
                    .map((move) => move['move']['name'].toString())
                    .toList(),
              };
            }
            return null;
          }));

          return detailedPokemon
              .where((pokemon) => pokemon != null)
              .cast<Map<String, dynamic>>()
              .toList();
        } else {
          throw Exception('Error al obtener Pokémon');
        }
      } catch (e) {
        if (kDebugMode) {
          print('Error: $e');
        }
        return [];
      }
    }
  }

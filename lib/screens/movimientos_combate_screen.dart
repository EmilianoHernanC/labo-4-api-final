import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../helpers/habilidades_pokemon.dart';
import 'dart:math';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';



class MCombateScreen extends StatefulWidget {
  const MCombateScreen({super.key});

  @override
  State<MCombateScreen> createState() => _MCombateScreenState();
}



class TypeMatchups {
  static Map<String, List<String>> weaknesses = {
    'fighting': ['normal', 'ice', 'rock', 'dark', 'steel'],
    'fire': ['grass', 'ice', 'bug', 'steel'],
    'water': ['fire', 'ground', 'rock'],
    'electric': ['water', 'flying'],
    'grass': ['water', 'ground', 'rock'],
    'ice': ['grass', 'ground', 'flying', 'dragon'],
    'poison': ['grass', 'fairy'],
    'ground': ['fire', 'electric', 'poison', 'rock', 'steel'],
    'flying': ['grass', 'fighting', 'bug'],
    'psychic': ['fighting', 'poison'],
    'bug': ['grass', 'psychic', 'dark'],
    'rock': ['fire', 'ice', 'flying', 'bug'],
    'ghost': ['psychic', 'ghost'],
    'dragon': ['dragon'],
    'dark': ['psychic', 'ghost'],
    'steel': ['ice', 'rock', 'fairy'],
    'fairy': ['fighting', 'dragon', 'dark']
  };
}

List<String> pokemonTypes = [
  'normal', 'fire', 'water', 'electric', 'grass', 'ice', 
  'poison', 'ground', 'flying', 'psychic', 'bug', 'rock', 
  'ghost', 'dragon', 'dark', 'steel', 'fairy'
];

final Map<String, Map<String, dynamic>> typeData = {
  "fire": {"color": Colors.red, "icon": "assets/fire.svg"},
  "normal": {"color": const Color.fromARGB(255, 253, 252, 252), "icon": "assets/normal.svg"},
  "water": {"color": Colors.blue, "icon": "assets/water.svg"},
  "grass": {"color": Colors.green, "icon": "assets/grass.svg"},
  "electric": {"color": Colors.yellow, "icon": "assets/electric.svg"},
  "ice": {"color": Colors.lightBlue, "icon": "assets/ice.svg"},
  "fighting": {"color": Colors.orange, "icon": "assets/fighting.svg"},
  "poison": {"color": Colors.purple, "icon": "assets/poison.svg"},
  "ground": {"color": Colors.brown, "icon": "assets/ground.svg"},
  "flying": {"color": Colors.cyan, "icon": "assets/flying.svg"},
  "psychic": {"color": Colors.pink, "icon": "assets/psychic.svg"},
  "bug": {"color": Colors.lime, "icon": "assets/bug.svg"},
  "rock": {"color": Colors.grey, "icon": "assets/rock.svg"},
  "ghost": {"color": Colors.indigo, "icon": "assets/ghost.svg"},
  "dragon": {"color": Colors.deepPurple, "icon": "assets/dragon.svg"},
  "dark": {"color": Colors.black, "icon": "assets/dark.svg"},
  "steel": {"color": Colors.blueGrey, "icon": "assets/steel.svg"},
  "fairy": {"color": Colors.pinkAccent, "icon": "assets/fairy.svg"},
};


class TypeFilterScroll extends StatefulWidget {
  final List<String> types;
  final String selectedType;
  final Function(String) onTypeSelected;

  const TypeFilterScroll({
    Key? key, 
    required this.types, 
    required this.selectedType, 
    required this.onTypeSelected
  }) : super(key: key);

  @override
  _TypeFilterScrollState createState() => _TypeFilterScrollState();
}

class _TypeFilterScrollState extends State<TypeFilterScroll> {
  final ScrollController _scrollController = ScrollController();

  void _scrollTypes(bool scrollRight) {
    final scrollAmount = scrollRight ? 200 : -200;
    _scrollController.animateTo(
      _scrollController.offset + scrollAmount,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => _scrollTypes(false),
        ),
        Expanded(
          child: SizedBox(
            height: 50,
            child: ListView.builder(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              itemCount: widget.types.length,
              itemBuilder: (context, index) {
                final type = widget.types[index];
                final typeInfo = typeData[type] ?? {"color": Colors.grey, "icon": "assets/default.svg"};

                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: FilterChip(
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(
                          typeInfo["icon"],
                          height: 20,  // Reduced icon size
                          width: 20,
                          colorFilter: const ColorFilter.mode(
                            Colors.black, 
                            BlendMode.srcIn,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(type),
                      ],
                    ),
                    selected: widget.selectedType == type,
                    backgroundColor: typeData[type]?["color"]?.withOpacity(0.2) ?? Colors.grey.withOpacity(0.2),
                    selectedColor: typeData[type]?["color"] ?? Colors.grey,
                    onSelected: (selected) {
                      widget.onTypeSelected(type);
                    },
                  ),
                );
              },
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.arrow_forward_ios),
          onPressed: () => _scrollTypes(true),
        ),
      ],
    );
  }
}

class _MCombateScreenState extends State<MCombateScreen> {
  final PokemonApiService _apiService = PokemonApiService();
  Map<String, List<Map<String, dynamic>>> pokemonByType = {};
  String selectedType = '';
  Map<String, dynamic>? _attackerPokemon;
  Map<String, dynamic>? _defenderPokemon;

  @override
  void initState() {
    super.initState();
    _loadPokemonData();
    _loadLastSelectedType().then((_) {
      if (selectedType.isNotEmpty) {
        setState(() {});
      }
    });
  }

  Future<void> _saveSelectedType(String type) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedType', type);
  }

  Future<void> _loadLastSelectedType() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedType = prefs.getString('selectedType') ?? '';
    });
  }

  Future<void> _fetchMovesByType(String type) async {
    print("Fetching moves for type: $type");
    try {
      final moves = (await _apiService.getCustomMovesByType(type))
        .map((move) => move['name'].toString())
        .toList();
      print("Moves fetched: ${moves.length}");
    } catch (e) {
      print("Error fetching moves: $e");
    }
  }

  Future<void> _loadPokemonData() async {
    print("Iniciando carga de Pokemon");
    final allPokemon = await _apiService.getAllPokemon();
    print("Pokemon cargados: ${allPokemon.length}");
    
    setState(() {
      for (var pokemon in allPokemon) {
        final type = pokemon['type'];
        if (!pokemonByType.containsKey(type)) {
          pokemonByType[type] = [];
        }
        pokemonByType[type]!.add(pokemon);
      }
    });
    print("Pokemon organizados por tipo");
    
    if (selectedType.isEmpty && pokemonTypes.isNotEmpty) {
      setState(() {
        selectedType = pokemonTypes[0];
      });
      await _fetchMovesByType(selectedType);
    }
  }

  void _selectBattlePokemon(String moveType) {
    if (pokemonByType.isEmpty) return;

    setState(() {
      if (pokemonByType.containsKey(moveType)) {
        final attackers = pokemonByType[moveType]!;
        _attackerPokemon = attackers[Random().nextInt(attackers.length)];
      }

      final weakTypes = TypeMatchups.weaknesses[moveType] ?? [];
      if (weakTypes.isNotEmpty) {
        final weakType = weakTypes[Random().nextInt(weakTypes.length)];
        if (pokemonByType.containsKey(weakType)) {
          final defenders = pokemonByType[weakType]!;
          _defenderPokemon = defenders[Random().nextInt(defenders.length)];
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title: const Text(
        "Movimientos de Combate",
        style: TextStyle(
          fontFamily: 'PressStart2P', // Aplica la fuente aquí
        ),
      ),
    ),
      body: Column(
        children: [
          TypeFilterScroll(
            types: pokemonTypes,
            selectedType: selectedType,
            onTypeSelected: (type) async {
              setState(() {
                selectedType = type;
              });
              await _saveSelectedType(type);
            },
          ),
          Expanded(
            child: selectedType.isEmpty
              ? const Center(
                  child: Text(
                    "Selecciona un tipo de Pokémon",
                    style: TextStyle(
                      fontFamily: 'PressStart2P', // Aplica la fuente aquí
                    ),
                  ),
                )
              : FutureBuilder<List<Map<String, dynamic>>>(
                  future: _apiService.getCustomMovesByType(selectedType),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 16),
                            Text(
                              "Cargando movimientos...",
                              style: TextStyle(
                                fontFamily: 'PressStart2P', // Aplica la fuente aquí
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.error_outline, size: 48, color: Colors.red),
                            SizedBox(height: 16),
                            Text(
                              "Error al cargar los movimientos: ${snapshot.error}",
                              textAlign: TextAlign.center,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {});
                              },
                              child: Text("Reintentar"),
                            ),
                          ],
                        ),
                      );
                    }

                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text("No hay movimientos disponibles para este tipo"),
                      );
                    }

                    final moves = snapshot.data!;
                    return GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1.2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemCount: moves.length,
                      itemBuilder: (context, index) {
                        final move = moves[index];
                        final moveType = selectedType.toLowerCase();
                        final typeColor = typeData[moveType]?['color'] ?? Colors.grey;
                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                              side: BorderSide(color: typeColor, width: 3),
                            ),
                            elevation: 8,
                            child: InkWell(
                              onTap: () {
                                _selectBattlePokemon(selectedType);
                                showDialog(
                                  context: context,
                                  builder: (context) => _buildBattleDialog(move['name']),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      typeColor.withOpacity(0.7),
                                      typeColor.withOpacity(0.3),
                                    ],
                                  ),
                                ),
                                child: Stack(
                                  children: [
                                    Positioned(
                                      right: -20,
                                      bottom: -20,
                                      child: Opacity(
                                        opacity: 0.2,
                                        child: Image.asset(
                                          'assets/icon_pokeball.png',
                                          width: 150,
                                          height: 150,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Align(
                                            alignment: Alignment.topCenter,
                                            child: Image.asset(
                                              'assets/logoPokemon.png',
                                              width: 200,
                                              height: 200,
                                            ),
                                          ),
                                          Expanded(
                                            child: Center(
                                              child: Text(
                                                move['name'],
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.pressStart2p(
                                                  fontSize: 16,
                                                  color: Colors.black,
                                                  shadows: [
                                                    Shadow(
                                                      offset: Offset(2, 2),
                                                      color: Colors.black.withOpacity(0.5),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                      },
                    );
                  },
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildBattleDialog(String moveName) {
    return Dialog(
      child: Container(
        width: double.infinity,
        height: 400,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/campo_batalla.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                'Batalla: $moveName',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      offset: Offset(2.0, 2.0),
                      blurRadius: 3.0,
                      color: Colors.black45,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Text(
                        'VS',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              offset: Offset(2.0, 2.0),
                              blurRadius: 3.0,
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        if (_attackerPokemon != null)
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Transform.scale(
                                  scale: 1.5,
                                  child: Image.network(
                                    _attackerPokemon!['image'],
                                    width: 100,
                                    height: 100,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    _attackerPokemon!['name'].toUpperCase(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      shadows: [
                                        Shadow(
                                          offset: Offset(1.0, 1.0),
                                          blurRadius: 2.0,
                                          color: Colors.black,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        const SizedBox(width: 80),
                        if (_defenderPokemon != null)
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Transform.scale(
                                  scale: 1.5,
                                  child: Transform(
                                    alignment: Alignment.center,
                                    transform: Matrix4.rotationY(3.14159),
                                    child: Image.network(
                                      _defenderPokemon!['image'],
                                      width: 100,
                                      height: 100,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    _defenderPokemon!['name'].toUpperCase(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      shadows: [
                                        Shadow(
                                          offset: Offset(1.0, 1.0),
                                          blurRadius: 2.0,
                                          color: Colors.black,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} // Fin de la clase _MCombateScreenState


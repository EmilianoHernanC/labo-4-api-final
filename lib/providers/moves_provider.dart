import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_pokemon/helpers/habilidades_pokemon.dart';
import 'package:flutter_pokemon/models/pokemon_move.dart';

final movesProvider = StateNotifierProvider<MovesNotifier, MovesState>((ref) {
  return MovesNotifier();
});

class MovesState {
  final List<PokemonMove> moves;
  final String selectedType;
  final bool isLoading;
  final String? error;

  MovesState({
    this.moves = const [],
    this.selectedType = '',
    this.isLoading = false,
    this.error,
  });
}

class MovesNotifier extends StateNotifier<MovesState> {
  final PokemonApiService _apiService = PokemonApiService();

  MovesNotifier() : super(MovesState());

  Future<void> fetchMovesByType(String type) async {
    state = MovesState(
      moves: state.moves,
      selectedType: type,
      isLoading: true,
    );

    try {
      final moves = await _apiService.getCustomMovesByType(type);
      state = MovesState(
        moves: moves.map((m) => PokemonMove.fromJson(m)).toList(),
        selectedType: type,
        isLoading: false,
      );
    } catch (e) {
      state = MovesState(
        moves: [],
        selectedType: type,
        isLoading: false,
        error: 'Error al cargar los movimientos',
      );
    }
  }
}
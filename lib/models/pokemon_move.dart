class PokemonMove {
  final int id;
  final String name;
  final String type;
  final int power;
  final String description;
  
  PokemonMove({
    required this.id,
    required this.name,
    required this.type,
    required this.power,
    required this.description,
  });

  factory PokemonMove.fromJson(Map<String, dynamic> json) {
    return PokemonMove(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      power: json['power'],
      description: json['description'],
    );
  }
}
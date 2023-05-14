import 'package:flutter/material.dart';
import 'package:pokedex/screens/add_pokemon.dart';

class PokemonDetailPage extends StatelessWidget {
  final Pokemon pokemon;
  const PokemonDetailPage({super.key, required this.pokemon});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
          title: Text(pokemon.name),
        backgroundColor: Colors.red,
        centerTitle: true,

      ),
    );
  }
}

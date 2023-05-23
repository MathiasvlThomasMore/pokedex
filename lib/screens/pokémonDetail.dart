// ignore: file_names
// ignore_for_file: unused_import, file_names, duplicate_ignore

import 'package:flutter/material.dart';
import 'package:pokedex/screens/add_pokemon.dart';
import 'package:http/http.dart' as http;

class PokemonDetailPage extends StatelessWidget {
  final Pokemon pokemon;

  const PokemonDetailPage({super.key, required this.pokemon});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pokemon.name),
        backgroundColor: Colors.red,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Center(
              child: Image.network(
                  "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/4.png")),
          Text("Size: "+pokemon.size),
          Text("First element: " + pokemon.element1)
        ],
      ),
    );
  }
}

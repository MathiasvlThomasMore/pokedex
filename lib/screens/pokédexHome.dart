// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pokedex/screens/pok%C3%A9monDetail.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import 'add_pokemon.dart';

class PokedexHome extends StatefulWidget {
  const PokedexHome({Key? key}) : super(key: key);

  @override
  State<PokedexHome> createState() => _PokedexHomeState();
}

class _PokedexHomeState extends State<PokedexHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
          title: const Center(child: Text('Pokédex')),
          backgroundColor: Colors.red),
      body: StreamBuilder(
        stream: readPokemon(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('Couldn\u0027t find any Pokémon :( ');
          } else if (snapshot.hasData) {
            final users = snapshot.data!;
            return GridView.count(
              //amount of cards next to eachother
              crossAxisCount: 2,
              childAspectRatio: (1 / .5),
              children: users.map((e) => buildPokemon(e, context)).toList(),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

Widget buildPokemon(Pokemon pokemon, BuildContext context) => (InkWell(
    onTap: () {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => PokemonDetailPage(
                pokemon: pokemon,
              )));
    },
    child: ListView(
children: [
  Center(child:Text(pokemon.name)),
Text(pokemon.size),
],
    )
    
    ));

Stream<List<Pokemon>> readPokemon() => FirebaseFirestore.instance
    .collection('Pokemon')
    .snapshots()
    .map((snapshot) =>
        snapshot.docs.map((doc) => Pokemon.fromJson(doc.data())).toList());

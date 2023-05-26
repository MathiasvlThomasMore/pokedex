// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../model/pokemon.dart';
import '../widgets/pokemonCard.dart';

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
            actions: const [Icon(MdiIcons.pokeball)],
            centerTitle: true,
            title: Text('Pokédex'),
            backgroundColor: Colors.red),
        body: Column(
          children: [

            Flexible(
              child: StreamBuilder(
                stream: readPokemon(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Couldn\u0027t find any Pokémon :( ');
                  } else if (snapshot.hasData) {
                    final users = snapshot.data!;
                    return GridView.count(
                      //amount of cards next to eachother
                      crossAxisCount: 2,
                      childAspectRatio: (1 / .62),
                      children:
                          users.map((e) => buildPokemon(e, context)).toList(),
                    );
                  } else if (!snapshot.hasData) {
                    return const Center(
                        child: Text(
                            "No pokémon are in the database! Go and some"));
                  } else {
                    return const Center(child: RefreshProgressIndicator());
                  }
                },
              ),
            )
          ],
        ));
  }
}


Stream<List<Pokemon>> readPokemon() => FirebaseFirestore.instance
    .collection('Pokemon')
    .snapshots()
    .map((snapshot) =>
        snapshot.docs.map((doc) => Pokemon.fromJson(doc.data())).toList());

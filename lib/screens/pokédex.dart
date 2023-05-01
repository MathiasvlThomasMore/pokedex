import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pokedex/screens/add_pokemon.dart';

class Pokedex extends StatefulWidget {
  const Pokedex({super.key});

  @override
  State<Pokedex> createState() => _PokedexState();
}

class _PokedexState extends State<Pokedex> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pokédex'),
        centerTitle: true,
        backgroundColor: Colors.red,
        leading: const Icon(MdiIcons.pokeball),
      ),
      body: StreamBuilder(
        stream: readPokemon(),
        builder: (context, snapshot) {
          if(snapshot.hasError){
            return const Text('Couldn\u0027t find any Pokémon :( ');
          }else if (snapshot.hasData) {
              final users = snapshot.data!;
              return ListView(
                children: users.map(buildPokemon).toList(),
              );
          }else{
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddPokemonPage()));
        },
        label: const Text('Add Pokémon'),
        icon: new Icon(MdiIcons.pokemonGo),
        backgroundColor: Colors.red,
      ),
    );
  }
}

Widget buildPokemon(Pokemon pokemon) =>
    (
        ListTile(
          leading: CircleAvatar(child: Text(pokemon.id)),
          title: Text(pokemon.name),
          subtitle: Text(pokemon.size),
        )
    );

Stream<List<Pokemon>> readPokemon() =>
    FirebaseFirestore.instance
        .collection('Pokemon')
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => Pokemon.fromJson(doc.data())).toList());

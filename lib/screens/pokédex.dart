

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pokedex/screens/add_pokemon.dart';
import 'package:pokedex/screens/pok%C3%A9monDetail.dart';
import 'package:quickalert/quickalert.dart';

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

Widget buildPokemon(Pokemon pokemon, BuildContext context) => (
    InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>PokemonDetailPage(pokemon: pokemon,)));
      },
        child: Card(
      elevation: 10.0,
      child: Column(
        children: [
          ListTile(
              title: Text(pokemon.name),
              subtitle: Text(pokemon.size),
              trailing: IconButton(
                  onPressed: () {
                    QuickAlert.show(
                        context: context,
                        type: QuickAlertType.confirm,
                        title: "Sure you want to remove ${pokemon.name}?",
                        onConfirmBtnTap: () {
                          DocumentReference documentReference =
                              FirebaseFirestore.instance
                                  .collection('Pokemon')
                                  .doc(pokemon.id);
                          documentReference.delete();
                          Navigator.pop(context);
                        });
                  },
                  icon: const Icon(Icons.delete))),
        ],
      ),
    )));

Stream<List<Pokemon>> readPokemon() => FirebaseFirestore.instance
    .collection('Pokemon')
    .snapshots()
    .map((snapshot) =>
        snapshot.docs.map((doc) => Pokemon.fromJson(doc.data())).toList());

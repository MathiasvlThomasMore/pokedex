// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pokeball_widget/pokeball_widget.dart';
import 'package:pokedex/screens/edit_pokemon.dart';
import 'package:pokedex/screens/pok%C3%A9monDetail.dart';
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
          actions: const <Widget>[
            Icon(MdiIcons.pokeball),
          ],
          centerTitle: true,
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
          } else if (!snapshot.hasData) {
            return const Center(
                child: Text("No pokémon are in the database! Go and some"));
          } else {
            return const Center(child: RefreshProgressIndicator());
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
    child: Card(
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 8,
      child: LayoutBuilder(
        builder: (context, constraints) => Stack(
          children: [
            Positioned(
              right: constraints.maxWidth * -0.04,
              top: constraints.minHeight * 0.1,
              child: SizedBox(
                height: MediaQuery.of(context).size.height / 6,
                width: MediaQuery.of(context).size.height / 6,
                child: PokeBallWidget(
                  color: Colors.red,
                ),
              ),
            ),
            Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              ListTile(
                  leading: const CircleAvatar(backgroundColor: Colors.red,child: Icon(MdiIcons.pokeball,color: Colors.white,),),
                  title: Text(pokemon.name),
                  subtitle: Text(pokemon.size)),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  //edit and delete button
                  IconButton(onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                          return EditPokemon(pokemon: pokemon);
                        }));

                  }, icon: const Icon(Icons.edit)),
                  IconButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: Text(
                                  "Are you sure you want to delete ${pokemon.name}?"),
                              content: Text(
                                  "${pokemon.name} will be released in the wilderness again!"),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      final docPokemon = FirebaseFirestore
                                          .instance
                                          .collection('Pokemon')
                                          .doc(pokemon.id);

                                      docPokemon.delete();
                                      Navigator.pop(context, 'Ok');
                                    },
                                    child: Text("Ok")),
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context, 'Cancel');
                                    },
                                    child: Text("Cancel"))
                              ],
                            ));
                      },
                      icon: const Icon(Icons.delete))
                ],
              )
              ]
              )

          ],
        ),
      ),)));

Stream<List<Pokemon>> readPokemon() => FirebaseFirestore.instance
    .collection('Pokemon')
    .snapshots()
    .map((snapshot) =>
        snapshot.docs.map((doc) => Pokemon.fromJson(doc.data())).toList());

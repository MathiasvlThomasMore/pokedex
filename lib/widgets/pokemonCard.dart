import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pokeball_widget/pokeball_widget.dart';

import '../model/pokemon.dart';
import '../screens/edit_pokemon.dart';
import '../screens/pokémonDetail.dart';

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
        builder: (context, constraints) => SizedBox(
          height: 200,
          child: Stack(
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
              Wrap(children: <Widget>[
                ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Colors.red,
                      child: Icon(
                        MdiIcons.pokeball,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(
                      pokemon.name,
                      style: const TextStyle(fontFamily: 'Poppins'),
                    ),
                    subtitle: Text(pokemon.size)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    //edit and delete button

                    IconButton(
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                                return EditPokemon(pokemon: pokemon);
                              }));
                        },
                        icon: const Icon(Icons.edit)),
                    IconButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  AlertDialog(
                                    title: Text(
                                        "Are you sure you want to delete ${pokemon.name}?"),
                                    content: Text(
                                        "${pokemon.name} will be released in the wilderness again!"),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            final docPokemon =
                                            FirebaseFirestore
                                                .instance
                                                .collection(
                                                'Pokemon')
                                                .doc(pokemon.id);

                                            docPokemon.delete();
                                            Navigator.pop(
                                                context, 'Ok');
                                          },
                                          child: Text("Ok")),
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(
                                                context, 'Cancel');
                                          },
                                          child: Text("Cancel"))
                                    ],
                                  ));
                        },
                        icon: const Icon(Icons.delete))
                  ],
                )
              ])
            ],
          ),
        )),
  ),
));

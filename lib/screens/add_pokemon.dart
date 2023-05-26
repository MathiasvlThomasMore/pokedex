import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pokedex/screens/pok%C3%A9dexHome.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:audioplayers/audioplayers.dart';
import '../model/pokemon.dart';
import '../widgets/multiselect.dart';

class AddPokemonPage extends StatefulWidget {
  const AddPokemonPage({Key? key}) : super(key: key);

  @override
  State<AddPokemonPage> createState() => _AddPokemonPageState();
}

class _AddPokemonPageState extends State<AddPokemonPage> {
  final AudioPlayer player = AudioPlayer();
  PlatformFile? pickedFile;
  List<dynamic> _selectedItems = [];
  List<dynamic> _selectedPokeballs = [];
  bool _toggle = false;
  final formKey = GlobalKey<FormState>();

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;
    setState(() {
      pickedFile = result.files.first;
    });
  }

  final controllerName = TextEditingController();
  final controllerSize = TextEditingController();
  final controllerBio = TextEditingController();

  final List<String> pokeballList = [
    'Poké Ball',
    'Great Ball',
    'Ultra Ball',
    'Master Ball'
  ];

  void _showMultiSelectItems() async {
    // a list of selectable items
    // these items can be hard-coded or dynamically fetched from a database/API
    final List<String> items = ['Earth', 'Fire', 'Grass', 'Water', 'Air'];

    final List<String>? resultsItems = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return MultiSelect(items: items);
      },
    );
    // Update UI
    if (resultsItems != null) {
      setState(() {
        if (resultsItems.length > 2) {
          print(_selectedItems);
          QuickAlert.show(
              context: context,
              type: QuickAlertType.error,
              title: "You can only select max 2 elements and 1 pokéball type!");
        } else {
          _selectedItems = resultsItems;
        }
      });
    }
  }

  void _showMultiSelectPokeBalls() async {
    // a list of selectable items
    // these items can be hard-coded or dynamically fetched from a database/API
    final List<String> pokeballList = [
      'Poké Ball',
      'Great Ball',
      'Ultra Ball',
      'Master Ball'
    ];

    final List<String>? resultsItems = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return MultiSelect(items: pokeballList);
      },
    );
    // Update UI
    if (resultsItems != null) {
      setState(() {
        if (resultsItems.length > 1) {
          print(_selectedItems);
          QuickAlert.show(
              context: context,
              type: QuickAlertType.error,
              title: "You can only select max 1 pokéball type!");
        } else {
          _selectedPokeballs = resultsItems;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget pokeballAnimated = Image.asset(
      "assets/images/pokeball_icon.png",
      height: 100,
      width: 100,
    );

    return Scaffold(
        backgroundColor: Colors.grey,
        appBar: AppBar(
          title: const Center(child: Text('Adding Pokémon')),
          backgroundColor: Colors.red,
        ),
        body: Form(
          key: formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: <Widget>[
              TextFormField(
                controller: controllerName,
                validator: (value) {
                  if (value != null && value.length < 2) {
                    return 'Enter at least 1 letter';
                  } else if (value == null) {
                    return 'You have to fill in the name!';
                  }
                },
                decoration: const InputDecoration(
                    filled: true, fillColor: Colors.white, label: Text("Name")),
              ),
              const SizedBox(height: 24),
              TextFormField(
                validator: (value) {
                  if (value != null && value.length < 2) {
                    return 'Enter at least 1 letter';
                  } else if (value == null) {
                    return 'You have to fill in the size!';
                  }
                },
                controller: controllerSize,
                decoration: const InputDecoration(
                    filled: true, fillColor: Colors.white, label: Text("Size")),
              ),
              const SizedBox(height: 24),
              TextFormField(
                validator: (value) {
                  if (value != null && value.length < 2) {
                    return 'Enter at least 1 letter';
                  } else if (value == null) {
                    return 'You have to fill in the size!';
                  }
                },
                controller: controllerBio,
                decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    label: Text("Biography")),
                keyboardType: TextInputType.multiline,
                minLines: 5,
                maxLines: 10,
              ),
              const Divider(
                height: 50,
              ),
              InkWell(
                  onTap: _showMultiSelectPokeBalls,
                  child: Column(
                    children: const [
                      Icon(
                        MdiIcons.pokeball,
                        color: Colors.white,
                      ),
                      Text(
                        "Choose Pokéball",
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  )),

              const Divider(
                height: 20,
              ),
              Center(
                child: Wrap(
                  children: _selectedPokeballs
                      .map((e) => Chip(
                            label: Text(e),
                          ))
                      .toList(),
                ),
              ),
              InkWell(
                  onTap: _showMultiSelectItems,
                  child: Column(
                    children: const [
                      Icon(
                        MdiIcons.seedPlusOutline,
                        color: Colors.white,
                      ),
                      Text(
                        "Choose elements",
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  )),
              const Divider(
                height: 20,
              ),
              // display selected items
              Center(
                child: Wrap(
                  children: _selectedItems
                      .map((e) => Chip(
                            label: Text(e),
                          ))
                      .toList(),
                ),
              ),

              Center(
                  child: ElevatedButton(
                      onPressed: () {
                        player.play(AssetSource('audio/pokeball_sound.mp3'),volume: 1);
                        setState(() {
                          _toggle = !_toggle;
                          Timer(Duration(seconds: 6), () {
                            setState(() {
                              final isValidForm =
                                  formKey.currentState!.validate();
                              if (isValidForm) {
                                if(_selectedPokeballs.isEmpty || _selectedItems.isEmpty){
                                  QuickAlert.show(
                                      context: context,
                                      type: QuickAlertType.warning,
                                      title:
                                      "You haven't filled in the data for the pokemon correctly");
                                }
                                if (_selectedItems.first ==
                                    _selectedItems.last) {
                                  final pokemon = Pokemon(
                                      name: controllerName.text,
                                      size: controllerSize.text,
                                      element1: _selectedItems.first,
                                      pokeballType: _selectedPokeballs.first,
                                      element2: '',
                                      bio: controllerBio.text);
                                  createPokemon(pokemon);
                                } else {
                                  final pokemon = Pokemon(
                                      name: controllerName.text,
                                      size: controllerSize.text,
                                      element1: _selectedItems.first,
                                      element2: _selectedItems.last,
                                      pokeballType: _selectedPokeballs.first,
                                      bio: controllerBio.text);
                                  createPokemon(pokemon);
                                }

                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return const PokedexHome();
                                }));
                              } else {
                                QuickAlert.show(
                                    context: context,
                                    type: QuickAlertType.warning,
                                    title:
                                        "You haven't filled in the data for the pokemon correctly");
                              }

                            });
                          });
                        });
                      },
                      child: Text("Add to Pokédex"))),
              pokeballAnimated
                  .animate(target: _toggle ? 1 : 0)
                  .slideY(duration: 300.ms, end: 1)
                  .slideY(duration: 300.ms, delay: 300.ms, end: -1)
                  .then()
                  .slideY(duration: 300.ms, end: 1)
                  .slideY(duration: 300.ms, delay: 300.ms, end: -1)
                  .shake(hz: 3, duration: 800.ms, delay: 2000.ms)
                  .shake(hz: 3, duration: 800.ms, delay: 3500.ms),
            ],
          ),
        ));
  }

  Future createPokemon(Pokemon pokemon) async {
    final docPokemon = FirebaseFirestore.instance.collection("Pokemon").doc();
    pokemon.id = docPokemon.id;

    //Create document and write data to Firebase
    final json = pokemon.toJson();
    await docPokemon.set(json);
  }
}



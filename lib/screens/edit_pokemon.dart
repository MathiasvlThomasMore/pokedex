import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import '../model/pokemon.dart';
import '../widgets/multiselect.dart';

class EditPokemon extends StatefulWidget {
  const EditPokemon({Key? key, required this.pokemon}) : super(key: key);
  final Pokemon pokemon;

  @override
  State<EditPokemon> createState() => _EditPokemonState();
}

class _EditPokemonState extends State<EditPokemon> {
  PlatformFile? pickedFile;
  List<dynamic> _selectedItems = [];
  List<dynamic> _selectedPokeballs = [];
  final controllerName = TextEditingController();
  final controllerSize = TextEditingController();
  final controllerBio = TextEditingController();

  void _showMultiSelectItems() async {
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

  final formKey = GlobalKey<FormState>();

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;
    setState(() {
      pickedFile = result.files.first;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey,
        appBar: AppBar(
          title:
              const Text(
            'Edit Pokémon',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: Colors.purple,
        ),
        body: Form(
          key: formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: <Widget>[
              Align(
                alignment: Alignment.center,
                child: Container(
                  padding: EdgeInsets.all(30),
                  child: Text(
                      widget.pokemon.name,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold)),
                ),
              ),

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
                height: 15,
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
                height: 15,
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
                height: 15,
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
              ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.purple),
                  onPressed: () {
                    final isValidForm = formKey.currentState!.validate();
                    if (isValidForm) {
                      final docPokemon = FirebaseFirestore.instance
                          .collection('Pokemon')
                          .doc(widget.pokemon.id);
                      if (_selectedItems.first == _selectedItems.last) {
                        docPokemon.update({
                          'name': controllerName.text,
                          'size': controllerSize.text,
                          'element1': _selectedItems.first,
                          'element2': "",
                          'pokeballType': _selectedPokeballs.first,
                          'bio': controllerBio.text
                        });
                        Navigator.pop(context);
                      } else{
                        docPokemon.update({
                          'name': controllerName.text,
                          'size': controllerSize.text,
                          'element1': _selectedItems.first,
                          'element2': _selectedItems.last,
                          'pokeballType': _selectedPokeballs.first,
                          'bio': controllerBio.text
                        });
                        Navigator.pop(context);
                      }


                    } else {
                      QuickAlert.show(
                          context: context,
                          type: QuickAlertType.warning,
                          title:
                              "You haven't filled in the data for the pokemon correctly");
                    }
                  },
                  child: const Text('Save')),
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

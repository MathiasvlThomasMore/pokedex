import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:pokedex/screens/pok%C3%A9dexHome.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import '../widgets/multiselect.dart';

class AddPokemonPage extends StatefulWidget {
  const AddPokemonPage({Key? key}) : super(key: key);

  @override
  State<AddPokemonPage> createState() => _AddPokemonPageState();
}

class _AddPokemonPageState extends State<AddPokemonPage> {
  PlatformFile? pickedFile;
  List<dynamic> _selectedItems = [];

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

  void _showMultiSelect() async {
    // a list of selectable items
    // these items can be hard-coded or dynamically fetched from a database/API
    final List<String> items = ['Earth', 'Fire', 'Grass', 'Water', 'Air'];

    final List<String>? results = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return MultiSelect(items: items);
      },
    );

    // Update UI
    if (results != null) {
      setState(() {
        _selectedItems = results;
        print(_selectedItems[0]);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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

              ElevatedButton(
                onPressed: _showMultiSelect,
                child: const Text('Select your elements'),
              ),
              const Divider(
                height: 10,
              ),
              // display selected items
              Wrap(
                children: _selectedItems
                    .map((e) => Chip(
                          label: Text(e),
                        ))
                    .toList(),
              ),
              ElevatedButton(
                  onPressed: () {
                    final isValidForm = formKey.currentState!.validate();
                    if (isValidForm) {
                      final pokemon = Pokemon(
                          name: controllerName.text,
                          size: controllerSize.text,
                          element1: _selectedItems.first);
                      createPokemon(pokemon);
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
                  },
                  child: const Text('Add to Pokédex')),
            ],
          ),
        ));
  }

  InputDecoration decoration(String label) => InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      );

  Future createPokemon(Pokemon pokemon) async {
    final docPokemon = FirebaseFirestore.instance.collection("Pokemon").doc();
    pokemon.id = docPokemon.id;

    //Create document and write data to Firebase
    final json = pokemon.toJson();
    await docPokemon.set(json);
  }
}

class Pokemon {
  String id;
  final String name;
  final String size;
  final String element1;

  Pokemon(
      {this.id = '',
      required this.name,
      required this.size,
      required this.element1});

  Map<String, dynamic> toJson() =>
      {'id': id, 'name': name, 'size': size, 'elements': element1};

  static Pokemon fromJson(Map<String, dynamic> json) => Pokemon(
      id: json['id'],
      name: json['name'],
      size: json['size'],
      element1: json['elements']);
}

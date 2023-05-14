
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class AddPokemonPage extends StatefulWidget {
  const AddPokemonPage({Key? key}) : super(key: key);

  @override
  State<AddPokemonPage> createState() => _AddPokemonPageState();
}

class _AddPokemonPageState extends State<AddPokemonPage> {
  PlatformFile? pickedFile;
  Future selectFile() async{
    final result = await FilePicker.platform.pickFiles();
    if(result==null) return;
    setState(() {
      pickedFile = result.files.first;
    });
  }
  final controllerName = TextEditingController();
  final controllerType = TextEditingController();
  final controllerSize = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Center(child: Text('Adding Pokémon')),
          backgroundColor: Colors.red),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: <Widget>[
          TextField(
            controller: controllerName,
            decoration: decoration('Name'),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: controllerSize,
            decoration: decoration('Size'),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
              onPressed: () {
                final pokemon = Pokemon(
                    name: controllerName.text,
                    size: controllerSize.text);
                createPokemon(pokemon);
                Navigator.pop(context);
              },
              child: Text('Add to PokéDex'))
        ],
      ),
    );
  }

  InputDecoration decoration(String label) => InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      );

  Future createPokemon(Pokemon pokemon) async {
    final docPokemon =
        FirebaseFirestore.instance.collection("Pokemon").doc();
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
  Pokemon(
      {this.id = '',
      required this.name,
      required this.size});

  Map<String, dynamic> toJson() =>
      {'id': id, 'name': name, 'size': size};
  static Pokemon fromJson(Map<String,dynamic> json) => Pokemon(
    id:json['id'],
      name: json['name'],
      size: json['size'],
  );
}

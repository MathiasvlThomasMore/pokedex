// ignore: file_names
// ignore_for_file: unused_import, file_names, duplicate_ignore

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pokedex/data_model.dart';
import 'package:pokedex/screens/add_pokemon.dart';
import 'package:http/http.dart' as http;

class PokemonDetailPage extends StatefulWidget {
  final Pokemon pokemon;

  const PokemonDetailPage({super.key, required this.pokemon});

  @override
  State<PokemonDetailPage> createState() => _PokemonDetailPageState();
}

class _PokemonDetailPageState extends State<PokemonDetailPage> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getData();
  }

  Pokedex? dataFromAPI;

  _getData() async {
    try {
      String url =
          "https://raw.githubusercontent.com/Biuni/PokemonGO-Pokedex/master/pokedex.json";
      http.Response res = await http.get(Uri.parse(url));
      if (res.statusCode == 200) {
        dataFromAPI = Pokedex.fromJson(json.decode(res.body));
        _isLoading = false;
        setState(() {});
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void fillList() {
    for (var i = 0; i < dataFromAPI!.pokemon.length; i++) {
      if (dataFromAPI!.pokemon[i].name==widget.pokemon.name){
        print(dataFromAPI!.pokemon[i].name);
       // rightList.add(dataFromAPI!.pokemon[i]);

      }

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.pokemon.name),
          backgroundColor: Colors.red,
          centerTitle: true,
        ),
        body: Center(
            child: IconButton(icon: Icon(Icons.add), onPressed: () {
              fillList();
            },)
        )
    );
  }
}

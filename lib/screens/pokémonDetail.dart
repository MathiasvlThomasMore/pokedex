import 'package:flutter/material.dart';


import '../model/pokemon.dart';

class PokemonDetailPage extends StatefulWidget {
  final Pokemon pokemon;

  const PokemonDetailPage({super.key, required this.pokemon});

  @override
  State<PokemonDetailPage> createState() => _PokemonDetailPageState();
}

class _PokemonDetailPageState extends State<PokemonDetailPage> {
  var color;

  Image customImage(img) {
    switch (img) {
      case "Poké Ball":
        return Image.asset("assets/images/normal_pokeball.png");
      case "Great Ball":
        return Image.asset("assets/images/great_ball.png");
      case "Master Ball":
        return Image.asset("assets/images/master_ball.png");
      case "Ultra Ball":
        return Image.asset("assets/images/ultra_ball.png");
      default:
        return Image.asset("assets/images/normal_pokeball.png");
    }
  }

  Color customColor(element) {
    switch (element) {
      case "Water":
        return Colors.blue;
      case "Earth":
        return Colors.brown;
      case "Fire":
        return Colors.red;
      case "Grass":
        return Colors.green;
      case "Air":
        return Colors.grey;
      default:
        return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          centerTitle: true,
          elevation: 0,
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
        ),
        body: Container(
          color: Colors.black12,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(bottom: 38),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(90),
                      bottomRight: Radius.circular(90)),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black45.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 15,
                        offset: Offset(0, 15)),
                  ],
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: customImage(widget.pokemon.pokeballType),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 20, bottom: 70),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    widget.pokemon.name,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 40,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  margin: EdgeInsets.only(left: 10),
                  decoration: const BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: Colors.red, width: 3.0))),
                  child: const Text(
                    "About",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: Text(widget.pokemon.bio),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  margin: EdgeInsets.only(left: 10),
                  decoration: const BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: Colors.red, width: 3.0))),
                  child: const Text(
                    "Pokémon Data",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Container(
                  margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
                  child: Row(
                    children: [
                      Text("Elements:"),
                      Spacer(),
                      Text(
                        "${widget.pokemon.element1} ",
                        style: TextStyle(
                            color: customColor(widget.pokemon.element1)),
                      ),
                      Text(widget.pokemon.element2,
                          style: TextStyle(
                              color: customColor(widget.pokemon.element2))),
                    ],
                  )),
              Container(
                  margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
                  child: Row(
                    children: [
                      Text("Size:"),
                      Spacer(),
                      Text("${widget.pokemon.size}")
                    ],
                  )),
              Container(
                  margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
                  child: Row(
                    children: [
                      Text("Pokéball type:"),
                      Spacer(),
                      Text("${widget.pokemon.pokeballType}")
                    ],
                  ))
            ],
          ),
        ));
  }
}

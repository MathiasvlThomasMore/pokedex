// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:pokedex/config.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Center(child: Text('About')),
            backgroundColor: Colors.red),
        backgroundColor: Colors.grey,
        body: Column(
          children: [
            Image.asset('assets/images/pokedexPic.png'),
            const Center(
              child: Text("Pokédex",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                  )),
            ),
            const Center(
                child: Text("Version ${MyConfig.versionNumber}",
                    style: TextStyle(color: Colors.white))),
            const Center(
              child: Text("Made by Mathias Van Langendonck",
                  style: TextStyle(color: Colors.white)),
            )
          ],
        ));
  }
}

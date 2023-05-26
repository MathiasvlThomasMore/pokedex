
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pokedex/firebase_options.dart';
import 'package:pokedex/screens/add_pokemon.dart';
import 'package:pokedex/screens/infoScreen.dart';
import 'package:pokedex/screens/pok%C3%A9dexHome.dart';


final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const PokeDexApp());
}

class PokeDexApp extends StatelessWidget {
  const PokeDexApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: _PokedexApp(),
      theme: ThemeData(
        fontFamily: 'Poppins'
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class _PokedexApp extends StatefulWidget {
  const _PokedexApp({Key? key}) : super(key: key);

  @override
  State<_PokedexApp> createState() => _PokedexAppState();
}

class _PokedexAppState extends State<_PokedexApp> {

  int currentIndex = 0;
  final screens = [
    const PokedexHome(),
    const AddPokemonPage(),
    InfoScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: CurvedNavigationBar(
        items: const [
          Icon(
            Icons.home,
          ),
          Icon(
            MdiIcons.pokemonGo,
          ),
          Icon(
            Icons.info,
          ),

        ],
        backgroundColor: Colors.grey,
        animationDuration: const Duration(milliseconds: 300),
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }
}






import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pokedex/firebase_options.dart';
import 'package:pokedex/screens/pok%C3%A9dex.dart';


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
    return const MaterialApp(
      home: _PokedexApp(),
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


  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body:Pokedex());
  }
}





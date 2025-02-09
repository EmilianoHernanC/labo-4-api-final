import 'package:flutter/material.dart';
import 'package:flutter_pokemon/helpers/pokemon_preferences.dart';
import 'package:flutter_pokemon/screens/habilidades_screen.dart';
import 'package:flutter_pokemon/screens/home_screen.dart';
import 'package:flutter_pokemon/screens/pokemon_list.dart';
import 'package:provider/provider.dart';
import 'package:flutter_pokemon/providers/theme_provider.dart';
import 'package:flutter_pokemon/screens/profile_screen.dart';
import 'package:flutter_pokemon/screens/movimientos_combate_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PokemonPreferences.initShared();

  final themeProvider = ThemeProvider();
  await themeProvider.loadTheme(); 

  runApp(MyApp(themeProvider: themeProvider));
}

class MyApp extends StatelessWidget {
  final ThemeProvider themeProvider;

  const MyApp({super.key, required this.themeProvider});


  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ThemeProvider>(
      create: (_) => themeProvider,
      child: Consumer<ThemeProvider>(
        builder: (context, tema, child){
          return MaterialApp(
          debugShowCheckedModeBanner: false,
          initialRoute: 'home',
          theme: tema.temaActual, 
          routes: {
          'home': (context) => const HomeScreen(),
          'profile_screen': (context) => const ProfileScreen(),
          'pokemon_list': (context) => const PokemonList(),
          'habilidades_screen': (context) => const PokemonListScreen(),
          'movimientos_combate_screen': (context) => const MCombateScreen(),
          },
            );
          },
        ),
      );
    }
  }
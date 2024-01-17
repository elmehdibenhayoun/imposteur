import 'package:flutter/material.dart';
import 'package:get/get.dart';
// Importer le contrôleur GameController
import 'package:tic_tac_toe/resource/socket_method.dart';
// Mettez à jour le nom du fichier si nécessaire
import 'package:tic_tac_toe/screens/create_room_sreen.dart';
import 'package:tic_tac_toe/screens/debut_game.dart';
// Mettez à jour le nom du fichier si nécessaire
import 'package:tic_tac_toe/screens/geme_screen.dart';
import 'package:tic_tac_toe/screens/join_room_screen.dart'; // Mettez à jour le nom du fichier si nécessaire
import 'package:tic_tac_toe/screens/main_menu_screen.dart'; // Mettez à jour le nom du fichier si nécessaire
import 'package:tic_tac_toe/screens/splash_screen.dart'; // Mettez à jour le nom du fichier si nécessaire
import 'package:tic_tac_toe/util/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Imposter',
      theme: MyAppThemeConfig.dark().getTheme(),
      initialBinding: BindingsBuilder(() {
        // Initialiser le GameController lors de la création de l'application
        Get.put(GameController());
      }),
      home: const SplashScreen(),
      getPages: [
        GetPage(
          name: SplashScreen.routeName,
          page: () => const SplashScreen(),
        ),
        GetPage(
          name: MainMenuScreen.routeName,
          page: () => const MainMenuScreen(),
        ),
        GetPage(
          name: JoinRoomScreen.routeName,
          page: () => const JoinRoomScreen(),
        ),
        GetPage(
          name: CreateRoomScreen.routeName,
          page: () => const CreateRoomScreen(),
        ),
        GetPage(
          name: GameScreen.routeName,
          page: () => GameScreen(),
        ),
        GetPage(
          name: DebutScreen.routeName,
          page: () => DebutScreen(),
        ),
      ],
    );
  }
}

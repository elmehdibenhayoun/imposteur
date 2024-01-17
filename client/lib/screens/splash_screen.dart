import 'package:flutter/material.dart';
import 'package:tic_tac_toe/responsive/responsive.dart';
import 'package:tic_tac_toe/screens/create_room_sreen.dart';
import 'package:tic_tac_toe/screens/join_room_screen.dart';
import 'package:tic_tac_toe/util/dimension.dart';
import 'package:tic_tac_toe/widgets/custom_button.dart';

import '../widgets/button.dart';
import 'main_menu_screen.dart';

class SplashScreen extends StatelessWidget {
  static const String routeName = '/splash';

  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Responsive(
          child: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/bg.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                top: 20,
                left: 20,
                child: Image.asset(
                  'assets/images/title.png',
                  width: 140,
                  height: 100,
                ),
              ),
              Positioned(
                left: 75,
                top: 520,
                child: Button(
                  label: "Join room",
                  onPressed: () => joinRoom(context),
                ),
              ),
              Positioned(
                left: 75,
                top: 420,
                child: Button(
                  label: "Create room",
                  onPressed: () => createRoom(context),
                ),
              ),
              // Positioned(
              //   left: 50,
              //   top: 400,
              //   child: Container(
              //     width: 350,
              //     height: 190,
              //     decoration: BoxDecoration(
              //       color: Color.fromARGB(26, 247, 140, 126), // Opacité à 80%
              //       borderRadius: BorderRadius.circular(15),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  void createRoom(BuildContext context) {
    Navigator.of(context).pushNamed(CreateRoomScreen.routeName);
  }

  void joinRoom(BuildContext context) {
    Navigator.of(context).pushNamed(JoinRoomScreen.routeName);
  }
}

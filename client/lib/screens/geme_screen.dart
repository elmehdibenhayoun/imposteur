import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tic_tac_toe/models/player.dart';
import 'package:tic_tac_toe/resource/socket_method.dart';
import 'package:tic_tac_toe/screens/debut_game.dart';

import '../widgets/button.dart';

class GameScreen extends StatefulWidget {
  static const String routeName = '/game';
  const GameScreen({Key? key}) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final GameController _gameController = Get.find<GameController>();

  bool hasNavigatedToDebut = false;

  @override
  void initState() {
    _gameController.updatePlayerListener((players) {
      _gameController.updateRoomData(players);
      _gameController.updatePlayersList(players['players']);

      if (_areAllPlayersReady() && !hasNavigatedToDebut) {
        // Appeler startGame côté serveur après que tous les joueurs sont prêts
        _gameController.startGame(_gameController.currentRoomId.value!);
        //_gameController.updatePlayersList(players);

        // Naviguer vers le DebutScreen une fois que startGame a été appelé
        Navigator.of(context).pushNamed(DebutScreen.routeName);
        hasNavigatedToDebut = true;
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _gameController.dispose();
    super.dispose();
  }

  bool _areAllPlayersReady() {
    return _gameController.players.every((player) => player.isReady!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Obx(() {
      //     Player? currentPlayer = _gameController.currentPlayer.value;
      //     return _buildPlayerButton(currentPlayer!.toJson());
      //   }),
      // ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemCount: _gameController.players.length,
                itemBuilder: (context, index) {
                  Player player = _gameController.players[index];

                  return Padding(
                    padding: const EdgeInsets.only(
                        top: 30,
                        right: 30,
                        left: 30), // Ajustez le padding selon vos besoins
                    // child: Card(
                    //   shape: RoundedRectangleBorder(
                    //     borderRadius: BorderRadius.circular(15.0),
                    //   ),
                    //elevation: 5.0,
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(5.0),
                          width: 80.0, // Ajustez la largeur selon vos besoins
                          height: 120.0, // Ajustez la hauteur selon vos besoins
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30.0),
                            image: const DecorationImage(
                              image: AssetImage(
                                  'assets/images/p1.png'), // Remplacez par le chemin réel de votre image
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        ListTile(
                          title: Center(
                            child: Text(
                              ' ${player.nickName}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          //trailing: _buildPlayerButton(player.toJson()),
                        ),
                      ],
                    ),
                  );
                },
              );
            }),
          ),
          Center(
            child: Obx(() {
              Player? currentPlayer = _gameController.currentPlayer.value;
              return _buildPlayerButton(currentPlayer!.toJson());
            }),
          ),
          const SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerButton(Map<String, dynamic> player) {
    final currentPlayerName = _gameController.currentPlayer.value?.nickName;

    if (currentPlayerName != null && player['nickName'] == currentPlayerName) {
      return SizedBox(
        width: 200, // Ajustez la largeur selon vos besoins
        height: 40, // Ajustez la hauteur selon vos besoins
        child: Button(
          label: player['isReady'] ? 'Prêt' : 'Vous etes prêt ?',
          onPressed: () async {
            player['isReady'] = !player['isReady'];
            _gameController.updatePlayer(
              _gameController.currentRoomId.value!,
              player,
            );
          },
        ),
      );
    }

    return const SizedBox.shrink();
  }
}

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:tic_tac_toe/models/player.dart';
// import 'package:tic_tac_toe/resource/socket_method.dart';
// import 'package:tic_tac_toe/screens/debut_game.dart';

// class GameScreen extends StatefulWidget {
//   static const String routeName = '/game';
//   const GameScreen({Key? key}) : super(key: key);

//   @override
//   State<GameScreen> createState() => _GameScreenState();
// }

// class _GameScreenState extends State<GameScreen> {
//   final GameController _gameController = Get.find<GameController>();
//   @override
//   void initState() {
//     _gameController.updatePlayerListener((players) {
//       _gameController.updatePlayersList(players);
//     });
//     _gameController.checkReadyPlayerListener(
//       (data) {
//         _gameController.updateRoomData(data);
        


//         Navigator.of(context).pushNamed(DebutScreen.routeName);
//       },
//     );

//     super.initState();
//   }

//   @override
//   void dispose() {
//     _gameController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Obx(() {
//           Player? currentPlayer = _gameController.currentPlayer.value;
//           return Text('Game Screen - ${currentPlayer?.nickName ?? "N/A"}');
//         }),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: Obx(() {
//               return ListView.builder(
//                 itemCount: _gameController.players.length,
//                 itemBuilder: (context, index) {
//                   Player player = _gameController.players[index];

//                   return ListTile(
//                     title: Text('Nom: ${player.nickName}'),
//                     trailing: _buildPlayerCheckbox(player.toJson()),
//                   );
//                 },
//               );
//             }),
//           ),
//         ],
//       ),
//     );
//   }

//   _buildPlayerCheckbox(Map<String, dynamic> player) {
//     final currentPlayerName = _gameController.currentPlayer.value?.nickName;

//     if (currentPlayerName != null && player['nickName'] == currentPlayerName) {
//       return Checkbox(
//         value: player['isReady'],
//         onChanged: (isReady) async {
//           print(_gameController.currentRoomId.value!);

//           // Assurez-vous que le paquet player contient 'isReady' avec la nouvelle valeur
//           player['isReady'] = isReady;

//           // Mettez à jour le joueur côté serveur
//           _gameController.updatePlayer(
//               _gameController.currentRoomId.value!, player);
          
//           // Maintenant que la mise à jour côté serveur est terminée, vérifiez l'état prêt
          
//         },
//       );
//     }
//      _gameController
//               .checkReadyPlayer(_gameController.currentRoomId.value!);
//   }
// }


//----------------
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tic_tac_toe/models/player.dart';
import 'package:tic_tac_toe/resource/socket_method.dart';
import 'package:tic_tac_toe/screens/debut_game.dart';

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
      appBar: AppBar(
        title: Obx(() {
          Player? currentPlayer = _gameController.currentPlayer.value;
          return Text('Game Screen - ${currentPlayer?.nickName ?? "N/A"}');
        }),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              return ListView.builder(
                itemCount: _gameController.players.length,
                itemBuilder: (context, index) {
                  Player player = _gameController.players[index];

                  return ListTile(
                    title: Text('Nom: ${player.nickName}'),
                    trailing: _buildPlayerCheckbox(player.toJson()),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  _buildPlayerCheckbox(Map<String, dynamic> player) {
    final currentPlayerName = _gameController.currentPlayer.value?.nickName;

    if (currentPlayerName != null && player['nickName'] == currentPlayerName) {
      return Checkbox(
        value: player['isReady'],
        onChanged: (isReady) async {
          player['isReady'] = isReady;
          _gameController.updatePlayer(
              _gameController.currentRoomId.value!, player);
        },
      );
    }
    return const SizedBox.shrink();
  }
}

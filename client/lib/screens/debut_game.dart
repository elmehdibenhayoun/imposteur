// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:tic_tac_toe/models/player.dart';
// import 'package:tic_tac_toe/resource/socket_method.dart';

// class DebutScreen extends StatefulWidget {
//   static const String routeName = '/debut';

//   @override
//   State<DebutScreen> createState() => _DebutScreenState();
// }

// class _DebutScreenState extends State<DebutScreen> {
//   final GameController _gameController = Get.find<GameController>();
//   @override
//   void initState() {
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
//           return Text('Début Screen - ${currentPlayer?.nickName ?? "N/A"}');
//         }),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: Obx(() {
//               return ListView.builder(
//                 itemCount: _gameController.players.length,
//                 itemBuilder: (context, index) {
//                   _gameController
//                       .startGame(_gameController.currentRoomId.value!);
//                   Player player = _gameController.players[index];

//                   return ListTile(
//                     title: Text('Nom: ${player.nickName}'),
//                     subtitle: Text('Nom: ${player.word}'),
//                   );
//                 },
//               );
//             }),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tic_tac_toe/models/player.dart';
import 'package:tic_tac_toe/resource/socket_method.dart';
import 'package:tic_tac_toe/widgets/custom_button.dart';
import 'package:tic_tac_toe/widgets/custom_text_field.dart';

class DebutScreen extends StatefulWidget {
  static const String routeName = '/debut';

  @override
  State<DebutScreen> createState() => _DebutScreenState();
}

class _DebutScreenState extends State<DebutScreen> {
  final GameController _gameController = Get.find<GameController>();
  final TextEditingController _nameController = TextEditingController();
  late Timer _timer;
  int _secondsRemaining = 10;

  @override
  void initState() {
    
    _gameController.updatePlayerListener((data) {
      _gameController.updateRoomData(data);
      _gameController.updatePlayersList(data['players']);
      
    });
    _timer = Timer.periodic(const Duration(seconds: 1), _updateTimer);
    // Écoutez l'événement 'gameStarted' pour déclencher des actions une fois le jeu démarré
    _gameController.onGameStartedListener((data) {
      _gameController.updateRoomData(data);
      _gameController.updatePlayersList(data['players']);
      // Vous pouvez effectuer des actions nécessaires ici
      // par exemple, mettre à jour l'interface utilisateur ou effectuer une navigation
    });
    super.initState();
  }
  bool _areAllPlayersVote() {
    return _gameController.players.every((player) => player.votes != null && player.votes!.length > 1);
}


  void _updateTimer(Timer timer) {
    setState(() {
      if (_secondsRemaining > 0) {
        _secondsRemaining--;
      } else {
        // Le minuteur a expiré, effectuez des actions nécessaires ici
        // par exemple, afficher un champ de texte
        timer.cancel(); 
        if (_areAllPlayersVote()) {
        _showAllPlayersVotedPopup();
      } else {
        // Le temps est écoulé, mais certains joueurs n'ont pas encore voté
        // Vous pouvez effectuer des actions supplémentaires si nécessaire
      }// Arrêter le minuteur après l'expiration
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _gameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() {
          Player? currentPlayer = _gameController.currentPlayer.value;
          return Text('Début Screen - ${currentPlayer?.nickName ?? "N/A"}');
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
                      subtitle: _buildSubtitle(player),
                      onTap: () {
                        // Gérer le clic sur le joueur
                        if (_secondsRemaining == 0) {
                          _votePlayer(player.toJson());
                        }
                      });
                },
              );
            }),
          ),
          // Afficher le minuteur
          _secondsRemaining == 0
              ? const Text('Votre Vote')
              : Text('Temps restant : $_secondsRemaining secondes'),
          // Afficher un champ de texte si le minuteur a expiré
          if (_secondsRemaining == 0)
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                children: [
                  CustomTextField(
                    hint: 'Enter your vote',
                    controller: _nameController,
                  ),
                  CustomButton(
                      text: const Text('Join'),
                      onTap: () {
                        Player? currentPlayer =
                            _gameController.currentPlayer.value;
                        currentPlayer?.votes = _nameController.toString();
                        _gameController.updatePlayer(
                            _gameController.currentRoomId.value!,
                            currentPlayer!.toJson());
                      })
                ],
              ),
            ),
        ],
      ),
    );
  }

  void _votePlayer(Map<String, dynamic> player) {
    // Assurez-vous que le joueur cliqué n'est pas le joueur actuel
    if (_gameController.currentPlayer.value?.nickName != player['nickName']) {
      _gameController.currentPlayer.value?.votes = player['nickName'];
      print(_gameController.currentPlayer.value!.toJson());
      // Mettre à jour le vote du joueur
      _gameController.updatePlayer(
        _gameController.currentRoomId.value!,
        _gameController.currentPlayer.value!.toJson(),
      );
    }
  }

  Widget _buildSubtitle(Player player) {
    Player? currentPlayer = _gameController.currentPlayer.value;
    if (currentPlayer != null && player.nickName == currentPlayer.nickName) {
      // Si le joueur est le joueur actuel, affichez son mot
      return Text('Mot: ${player.word}');
    } else {
      // Sinon, ne montrez rien pour les autres joueurs
      return Container();
    }
  }
  void _showAllPlayersVotedPopup() {
  Get.dialog(
    AlertDialog(
      title: Text('Tous les joueurs ont voté !'),
      content: Text('Le vote est maintenant clos.'),
      actions: [
        ElevatedButton(
          onPressed: () {
            Get.back(); // Fermer la boîte de dialogue
          },
          child: Text('OK'),
        ),
      ],
    ),
  );
}

}

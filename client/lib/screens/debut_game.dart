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
    // _gameController.updatePlayerListener((data) {
    //   _gameController.updateRoomData(data);
    //   _gameController.updatePlayersList(data['players']);
    // });
    _gameController.updatePlayerListener((data) {
      _gameController.updateRoomData(data);

      if (data is Map<String, dynamic> && data.containsKey('players')) {
        // Extrait la liste des joueurs de data['players']
        List<dynamic> playersData = data['players'];

        // Met à jour la liste des joueurs
        _gameController.updatePlayersList(playersData);
      } else {
        print('Données des joueurs au format incorrect : $data');
      }
    });
    _gameController.resultatSuccessListener((data) {
      print(data);
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
    RxList<Player> players = _gameController.players;
    // Modifiez la condition pour vérifier si tous les joueurs ont un vote non vide
    return players
        .every((player) => player.votes != null && player.votes!.isNotEmpty);
  }

  void _updateTimer(Timer timer) {
    setState(() {
      if (_secondsRemaining > 0) {
        _secondsRemaining--;
      } else {
        timer.cancel();

        // Déplacez la vérification _areAllPlayersVote ici pour éviter d'interférer avec le minuteur
        if (_areAllPlayersVote()) {
          print('All players have voted. Showing popup.');
          _showAllPlayersVotedPopup();
        } else {
          print('Not all players have voted.');
        }
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
                            subtitle: _buildSubtitle(player),
                            onTap: () {
                              // Gérer le clic sur le joueur
                              if (_secondsRemaining == 0) {
                                _votePlayer(player.toJson());
                              }
                              //trailing: _buildPlayerButton(player.toJson()),
                            }),
                      ],
                    ),
                  );
                },
              );
            }),
          ),
          _secondsRemaining == 0
              ? const Text('Votre Vote')
              : Text('Temps restant : $_secondsRemaining secondes'),
          // Afficher un champ de texte si le minuteur a expiré
          if (_secondsRemaining == 0) const Text('Le vote commence'),
          const SizedBox(
            height: 30,
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

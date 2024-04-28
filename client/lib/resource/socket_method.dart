import 'package:get/get.dart';
import 'package:tic_tac_toe/models/player.dart';
import 'package:tic_tac_toe/models/room.dart';
import 'package:tic_tac_toe/resource/socket_client.dart';
import 'package:tic_tac_toe/screens/debut_game.dart';

class GameController extends GetxController {
  static GameController get instance => Get.find<GameController>();
  final _socketClient = SocketClient.instance.socket!;
  Rx<String?> currentRoomId = Rx<String?>(null);
  RxList<Player> players = <Player>[].obs;
  
  RxList<Room> rooms = <Room>[].obs;
  Rx<Player?> currentPlayer = Rx<Player?>(null);
  List<bool> playersCheckedState = [];
  int count = 1;

  // Ajoutez ici les autres propriétés et méthodes nécessaires.

  @override
  void onInit() {
    super.onInit();

    _socketClient.on('updatePlayers', (data) {
      updatePlayersList(data);
    });

    _socketClient.on('updateRoom', (data) {
      updateRoomsList(data);
    });
  }

  void updateCurrentRoomId(String roomId) {
    currentRoomId.value = roomId;
  }

  void updateRoomData(dynamic roomData) {
    final Room updatedRoom = Room.fromJson(roomData);

    // Vérifier si la salle existe déjà dans la liste
    final existingRoomIndex =
        rooms.indexWhere((room) => room.id == updatedRoom.id);

    if (existingRoomIndex != -1) {
      // La salle existe déjà, mettez à jour les données
      rooms[existingRoomIndex] = updatedRoom;
    } else {
      // La salle n'existe pas encore, ajoutez-la à la liste
      rooms.add(updatedRoom);
    }

    // Imprimez les données mises à jour pour vérification
    print("Room data updated: $roomData");
  }

  // void updatePlayerListener(Function(List<Player>) callback) {
  //   _socketClient.on('updatePlayers', (data) {
  //     List<Player> players = (data as List).map((playerData) {
  //       return Player.fromJson(playerData);
  //     }).toList();
      
  //     callback(players);
  //   });
  // }

  // void updatePlayersList(dynamic playersData) {
  //   if (playersData is List) {
  //     List<Player> updatedPlayers = [];

  //     for (var playerData in playersData) {
  //       if (playerData is Map<String, dynamic>) {
  //         updatedPlayers.add(Player.fromJson(playerData));
  //       } else if (playerData is Player) {
  //         updatedPlayers.add(playerData);
  //       } else {
  //         print('Données du joueur au format incorrect : $playerData');
  //       }
  //     }

  //     players.assignAll(updatedPlayers);
  //   } else {
  //     print('Données des joueurs au format incorrect : $playersData');
  //   }
  // }
void updatePlayersList(dynamic playersData) {
  print('Received players data: $playersData');

  if (playersData is List) {
    List<Player> updatedPlayers = [];

    for (var playerData in playersData) {
      print('Processing player data: $playerData');
      if (playerData is Map<String, dynamic>) {
        updatedPlayers.add(Player.fromJson(playerData));
      } else if (playerData is Player) {
        updatedPlayers.add(playerData);
      } else {
        print('Invalid player data format: $playerData');
      }
    }

    // Mettez à jour la liste players du GameController
    GameController.instance.players.assignAll(updatedPlayers);
  } else {
    print('Invalid players data format: $playersData');
  }
}



  void updateCurrentPlayer(Player player) {
    currentPlayer.value = player;
  }

  void updateRoomsList(dynamic roomsData) {
    if (roomsData is List) {
      List<Room> updatedRooms = roomsData.map((roomData) {
        if (roomData is Map<String, dynamic>) {
          return Room.fromJson(roomData);
        } else {
          // Si les données ne sont pas au format attendu, renvoyer une nouvelle instance de Room avec des valeurs par défaut.
          return Room(id: '', occupancy: 0, isJoin: false);
        }
      }).toList();

      rooms.assignAll(updatedRooms);
    }
  }

  void startGame(String roomId) {
    _socketClient.emit('startgame', {'roomId': roomId});
  }

  void createRoom(String nickname,String password) {
    if (nickname.isNotEmpty) {
      _socketClient.emit('createRoom', {'nickname': nickname,'password': password});
    }
  }

  void updatePlayer(String roomId, Map<String, dynamic> player) {
    _socketClient.emit('updatePlayer', {'roomId': roomId, 'player': player});
  }
  void resultat(String roomId) {
    _socketClient.emit('resultat', {'roomId': roomId});
  }

  void checkReadyPlayer(String roomId) {
    _socketClient.emit('checkReadyPlayer', {'roomId': roomId});
  }

  void checkReadyPlayerListener(Function(dynamic) callback) {
    _socketClient.on('checkReadyPlayerSuccess', (data) {
      callback(data);
    });
  }

  void joinRoom(String nickName, String password) {
    if (nickName.isNotEmpty && password.isNotEmpty) {
      _socketClient.emit('joinRoom', {'nickname': nickName, 'roomId': password});
    }
  }

  void createRoomSuccessListener(Function(dynamic) callback) {
    _socketClient.on('createRoomSuccess', (room) {
      callback(room);
      Player player = Player.fromJson(room['players'][0]);
      updateCurrentPlayer(player);
      updateCurrentRoomId(room['_id']);
    });
  }
  void resultatSuccessListener(Function(dynamic) callback) {
    _socketClient.on('resultat', (data) {
      callback(data);
      
    });
  }

  // void joinRoomSuccessListener(Function(dynamic) callback) {
  //   _socketClient.on('joinRoomSuccess', (room) {
  //     callback(room);

  //     Player player = Player.fromJson(room['players'].last);
  //     updateCurrentPlayer(player);
  //     updateCurrentRoomId(room['_id']);

  //   });
  //   count++;
  // }
  void joinRoomSuccessListener(Function(dynamic) callback) {
    _socketClient.on('joinRoomSuccess', (room) {
      callback(room);
      Player player = Player.fromJson(room['players'].firstWhere(
        (playerData) => playerData['socketID'] == _socketClient.id,
      ));
      updateCurrentPlayer(player);
      updateCurrentRoomId(room['_id']);
    });
  }
  void updateRoomSuccesListener(Function(dynamic) callback) {
    _socketClient.on('updateRoomSucces', (room) {
      callback(room);
    });
  }

  void onGameStartedListener(Function(dynamic) callback) {
    _socketClient.on('gameStarted', (room) {
      callback(room);
      room['players']
          .where((playerData) =>
              playerData['nickName'] == currentPlayer.value?.nickName)
          .map((playerData) {
        Player player = Player.fromJson(playerData);
        updateCurrentPlayer(player);
      }).toList();
    });
  }
  void updatePlayerListener(Function(dynamic) callback) {
    _socketClient.on('updateRoom', (room) {
      callback(room);
      room['players']
          .where((playerData) =>
              playerData['nickName'] == currentPlayer.value?.nickName)
          .map((playerData) {
        Player player = Player.fromJson(playerData);
        updateCurrentPlayer(player);
      }).toList();
    });
  }

  void errorOccurredListener(Function(String) callback) {
    _socketClient.on('errorOccurred', (errorMessage) {
      callback(errorMessage.toString());
    });
  }

  // Ajoutez d'autres méthodes et événements au besoin.

  @override
  void onClose() {
    super.onClose();
    // Ajoutez ici les opérations de nettoyage si nécessaire.
  }
}

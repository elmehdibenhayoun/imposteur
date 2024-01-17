// import 'package:flutter/material.dart';
// import 'package:tic_tac_toe/models/player.dart';

// import '../resource/socket_method.dart';

// class RoomDataProvider extends ChangeNotifier {
//   final SocketController _socketController = SocketController();
//   Map<String, dynamic> _roomData = {};

//   Map<String, dynamic> get roomData => _roomData;

//   Player _p1 = Player(nickName: '', socketId: '');
//   Player _p2 = Player(nickName: '', socketId: '');
//   Player _p3 = Player(nickName: '', socketId: '');

//   Player get p1 => _p1;

//   Player get p2 => _p2;
//   Player get p3 => _p3;

  

//   void updateRoomData(Map<String, dynamic> newRoomData) {
//     _roomData = newRoomData;
//     notifyListeners();
//   }

//   void updatePlayer1(Map<String, dynamic> json) {
//     _p1 = Player.fromJson(json);
//     notifyListeners();
//   }

//   void updatePlayer2(Map<String, dynamic> json) {
//     _p2 = Player.fromJson(json);
//     notifyListeners();
//   }

//   void updatePlayer3(Map<String, dynamic> json) {
//     _p3 = Player.fromJson(json);
//     notifyListeners();
//   }
// }

import 'package:tic_tac_toe/models/player.dart';

class Room {
  final String id;
  final int occupancy;
  final bool isJoin;
  final List<Player> players;

  Room({
    required this.id,
    required this.occupancy,
    required this.isJoin,
    List<Player>? players,
  }) : players = players ?? [];

  Room.fromJson(Map<String, dynamic> json)
      : id = json['_id'],
        occupancy = json['occupancy'],
        isJoin = json['isJoin'],
        players = (json['players'] as List<dynamic>?)
                ?.map((playerData) => Player.fromJson(playerData))
                .toList() ??
            [];

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'occupancy': occupancy,
      'isJoin': isJoin,
      'players': players.map((player) => player.toJson()).toList(),
    };
  }
}

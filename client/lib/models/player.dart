class Player {
  final String nickName;
  final String socketId;
  final bool? isMrWhite;
  final String? word;
  late String? votes;
  late  bool? isReady;

  Player({
    required this.nickName,
    required this.socketId,
    this.isMrWhite,
    this.word,
    this.votes,
    this.isReady,
  });

  Player.fromJson(Map<String, dynamic> json)
      : nickName = json['nickName'] ?? '',
        socketId = json['socketID'] ?? '',
        isMrWhite = json['isMrWhite'] ?? false,
        word = json['word'] ?? '',
        votes = json['votes'] ?? '',
        isReady = json['isReady'] ?? false;

  Map<String, dynamic> toJson() {
    return {
      'nickName': nickName,
      'socketID': socketId,
      'isMrWhite': isMrWhite,
      'word': word,
      'votes': votes,
      'isReady': isReady,
    };
  }
}

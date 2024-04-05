class Users {
  final String? displayName;
  List<Scores>? scores;
  Users({
    this.displayName,
    this.scores,
  });

  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
      scores: json['scores'] != null ? (json['scores'] as List).map((i) => Scores.fromJson(i)).toList() : null,
      displayName: json['displayName'],
    );
  }
}

class Scores {
  String? mode;
  int? score;
  int? time;

  Scores({
    this.mode,
    this.score,
    this.time,
  });

  factory Scores.fromJson(Map<String, dynamic> json) {
    return Scores(
      mode: json['mode'],
      score: json['score'],
      time: json['time'],
    );
  }
}

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
  int? id;
  int? score;
  int? time;
  String? typedText;
  String? colorText;

  Scores({
    this.id,
    this.score,
    this.time,
    this.typedText,
    this.colorText,
  });

  factory Scores.fromJson(Map<String, dynamic> json) {
    return Scores(
      id: json['id'],
      score: json['score'],
      time: json['time'],
      typedText: json['typedText'],
      colorText: json['colorText'],
    );
  }
}

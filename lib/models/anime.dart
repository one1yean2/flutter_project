class Anime {
  final String? name;
  final int? year;
  final int? episodes;
  final String? rating;

  final String image;

  Anime({
    required this.name,
    required this.year,
    required this.episodes,
    required this.rating,
    required this.image,
  });

  factory Anime.fromJson(Map<String, dynamic> json) {
    return Anime(
      name: json['title'],
      year: json['year'],
      rating: json['rating'],
      episodes: json['episodes'],
      image: json['image'],
    );
  }
}

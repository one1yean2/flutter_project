class QuotesList {
  List<Quotes>? quotes;
  int? total;
  int? skip;
  int? limit;

  QuotesList({
    this.quotes,
    this.total,
    this.skip,
    this.limit,
  });
  factory QuotesList.fromJson(Map<String, dynamic> json) {
    return QuotesList(
      quotes: json['quotes'] != null ? (json['quotes'] as List).map((i) => Quotes.fromJson(i)).toList() : null,
      total: json['total'],
      skip: json['skip'],
    );
  }
}

class Quotes {
  int? id;
  String? quote;
  String? author;

  Quotes({
    this.id,
    this.quote,
    this.author,
  });

  factory Quotes.fromJson(Map<String, dynamic> json) {
    return Quotes(
      id: json['id'],
      quote: json['quote'],
      author: json['author'],
    );
  }
}

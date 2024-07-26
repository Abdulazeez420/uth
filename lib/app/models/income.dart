class Income {
  String id;
  String uid;
  String source;
  double amount;
  DateTime date;

  Income({
    required this.id,
    required this.uid,
    required this.source,
    required this.amount,
    required this.date,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'uid': uid,
        'source': source,
        'amount': amount,
        'date': date.toIso8601String(),
      };

  static Income fromJson(Map<String, dynamic> json) => Income(
        id: json['id'],
        uid: json['uid'],
        source: json['source'],
        amount: json['amount'],
        date: DateTime.parse(json['date']),
      );
}

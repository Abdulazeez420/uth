class Expense {
  final String id;
  final String description;
  final double amount;
  final DateTime date;
  final String uid;

  Expense({
    required this.id,
    required this.description,
    required this.amount,
    required this.date,
    required this.uid,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'amount': amount,
      'date': date.toIso8601String(),
      'uid': uid,
    };
  }

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id'] ?? '',
      description: json['description'] ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      date: DateTime.parse(json['date']),
      uid: json['uid'] ?? '',
    );
  }
}

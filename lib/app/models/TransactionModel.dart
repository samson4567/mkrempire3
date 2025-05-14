class TransactionModel {
  final bool status;
  final String description;
  final TransactionData message;

  TransactionModel({
    required this.status,
    required this.description,
    required this.message,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      status: json['status'],
      description: json['description'],
      message: TransactionData.fromJson(json['message']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'description': description,
      'message': message.toJson(),
    };
  }
}

class TransactionData {
  final List<TransactionDetails> details;

  TransactionData({required this.details});

  factory TransactionData.fromJson(Map<String, dynamic> json) {
    return TransactionData(
      details: (json['details'] as List)
          .map((transaction) => TransactionDetails.fromJson(transaction))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'details': details.map((transaction) => transaction.toJson()).toList(),
    };
  }
}

class TransactionDetails {
  final String id;
  final String type;
  final double amount;
  final String status;
  final String date;

  TransactionDetails({
    required this.id,
    required this.type,
    required this.amount,
    required this.status,
    required this.date,
  });

  factory TransactionDetails.fromJson(Map<String, dynamic> json) {
    return TransactionDetails(
      id: json['id'] ?? '',
      type: json['type'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      status: json['status'] ?? '',
      date: json['date'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'amount': amount,
      'status': status,
      'date': date,
    };
  }
}

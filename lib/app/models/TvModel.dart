class TvModel {
  final bool status;
  final String description;
  final TvPlans message;

  TvModel({
    required this.status,
    required this.description,
    required this.message,
  });

  factory TvModel.fromJson(Map<String, dynamic> json) {
    return TvModel(
      status: json['status'],
      description: json['description'],
      message: TvPlans.fromJson(json['message']),
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

class TvPlans {
  final List<TvPlanDetails> details;

  TvPlans({required this.details});

  factory TvPlans.fromJson(Map<String, dynamic> json) {
    return TvPlans(
      details: (json['details'] as List)
          .map((plan) => TvPlanDetails.fromJson(plan))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'details': details.map((plan) => plan.toJson()).toList(),
    };
  }
}

class TvPlanDetails {
  final String id;
  final String name;
  final String alias;
  final int amount;
  final List<dynamic> priceOptions;

  TvPlanDetails({
    required this.id,
    required this.name,
    required this.alias,
    required this.amount,
    required this.priceOptions,
  });

  factory TvPlanDetails.fromJson(Map<String, dynamic> json) {
    return TvPlanDetails(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      alias: json['alias'] ?? '',
      amount: json['amount'] ?? 0,
      priceOptions: json['priceOptions'] ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'alias': alias,
      'amount': amount,
      'priceOptions': priceOptions,
    };
  }
}

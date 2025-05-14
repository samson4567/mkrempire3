class Mobiledatamodel {
  final bool status;
  final String description;
  final Message message;
  final int statusCode;

  Mobiledatamodel({
    required this.status,
    required this.description,
    required this.message,
    required this.statusCode,
  });

  factory Mobiledatamodel.fromJson(Map<String, dynamic> json) {
    return Mobiledatamodel(
      status: json['status'] ?? false,
      description: json['description'] as String,
      message: Message.fromJson(json['message'] as Map<String, dynamic>),
      statusCode: json['status_code'] as int,
    );
  }
}

class Message {
  final Details details;

  Message({required this.details});

  factory Message.fromJson(Map<String, dynamic> json) {
    print('message json $json');
    return Message(
      details: Details.fromJson(json['details'][0] as Map<String, dynamic>),
    );
  }
}

class Details {
  final String networkName;
  final String networkCode;
  final String title;
  final String checkBalance;
  final String logoUrl;
  final List<Plan> plans;

  Details({
    required this.networkName,
    required this.networkCode,
    required this.title,
    required this.checkBalance,
    required this.logoUrl,
    required this.plans,
  });

  factory Details.fromJson(Map<String, dynamic> json) {
    return Details(
      networkName: json['network_name'] as String,
      networkCode: json['network_code'] as String,
      title: json['title'] as String,
      checkBalance: json['check_balance'] ?? 0, // Handle null values
      logoUrl: json['logo_url'] as String, // Fixed key name
      plans: (json['plans'] as List)
          .map((e) => Plan.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class Plan {
  final String planCode;
  final String name;
  final String category;
  final String alias;
  final int amount;

  Plan({
    required this.planCode,
    required this.name,
    required this.category,
    required this.alias,
    required this.amount,
  });

  factory Plan.fromJson(Map<String, dynamic> json) {
    return Plan(
      planCode: json['plan_code'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      alias: json['alias'] as String,
      amount: json['amount'] as int,
    );
  }
}


// class Plan {
//   final String planCode;
//   final String name;
//   final String category;
//   final String alias;
//   final double amount;

//   Plan({
//     required this.planCode,
//     required this.name,
//     required this.category,
//     required this.alias,
//     required this.amount,
//   });

//   factory Plan.fromJson(Map<String, dynamic> json) {
//     return Plan(
//       planCode: json['plan_code'] as String,
//       name: json['name'] as String,
//       category: json['category'] as String,
//       alias: json['alias'] as String,
//       amount: json['amount'] as double,
//     );
//   }
// }

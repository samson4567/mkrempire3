class KycLookUpModel {
  final bool status;
  final String description;
  final Message message;
  final int statusCode;

  KycLookUpModel({
    required this.status,
    required this.description,
    required this.message,
    required this.statusCode,
  });

  factory KycLookUpModel.fromJson(Map<String, dynamic> json) {
    return KycLookUpModel(
      status: json['status'],
      description: json['description'],
      message: Message.fromJson(json['message']),
      statusCode: json['status_code'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'description': description,
      'message': message.toJson(),
      'status_code': statusCode,
    };
  }
}

class Message {
  final Details details;

  Message({required this.details});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      details: Details.fromJson(json['details']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'details': details.toJson(),
    };
  }
}

class Details {
  final String firstName;
  final String lastName;
  final String middleName;
  final String gender;
  final String phoneNumber;
  final String? expiryDate;
  final String dob;
  final String photo;
  final String transactionStatus;
  final String amount;
  final String totalCharge;
  final String transId;
  final String type;
  final String value;
  final String datetime;
  final dynamic score;
  final bool blacklist;

  Details({
    required this.firstName,
    required this.lastName,
    required this.middleName,
    required this.gender,
    required this.phoneNumber,
    this.expiryDate,
    required this.dob,
    required this.photo,
    required this.transactionStatus,
    required this.amount,
    required this.totalCharge,
    required this.transId,
    required this.type,
    required this.value,
    required this.datetime,
    this.score,
    required this.blacklist,
  });

  factory Details.fromJson(Map<String, dynamic> json) {
    return Details(
      firstName: json['first_name'],
      lastName: json['last_name'],
      middleName: json['middle_name'],
      gender: json['gender'],
      phoneNumber: json['phone_number'],
      expiryDate: json['expiry_date'],
      dob: json['dob'],
      photo: json['photo'],
      transactionStatus: json['transaction_status'],
      amount: json['amount'],
      totalCharge: json['total_charge'],
      transId: json['trans_id'],
      type: json['type'],
      value: json['value'],
      datetime: json['datetime'],
      score: json['score'],
      blacklist: json['blacklist'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'middle_name': middleName,
      'gender': gender,
      'phone_number': phoneNumber,
      'expiry_date': expiryDate,
      'dob': dob,
      'photo': photo,
      'transaction_status': transactionStatus,
      'amount': amount,
      'total_charge': totalCharge,
      'trans_id': transId,
      'type': type,
      'value': value,
      'datetime': datetime,
      'score': score,
      'blacklist': blacklist,
    };
  }
}

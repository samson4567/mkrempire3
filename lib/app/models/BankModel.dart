class BankModel{
  final dynamic id;
  final String bankName;
  final String bankCode;
  final String nibssBankCode;

  BankModel({
    required this.id,
    required this.bankName,
    required this.bankCode,
    required this.nibssBankCode,
  });

  factory BankModel.fromJson(Map<String,dynamic> json){
    return BankModel(
        id: json['id'],
        bankName: json['bankName'],
        bankCode: json['bankCode'],
        nibssBankCode: json['nibssBankCode']);
  }
}


class DepositAddressModel{

  final String chainType;
  final String addressDeposit;
  final String tagDeposit;
  final String chain;
  final String batchReleaseLimit;
  final String contractAddress;

  DepositAddressModel({required this.chainType, required this.addressDeposit,
    required this.tagDeposit, required this.chain, required this.batchReleaseLimit, required this.contractAddress});


  factory DepositAddressModel.fromJson(Map<String,dynamic> json){
    return DepositAddressModel(
      chainType: json['chainType'] ?? "",
      addressDeposit: json['addressDeposit'] ?? "",
      tagDeposit: json['tagDeposit'] ?? "",
      chain: json['chain'] ?? "",
      batchReleaseLimit: json['batchReleaseLimit'] ?? "",
      contractAddress: json['contractAddress'] ?? "",
    );
  }
}
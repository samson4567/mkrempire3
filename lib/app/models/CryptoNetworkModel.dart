class CryptoNetworkModel {
  final List<CryptoInfo> rows;

  CryptoNetworkModel({required this.rows});

  factory CryptoNetworkModel.fromJson(Map<String, dynamic> json) {
    return CryptoNetworkModel(
      rows: (json['rows'] as List)
          .map((row) => CryptoInfo.fromJson(row))
          .toList(),
    );
  }
}

class CryptoInfo {
  final String name;
  final String coin;
  final String remainAmount;
  final List<Network> chains;

  CryptoInfo({
    required this.name,
    required this.coin,
    required this.remainAmount,
    required this.chains,
  });

  factory CryptoInfo.fromJson(Map<String, dynamic> json) {
    return CryptoInfo(
      name: json['name'],
      coin: json['coin'],
      remainAmount: json['remainAmount'],
      chains: (json['chains'] as List)
          .map((chain) => Network.fromJson(chain))
          .toList(),
    );
  }
}

class Network {
  final String chainType;
  final String confirmation;
  final String withdrawFee;
  final String depositMin;
  final String withdrawMin;
  final String chain;
  final String chainDeposit;
  final String chainWithdraw;
  final String minAccuracy;
  final String withdrawPercentageFee;
  final String contractAddress;

  Network({
    required this.chainType,
    required this.confirmation,
    required this.withdrawFee,
    required this.depositMin,
    required this.withdrawMin,
    required this.chain,
    required this.chainDeposit,
    required this.chainWithdraw,
    required this.minAccuracy,
    required this.withdrawPercentageFee,
    required this.contractAddress,
  });

  factory Network.fromJson(Map<String, dynamic> json) {
    return Network(
      chainType: json['chainType'],
      confirmation: json['confirmation'],
      withdrawFee: json['withdrawFee'],
      depositMin: json['depositMin'],
      withdrawMin: json['withdrawMin'],
      chain: json['chain'],
      chainDeposit: json['chainDeposit'],
      chainWithdraw: json['chainWithdraw'],
      minAccuracy: json['minAccuracy'],
      withdrawPercentageFee: json['withdrawPercentageFee'],
      contractAddress: json['contractAddress'],
    );
  }
}

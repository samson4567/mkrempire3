// {
// "coin": "BTC",
// "chain": "BTC",
// "coinShowName": "BTC",
// "chainType": "BTC",
// "blockConfirmNumber": 1,
// "minDepositAmount": "0.000006"
// },

class CoinModel{
  final String coin;
  final String chain;
  final String coinShowName;
  final String chainType;
  final int blockConfirmNumber;
  final String minDepositAmount;

  CoinModel({
    required this.coin,
    required this.chain,
    required this.coinShowName,
    required this.chainType,
    required this.blockConfirmNumber,
    required this.minDepositAmount,
});


  factory CoinModel.fromJson(Map<String, dynamic> json){
    return CoinModel(
        coin: json['coin'],
        chain: json['chain'],
        coinShowName: json['coinShowName'],
        chainType: json['chainType'],
        blockConfirmNumber: json['blockConfirmNumber'],
        minDepositAmount: json['minDepositAmount']
    );
  }
}
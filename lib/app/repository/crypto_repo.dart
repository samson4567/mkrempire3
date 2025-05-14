import 'package:get/get.dart';
import 'package:mkrempire/app/helpers/hive_helper.dart';
import 'package:mkrempire/app/helpers/keys.dart';
import 'package:mkrempire/app/repository/base_repo.dart';
import 'package:mkrempire/routes/api_endpoints.dart';

import '../../routes/api_endpoints.dart';
import 'base_repo.dart';

class CryptoRepo extends BaseRepo {
  CryptoRepo();

  ///getCryptoBalanceUrl
  Future  getAllowedDepositCoins() async {
    try {
      const String endpoint = ApiEndpoints.getAllowedDepositCoinsUrl;
      // print('Request endpoint $endpoint');
      final response = await getRequest(endpoint);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  ///history
  Future  fiatHistory() async {
    try {
      const String endpoint = ApiEndpoints.fiatHistoryUrl;
      // print('Request endpoint $endpoint');
      final response = await getRequest(endpoint);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  ///history
  Future  getBanks() async {
    try {
      const String endpoint = ApiEndpoints.getBanksUrl;
      // print('Request endpoint $endpoint');
      final response = await getRequest(endpoint);
      return response;
    } catch (e) {
      rethrow;
    }
  }



  ///
  Future  getCryptoBalance(String coin) async {
    try {
      const String endpoint = ApiEndpoints.getCryptoBalanceUrl;
      // print('Request endpoint $endpoint');
      final body = {
        "coin": coin
      };
      final response = await getRequestWithParam(body,endpoint);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  ///
  Future  getSingleCryptoBalance(String coin) async {
    try {
      const String endpoint = ApiEndpoints.getSingleBalanceUrl;
      // print('Request endpoint $endpoint');
      final body = {
        "coin": coin
      };
      final response = await getRequestWithParam(body,endpoint);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  /// Login Method
  Future  getCoinInfo(coin) async {
    try {
      const String endpoint = ApiEndpoints.getCoinInfoUrl;
      // print('Request endpoint $endpoint');
      final body = {
        "coin":coin
      };
      final response = await getRequestWithParam(body,endpoint);
      return response;
    } catch (e) {
      rethrow;
    }
  }


  Future  getRecord() async {
    try {
      const String endpoint = ApiEndpoints.getRecordUrl;
      // print('Request endpoint $endpoint');
      final body = {
        "coin":""
      };
      final response = await getRequest(endpoint);
      return response;
    } catch (e) {
      rethrow;
    }
  }
  Future  getCryptos() async {
    try {
      const String endpoint = ApiEndpoints.getCryptos;

      final response = await getRequest(endpoint);
      return response;
    } catch (e) {
      rethrow;
    }
  }
  Future  gateways() async {
    try {
      const String endpoint = ApiEndpoints.gatewaysUrl;

      final response = await getRequest(endpoint);
      return response;
    } catch (e) {
      rethrow;
    }
  }



  Future  getCryptoWithdrawalHistory() async {
    try {
      const String endpoint = ApiEndpoints.getCryptoWithdrawalHistoryUrl;
      // print('Request endpoint $endpoint');
      final body = {
        "coin":""
      };
      final response = await getRequest(endpoint);
      return response;
    } catch (e) {
      rethrow;
    }
  }
  Future  getSwapCoinList() async {
    try {
      const String endpoint = ApiEndpoints.getSwapCoinListUrl;
      final response = await getRequest(endpoint);
      return response;
    } catch (e) {
      rethrow;
    }
  }
  Future  dashboard() async {
    try {
      const String endpoint = ApiEndpoints.dashboardUrl;
      final response = await getRequest(endpoint);
      return response;
    } catch (e) {
      rethrow;
    }
  }


  Future  getStakeProductInfo(coin) async {
    try {
      const String endpoint = ApiEndpoints.getStakeProductInfoUrl;
      final body = {
        "coin":coin
      };
      final response = await getRequestWithParam(body,endpoint);
      return response;
    } catch (e) {
      rethrow;
    }
  }


  Future  getTickers(coin) async {
    try {
      const String endpoint = ApiEndpoints.getTickersUrl;
      final body ={
        "category":"linear",
        "symbol":coin
      };
      final response = await getRequestWithParam(body,endpoint);
      return response;
    } catch (e) {
      rethrow;
    }
  }
  Future  getMarkets(limit,currency) async {
    try {
      const String endpoint = ApiEndpoints.getMarketsUrl;
      final body ={
        "limit":limit,
        "currency":currency
      };
      final response = await getRequestWithParam(body,endpoint);
      return response;
    } catch (e) {
      rethrow;
    }
  }




  Future  getSingleCryptoInfo(coin) async {
    try {
      const String endpoint = ApiEndpoints.getSingleCryptoInfoUrl;
      final body ={
        "coin":coin
      };
      final response = await getRequestWithParam(body,endpoint);
      return response;
    } catch (e) {
      rethrow;
    }
  }




  Future  getWalletBalance() async {
    try {
      const String endpoint = ApiEndpoints.getWalletBalanceUrl;
      // print('Request endpoint $endpoint');
      final body = {
        "coin":""
      };
      final response = await getRequest(endpoint);
      return response;
    } catch (e) {
      rethrow;
    }
  }


  Future  deposit(coin,chainType) async {
    try {
      const String endpoint = ApiEndpoints.cryptoDepositUrl;
      // print('Request endpoint $endpoint');
      final body = {
        "coin":coin,
        "chainType":chainType
      };
      final response = await postWithToken(body,endpoint);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future  getMasterDepositAddress(coin,chainType) async {
    try {
      const String endpoint = ApiEndpoints.getMasterDepositAddressUrl;
      // print('Request endpoint $endpoint');
      final body = {
        "coin":coin,
        "chainType":chainType
      };
      final response = await postWithToken(body,endpoint);
      return response;
    } catch (e) {
      rethrow;
    }
  }


  Future  requestSwapRate(fromCoin,toCoin,amount) async {
    try {
      const String endpoint = ApiEndpoints.requestSwapRateUrl;
      // print('Request endpoint $endpoint');
      final body ={
        "fromCoin": fromCoin,
        "toCoin": toCoin,
        "requestCoin": fromCoin,
        "requestAmount": amount
      };
      final response = await postWithToken(body,endpoint);
      return response;
    } catch (e) {
      rethrow;
    }
  }
  Future  swap(quoteTxId) async {
    try {
      const String endpoint = ApiEndpoints.swapUrl;
      // print('Request endpoint $endpoint');
      final body ={
        "quoteTxId": quoteTxId,
      };
      final response = await postWithToken(body,endpoint);
      return response;
    } catch (e) {
      rethrow;
    }
  }




  Future  withdraw(coin,chain,address, amount) async {
    try {
      const String endpoint = ApiEndpoints.cryptoWithdrawalUrl;
      // print('Request endpoint $endpoint');
      final body = {
        "chain": chain,
        "coin": coin,
        "address":address,
        "amount":amount
      };
      final response = await postWithToken(body,endpoint);
      return response;
    } catch (e) {
      rethrow;
    }
  }


  Future  paymentRequest(Map<String,dynamic>  body) async {
    try {
      const String endpoint = ApiEndpoints.paymentRequest;
      final response = await postWithToken(body,endpoint);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future  createTempAccount(Map<String,dynamic>  body) async {
    try {
      const String endpoint = ApiEndpoints.createTempAccountUrl;
      final response = await postWithToken(body,endpoint);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future  verifyPayment(Map<String,dynamic>  body) async {
    try {
      const String endpoint = ApiEndpoints.varifyPaymentUrl;
      final response = await postWithToken(body,endpoint);
      return response;
    } catch (e) {
      rethrow;
    }
  }


  Future  manualPayment(Map<String,dynamic>  body,String trx_id) async {
    try {
      String endpoint = '${ApiEndpoints.manualPaymentUrl}/$trx_id';
      final response = await postWithToken(body,endpoint);
      // Get.snackbar('title', response);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future  validate(Map<String,dynamic>  body) async {
    try {
      String endpoint = '${ApiEndpoints.getValidateUrl}';
      final response = await postWithToken(body,endpoint);
      // Get.snackbar('title', response);
      return response;
    } catch (e) {
      rethrow;
    }
  }
  Future  withdrawFiat(Map<String,dynamic>  body) async {
    try {
      print(body);
      String endpoint = '${ApiEndpoints.withdrawFiatUrl}';
      final response = await postWithToken(body,endpoint);
      // Get.snackbar('title', response);
      return response;
    } catch (e) {
      rethrow;
    }
  }


  Future  stakeCrypto(coin,productId, amount) async {
    try {
      const String endpoint = ApiEndpoints.stakeCryptoUrl;
      // print('Request endpoint $endpoint');
      final body = {
        "coin":coin,
        "amount": amount,
        "productId":productId
      };
      final response = await postWithToken(body,endpoint);
      return response;
    } catch (e) {
      rethrow;
    }
  }


  Future  placeOrder(symbol,quantity, side) async {
    try {
      const String endpoint = ApiEndpoints.getPlaceOrderUrl;
      print('Request endpoint ={ "symbol": $symbol, "quantity" : $quantity, "side" : $side }');
      final body ={
        "symbol": symbol,
        "quantity" : quantity,
        "side" : side
      };
      final response = await postWithToken(body,endpoint);
      // print(response);
      return response;
    } catch (e) {
      rethrow;
    }
  }



}
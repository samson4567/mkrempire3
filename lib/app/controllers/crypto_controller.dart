import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mkrempire/app/helpers/hive_helper.dart';
import 'package:mkrempire/app/models/CoinModel.dart';
import 'package:mkrempire/app/models/DepositAddressModel.dart';
import 'package:mkrempire/app/repository/crypto_repo.dart';
import 'package:mkrempire/routes/route_names.dart';

// import '../../resources/screens/bottom_nav_bar.dart';
import '../../resources/screens/others/bottom_nav_bar.dart';
import '../../resources/widgets/custom_dialog.dart';
import '../helpers/keys.dart';
import '../models/CryptoNetworkModel.dart';

class CryptoController extends GetxController {
  RxBool isLoading = false.obs;
  late BuildContext context;
  RxBool showDepositHistory = true.obs;
  RxBool showWithdrawalHistory = true.obs;
  RxList<CoinModel> cryptoList = <CoinModel>[].obs;
  RxList<Network> networkList = <Network>[].obs;
  RxList<dynamic> cryptoBalances = <dynamic>[].obs;
  RxList<dynamic> cryptoBalanceDatas = <dynamic>[].obs;
  RxList<dynamic> coinMarketcap = <dynamic>[].obs;
  RxList<dynamic> walletHistories = <dynamic>[].obs;
  RxList<dynamic> withdrawalHistories = <dynamic>[].obs;
  RxList<dynamic> swapCoinLists = <dynamic>[].obs;
  RxList<dynamic> stakeProducts = <dynamic>[].obs;
  RxList<dynamic> markets = <dynamic>[].obs;
  RxDouble coinBalance = 0.00.obs;
  RxDouble withdrawableAmount = 0.00.obs;
  Map<String, dynamic> dashboardData = {};
  RxMap<String, dynamic> swapRateLists = <String, dynamic>{}.obs;
  RxList<dynamic> histories = <dynamic>[].obs;
  RxList<dynamic> bankList = <dynamic>[].obs;
  RxMap<String, dynamic> tickers = <String, dynamic>{}.obs;
  RxMap<String, dynamic> ethData = <String, dynamic>{}.obs;
  RxMap<String, dynamic> tradeResponse = <String, dynamic>{}.obs;
  Map<String, dynamic> selectedGateway = {};
  Map<String, dynamic> selectedCrypto = {};
  double conversionRate = 0.00;
  var selectedBankCode = ''.obs;
  var selectedBankName = 'Select bank'.obs;
  var selectedCurrency = '🇺🇸USD'.obs;
  var selectedCurrencyCode = '\$'.obs;
  var currencyBalance = 0.00.obs;

  Network selectedNetwork = Network.fromJson({
    "chainType": "",
    "confirmation": "1",
    "withdrawFee": "0",
    "depositMin": "0.001",
    "withdrawMin": "0",
    "chain": "",
    "chainDeposit": "1",
    "chainWithdraw": "1",
    "minAccuracy": "4",
    "withdrawPercentageFee": "0",
    "contractAddress": ""
  });
  CryptoRepo cryptoRepo = CryptoRepo();
  RxBool showCryptoWithdrawal = true.obs;
  RxBool showStake = true.obs;
  DepositAddressModel depositAddressModel = DepositAddressModel.fromJson({});
  TextEditingController amountController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  Future<void> getAllowedDepositCoins() async {
    Future.delayed(Duration(seconds: 2));
    isLoading.value = true;
    try {
      final response = await cryptoRepo.getAllowedDepositCoins();
      print("dsbdjkabdsjkdajsdhajhda-response_is_${response}");
      if (response != null && response['configList'] != null) {
        List<CoinModel> newList = (response['configList'] as List)
            .map((e) => CoinModel.fromJson(e))
            .toList();

        // Add only new coins that don't already exist in the list
        for (var newCoin in newList) {
          if (!cryptoList.any((coin) => coin.coin == newCoin.coin)) {
            cryptoList.add(newCoin);
          }
        }
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getAllowedWithdrawCoins() async {
    Future.delayed(Duration(seconds: 2));
    isLoading.value = true;
    try {
      final response = await cryptoRepo.getAllowedDepositCoins();
      if (response != null && response['configList'] != null) {
        List<CoinModel> newList = (response['configList'] as List)
            .map((e) => CoinModel.fromJson(e))
            .toList();

        // Add only new coins that don't already exist in the list
        for (var newCoin in newList) {
          if (!cryptoList.any((coin) => coin.coin == newCoin.coin)) {
            cryptoList.add(newCoin);
          }
        }
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getCryptoBalance(String coin) async {
    cryptoBalances.value = [];
    cryptoBalanceDatas.value = [];
    coinMarketcap.value = [];
    isLoading.value = true;
    try {
      final response = await cryptoRepo.getCryptoBalance(coin);
      if (response != null && response['balance'] != null) {
        coinBalance.value = double.parse(response['balance'].toString());
        cryptoBalances.addAll(response['bybit']);
        cryptoBalanceDatas.addAll(response['cryptocompare']);
        coinMarketcap.addAll(response['coinmarketcap']);
      } else {
        print("No balance found in the response.");
      }
      // print(response);
      // print(cryptoBalances);
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future getSingleCryptoBalance(String coin) async {
    isLoading.value = true;
    try {
      final response = await cryptoRepo.getSingleCryptoBalance(coin);
      if (response['status'] == 'success') {
        tradeResponse.addAll(response);
      }
      return response;
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getETHData() async {
    // isLoading.value = true;
    try {
      final response = await cryptoRepo.getSingleCryptoInfo('ETH');
      ethData.value = {};
      ethData.addAll(response['message']);
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getCoinInfo(String coin) async {
    isLoading.value = true;
    try {
      final response = await cryptoRepo.getCoinInfo(coin);
      if (response != null && response['rows'] != null) {
        List<CryptoInfo> cryptoInfoList = (response['rows'] as List)
            .map((e) => CryptoInfo.fromJson(e))
            .toList();

        // Extract networks (chains) from CryptoInfo
        if (cryptoInfoList.isNotEmpty) {
          networkList.assignAll(cryptoInfoList.first.chains);
        }
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deposit(String coin, String chainType) async {
    isLoading.value = true;
    // depositAddressModel = null;
    try {
      print("$coin, $chainType");
      final response = await cryptoRepo.deposit(coin, chainType);
      print(response);
      depositAddressModel = DepositAddressModel.fromJson(response['chains']);
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getMasterDepositAddress(String coin, String chainType) async {
    isLoading.value = true;
    // depositAddressModel = null;
    try {
      print("$coin, $chainType");
      final response =
          await cryptoRepo.getMasterDepositAddress(coin, chainType);
      print(response);
      depositAddressModel = DepositAddressModel.fromJson(response['chains']);
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> withdraw(context, coin, chain, address, amount) async {
    isLoading.value = true;
    // depositAddressModel = null;
    try {
      // print("$coin, $chainType");
      final response = await cryptoRepo.withdraw(coin, chain, address, amount);
      print(response);
      if (response['status'] == 'error') {
        CustomDialog.showWarning(
            buttonAction: () => Get.back(),
            context: context,
            message: "${response['message']}",
            buttonText: 'Cancel');
      } else {
        CustomDialog.showSuccess(
            buttonAction: () => Get.offAllNamed(RoutesName.bottomNavBar),
            context: context,
            message: "Withdrwal Successful",
            buttonText: 'Home');
      }
      // depositAddressModel =  DepositAddressModel.fromJson(response['chains']);
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> stakeCrypto(coin, productId, amount) async {
    isLoading.value = true;
    try {
      final response = await cryptoRepo.stakeCrypto(coin, productId, amount);
      print(response);
      if (response['status'] == 'error') {
        CustomDialog.showWarning(
            buttonAction: () => Get.back(),
            context: context,
            message: "${response['message']}",
            buttonText: 'Cancel');
      } else {
        CustomDialog.showSuccess(
            buttonAction: () => Get.offAllNamed(RoutesName.bottomNavBar),
            context: context,
            message: "$coin Staked Successful",
            buttonText: 'Home');
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getTickers() async {
    // isLoading.value = true;
    // tickers.value = {};
    var coin = "BTCUSDT,SOLUSDT,ETHUSDT,DOGEUSDT,XRPUSDT";
    try {
      final response = await cryptoRepo.getTickers(coin);
      // print(response);
      if (response['status'] == 'error') {
        Get.snackbar('Error', "${response['message']}",
            backgroundColor: Colors.red, colorText: Colors.white);
        // CustomDialog.showWarning(buttonAction: ()=> Get.back(), context: context, message: "${response['message']}", buttonText: 'Cancel');
      } else {
        tickers.addAll(response['message']);
        // CustomDialog.showSuccess(buttonAction: ()=> Get.offAllNamed(RoutesName.bottomNavBar),context: context, message: "$coin Staked Successful", buttonText: 'Home');
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getMarkets() async {
    // isLoading.value = true;

    try {
      final response = await cryptoRepo.getMarkets('100', 'USD');
      if (response['status'] == 'error') {
        Get.snackbar('Error', "${response['message']}",
            backgroundColor: Colors.red, colorText: Colors.white);
      } else {
        // print(response['message']);
        markets.value = [];
        markets.addAll(response['message']);
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getRecord() async {
    isLoading.value = true;
    walletHistories.value = [];
    // depositAddressModel = null;
    try {
      // print("$coin, $chainType");
      final response = await cryptoRepo.getRecord();
      print(response);
      walletHistories.addAll(response['rows']);
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getCryptoWithdrawalHistory() async {
    isLoading.value = true;
    withdrawalHistories.value = [];
    // depositAddressModel = null;
    try {
      // print("$coin, $chainType");
      final response = await cryptoRepo.getCryptoWithdrawalHistory();
      print(response);
      withdrawalHistories.addAll(response['list']);
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getWalletBalance() async {
    isLoading.value = true;
    walletHistories.value = [];
    // depositAddressModel = null;
    try {
      // print("$coin, $chainType");
      final response = await cryptoRepo.getWalletBalance();
      print(response);
      // walletHistories.addAll(response['rows']);
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getSwapCoinList() async {
    isLoading.value = true;
    swapCoinLists.value = [];
    try {
      final response = await cryptoRepo.getSwapCoinList();
      print(response);
      swapCoinLists.addAll(response['coins']);
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getStakeProductInfo(coin) async {
    isLoading.value = true;
    stakeProducts.value = [];
    try {
      final response = await cryptoRepo.getStakeProductInfo(coin);
      print(response);
      // {status: error, message: {retCode: 180002, retMsg: Invalid coin, result: [], retExtInfo: [], time: 1741825809787}}
      if (response['status'] == 'error') {
        CustomDialog.showError(
            context: this.context,
            message: "$coin is not available for staking at the moment",
            buttonText: 'Cancel',
            buttonAction: () {
              Get.back();
            });
      } else {
        stakeProducts.addAll(response['list']);
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> requestSwapRate(fromCoin, toCoin, amount) async {
    isLoading.value = true;
    try {
      final response =
          await cryptoRepo.requestSwapRate(fromCoin, toCoin, amount);
      // print(response);
      if (response['status'] == 'error') {
        CustomDialog.showError(
            context: this.context,
            message: response['message'],
            buttonText: 'Cancel',
            buttonAction: () => Get.back());
      } else {
        swapRateLists.value = {};
        swapRateLists.value = response['message'];
      }
      print(swapRateLists.value);
      // swapCoinLists.addAll(response['coins']);
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future swap(quoteTxId) async {
    isLoading.value = true;
    try {
      final response = await cryptoRepo.swap(quoteTxId);
      // final responseData = jsonDecode(response);
      print(response);
      return response;

      // if(response['status'] == 'error'){
      //   CustomDialog.showError(
      //       context: this.context, message: response['message'], buttonText: 'Cancel',
      //       buttonAction: ()=>Get.back()
      //   );
      // }else{
      //
      //   CustomDialog.showError(
      //       context: this.context, message: response, buttonText: 'Cancel',
      //       buttonAction: ()=>Get.back()
      //   );
      // }
      isLoading.value = false;
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future placeOrder(symbol, quantity, side) async {
    isLoading.value = true;
    try {
      final response = await cryptoRepo.placeOrder(symbol, quantity, side);

      // print(response);
      CustomDialog.showSuccess(
          context: context,
          message: '$response',
          buttonText: 'Home',
          buttonAction: () => Get.to(BottomNavBar()));
      return response;
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future getCryptos() async {
    isLoading.value = true;
    try {
      final response = await cryptoRepo.getCryptos();
      //
      print(response);
      // CustomDialog.showSuccess(context: context, message: '$response', buttonText: 'Home', buttonAction: ()=>Get.to(BottomNavBar()));
      return response;
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future gateways() async {
    isLoading.value = true;
    try {
      final response = await cryptoRepo.gateways();
      //
      print(response['message']['gateways']);
      // CustomDialog.showSuccess(context: context, message: '${response['message']['gateways']}', buttonText: 'Home', buttonAction: ()=>Get.to(BottomNavBar()));
      return response['message']['gateways'];
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future paymentRequest(Map<String, dynamic> body) async {
    isLoading.value = true;
    try {
      final response = await cryptoRepo.paymentRequest(body);
      //
      // print(response['message']['gateways']);
      // CustomDialog.showSuccess(context: context, message: '${response['message']['gateways']}', buttonText: 'Home', buttonAction: ()=>Get.to(BottomNavBar()));
      return response;
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future manualPayment(Map<String, dynamic> body, String trx_id) async {
    isLoading.value = true;
    try {
      final response = await cryptoRepo.manualPayment(body, trx_id);
      //
      // print(response['message']['gateways']);
      // CustomDialog.showSuccess(context: context, message: '${response['message']['gateways']}', buttonText: 'Home', buttonAction: ()=>Get.to(BottomNavBar()));
      return response;
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future validate(Map<String, dynamic> body) async {
    isLoading.value = true;
    try {
      final response = await cryptoRepo.validate(body);
      //
      // print(response['message']['gateways']);
      // CustomDialog.showSuccess(context: context, message: '${response['message']['gateways']}', buttonText: 'Home', buttonAction: ()=>Get.to(BottomNavBar()));
      return response;
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future withdrawFiat(Map<String, dynamic> body) async {
    print(body);
    isLoading.value = true;
    try {
      final response = await cryptoRepo.withdrawFiat(body);
      //
      print(response);
      // CustomDialog.showSuccess(context: context, message: '${response['message']['gateways']}', buttonText: 'Home', buttonAction: ()=>Get.to(BottomNavBar()));
      return response;
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future fiatHistory() async {
    isLoading.value = true;
    histories.value = [];
    try {
      final response = await cryptoRepo.fiatHistory();
      histories.addAll(response);
      print(response);
      return response;
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future getBanks() async {
    isLoading.value = true;
    bankList.value = [];
    try {
      final response = await cryptoRepo.getBanks();
      bankList.addAll(response['banks']);
      print(response['banks']);
      return response['banks'];
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future dashboard() async {
    isLoading.value = true;
    try {
      final response = await cryptoRepo.dashboard();
      dashboardData = response['message'];
      HiveHelper.write(Keys.userWallets, dashboardData['wallets']);
      //
      print(dashboardData);
      currencyBalance.value = getBalanceForCurrency(selectedCurrencyCode.value);
      // CustomDialog.showSuccess(context: context, message: '${response['message']['gateways']}', buttonText: 'Home', buttonAction: ()=>Get.to(BottomNavBar()));
      return response;
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future createTempAccount(Map<String, dynamic> body) async {
    isLoading.value = true;
    try {
      final response = await cryptoRepo.createTempAccount(body);
      // dashboardData = response['message'];
      // HiveHelper.write(Keys.userWallets,dashboardData['wallets']);
      //
      print(response);
      // currencyBalance.value = getBalanceForCurrency(selectedCurrencyCode.value);
      // CustomDialog.showSuccess(context: context, message: '${response['message']['gateways']}', buttonText: 'Home', buttonAction: ()=>Get.to(BottomNavBar()));
      return response['message'];
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future verifyPayment(Map<String, dynamic> body) async {
    // isLoading.value = true;
    try {
      final response = await cryptoRepo.verifyPayment(body);
      print("response: $response");

      return response;
    } catch (e) {
      print("Error: $e");
    } finally {
      // isLoading.value = false;
    }
  }

  double getBalanceForCurrency(String code) {
    // Read the wallet data from Hive
    var wallets = dashboardData['wallets']; //HiveHelper.read(Keys.userWallets);
    print(wallets);
    if (wallets != null) {
      // Assuming wallets is a List<Map<String, dynamic>>
      for (var wallet in wallets) {
        if (wallet['currency_code'] ==
            code.replaceAll('₦', 'NGN').replaceAll('\$', 'USD')) {
          return double.parse(wallet['balance'].toString());
        }
      }
    }
    return 0.0; // Return 0 if no matching currency is found
  }
}

import 'package:flutter/cupertino.dart';
import 'package:mkrempire/app/helpers/hive_helper.dart';
import 'package:mkrempire/app/helpers/keys.dart';
import 'package:mkrempire/app/repository/virtual_card_repo.dart';
import 'package:mkrempire/resources/screens/others/kyc.dart';
import 'package:get/get.dart';

import '../../resources/widgets/custom_dialog.dart';

class VirtualcardController extends GetxController {
  late VirtualCardRepo virtualCardRepo;
  var virtualCardList = [].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    virtualCardRepo = VirtualCardRepo();
    super.onInit();
  }

  Future<Map<String, dynamic>> createVirtualCard({
    required customerId,
    required String currency,
    required String brand,
    required int amount,
    required String type,
    required Function() onSuccess,
  }) async {
    try {
      isLoading.value = true;
      final response = await virtualCardRepo.createCards(json: {
        "customer_id": customerId,
        "currency": currency,
        "brand": brand,
        "amount": amount,
        "type": type,
      });
      if (response['status'] == true) {
        final cardDetails = response['message']['details']['card'];

        final virtualCard = {
          'id': cardDetails['id'],
          'card_type': cardDetails['card_type'],
          'currency': cardDetails['currency'],
          'brand': cardDetails['brand'],
          'name': cardDetails['name'],
          'masked_number': cardDetails['masked'],
          'full_number': cardDetails['number'],
          'expiry': cardDetails['expiry'],
          'last_four': cardDetails['last_four'],
          'created_at': cardDetails['created_at'],
        };

        virtualCardList.add(virtualCard);
        onSuccess();
      }
      else if (
      response['description'] == 'There was an error when creating the card, please contact support if it persist') {
        CustomDialog.showWarning(
            context: Get.context!,
            message: response['description'],
            // buttonAction: () {
            //   Get.off(() => KYCScreen());
            // },
            buttonText: "Close");
      }else if (
      response['status_code'] == 400) {
        CustomDialog.showWarning(
            context: Get.context!,
            message: response['description'],
            buttonAction: () {
              Get.off(() => KYCScreen());
            },
            buttonText: "Go to KYC");
      } else {
        if (response['status'] == 'error'){
          CustomDialog.showWarning(
              context: Get.context!,
              message: response['message'],
              buttonText: "Close");
        }else {
          CustomDialog.showWarning(
              context: Get.context!,
              message: response['description'],
              buttonText: "Close");
        }
      }
    } catch (e) {
      print('Error $e');
    } finally {
      isLoading.value = false;
    }
    return {};
  }

  TextEditingController amountController = TextEditingController();
  var isTopping = false.obs;
  Future<void> TopUp({
    required double amount,
  }) async {
    try {
      isTopping.value = true;
      var response = await virtualCardRepo.TopUp(
          json: {'amount': amount, 'ref': HiveHelper.read(Keys.payscribeId)});
      if (response['status'] == true) {
        CustomDialog.showSuccess(
            context: Get.context!,
            message: response['description'],
            buttonText: "Close");
      } else {
        CustomDialog.showError(
            context: Get.context!,
            message: response['description'],
            buttonText: "close");
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      isTopping.value = false;
    }
  }

  Future<void> withdraw({
    required double amount,
  }) async {
    try {
      isLoading.value = true;
      var response = await virtualCardRepo.withdraw(
          json: {'amount': amount, 'ref': HiveHelper.read(Keys.payscribeId)});
      if (response['status'] == true) {
        CustomDialog.showSuccess(
            context: Get.context!,
            message: response['description'],
            buttonText: "Close");
      } else {
        CustomDialog.showError(
            context: Get.context!,
            message: response['description'],
            buttonText: "Close");
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> freezeCard() async {
    try {
      isLoading.value = true;
      var response = await virtualCardRepo
          .freezeCards(json: {'ref': HiveHelper.read(Keys.payscribeId)});
      if (response['status'] == true) {
        CustomDialog.showSuccess(
            context: Get.context!,
            message: response['description'],
            buttonText: "Close");
      } else {
        CustomDialog.showError(
            context: Get.context!,
            message: response['description'],
            buttonText: "Close");
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> terminateCard() async {
    try {
      isLoading.value = true;
      var response = await virtualCardRepo
          .terminateCards(json: {'ref': HiveHelper.read(Keys.payscribeId)});
      if (response['status'] == true) {
        CustomDialog.showSuccess(
            context: Get.context!,
            message: response['description'],
            buttonText: "Close");
      } else {
        CustomDialog.showError(
            context: Get.context!,
            message: response['description'],
            buttonText: "Close");
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> unfreezeCard() async {
    try {
      isLoading.value = true;
      var response = await virtualCardRepo
          .unfreezeCards(json: {'ref': HiveHelper.read(Keys.payscribeId)});
      if (response['status'] == true) {
        CustomDialog.showSuccess(
            context: Get.context!,
            message: response['description'],
            buttonText: "Close");
      } else {
        CustomDialog.showError(
            context: Get.context!,
            message: response['description'],
            buttonText: "Close");
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      isLoading.value = false;
    }
  }
}

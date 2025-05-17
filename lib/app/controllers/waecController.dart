import 'package:flutter/material.dart';
import 'package:mkrempire/app/controllers/auth_controller.dart';
import 'package:mkrempire/app/helpers/hive_helper.dart';
import 'package:mkrempire/app/helpers/keys.dart';
import 'package:mkrempire/app/repository/waecRepo.dart';
import 'package:mkrempire/resources/widgets/custom_dialog.dart';
import 'package:get/get.dart';

class Waeccontroller extends GetxController {
  late Waecrepo waecrepo;
  var isLoading = false.obs;
  var isPurchasing = false.obs;
  var collection = [].obs;

  @override
  void onInit() {
    waecrepo = Waecrepo();
    getPin();
    super.onInit();
  }

  Future<void> getPin() async {
    try {
      isLoading.value = true;
      var response = await waecrepo.getPins();
      if (response['status'] == true) {
        collection.value = response['message']['details'][0]['collection'];
        print(collection);
      } else {
        CustomDialog.showError(
            context: Get.context!,
            message: response['description'],
            buttonText: "Close");
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  TextEditingController qtyController = TextEditingController();
  TextEditingController idController = TextEditingController();
  var quantity = ''.obs;
  var id = ''.obs;
  Future<void> purchasePins({
    required int qty,
    required String id,
    required String amount,
  }) async {
    try {
      isPurchasing.value = true;
      var response = await waecrepo.purchasePins(
          qty: qty,
          id: id,
          ref: HiveHelper.read(Keys.payscribeId),
          amount: amount);
      if (response['status'] == true) {
        final totalCharge = response['message']['details']['total_charge'];
        final AuthController balance = Get.find();

        final double currentBalance = double.parse(balance.balance.value);
        final double newBalance = currentBalance - totalCharge;
        balance.balance.value = newBalance.toString();

        await balance.getBalance();
        CustomDialog.showSuccess(
            necoPin: response['messages']['details']['pin'],
            context: Get.context!,
            message: "ePin purchase successful!",
            buttonText: "Close",
            buttonAction: () {
              Get.back();
              Get.back();
            });
      } else if (response['status'] == false) {
        CustomDialog.showError(
            context: Get.context!,
            message: response['description'],
            buttonText: "Close");
      } else {
        CustomDialog.showError(
            context: Get.context!,
            message: response['message'],
            buttonText: "Close");
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      isPurchasing.value = false;
    }
  }
}

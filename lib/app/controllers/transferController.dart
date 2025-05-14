import 'package:mkrempire/app/repository/transfer_repo.dart';
import 'package:get/get.dart';

import '../../resources/widgets/custom_dialog.dart';
import '../../routes/route_names.dart';

class Transfercontroller extends GetxController {
  var isLooking = false.obs;
  late TransferRepo transferRepo;
  var accountName = ''.obs;
  var errorMessage = ''.obs;
  var currency = ''.obs;
  var fee = 0.obs;
  var isfetching = false.obs;
  var isTransferring = false.obs;
  var transId = ''.obs;

  @override
  void onInit() {
    transferRepo = TransferRepo();
    super.onInit();
  }

  Future<void> accountLookup({
    required String acctNo,
    required String bank,
  }) async {
    // Add your function implementation here
    try {
      isLooking.value = true;
      var response =
          await transferRepo.accountLookup(acctNo: acctNo, bank: bank);
      if (response['status'] == true) {
        accountName.value = response['message']['details']['account_name'];
      } else {
        errorMessage.value = response['description'];
        throw Exception(errorMessage.value);
      }
    } catch (e) {
      CustomDialog.showError(
          context: Get.context!,
          message: " ${e.toString()}",
          buttonText: 'close');
      print('Error: ${e.toString()}');
    } finally {
      isLooking.value = false;
    }
  }

  Future<void> payOutFee({required amount}) async {
    // Add your function implementation here
    isfetching.value = true;
    try {
      var response = await transferRepo.payOutFees(amount: amount);
      if (response['status'] == true) {
        currency.value = response['message']['details']['currency'];
        fee.value = response['message']['details']['fee'];
      } else {
        errorMessage.value = response['description'];
        throw Exception(errorMessage.value);
      }
    } catch (e) {
      // CustomDialog.showError(
      //     context: Get.context!,
      //     message: " ${e.toString()}",
      //     buttonText: 'close');
      print('Error Payout: ${e.toString()}');
    } finally {
      isfetching.value = false;
    }
  }

  Future<void> transfer(
      {required String amount,
      required String bank,
      required String account,
      required String currencies,
      required String narration}) async {
    try {
      isTransferring.value = true;
      print('Account Name: $account');
      print('Bank: $bank');
      print('Currency: ${currencies}');
      print('Fee: ${fee.value}');

      var responseData = await transferRepo.transfer(
          acctNo: account,
          bank: bank,
          currencies: currencies,
          amount: amount,
          narration: narration);
      if (responseData['status'] == true) {
        transId.value = responseData['message']['details']['trans_id'];
        // await verifyTransfer(transId: transId.value);

        CustomDialog.showSuccess(
          context: Get.context!,
          message: responseData['description'],
          buttonText: "close",
          buttonAction: () => Get.toNamed(RoutesName.bottomNavBar),
        );
      } else if (responseData['status'] == false) {
        errorMessage.value = responseData['description'];
        CustomDialog.showError(
            context: Get.context!,
            message: errorMessage.value,
            buttonText: "close");
      } else {
        errorMessage.value = responseData['message'];
        CustomDialog.showError(
            context: Get.context!,
            message: errorMessage.value,
            buttonText: "close");
      }
    } catch (e) {
      print('Error:$e');
    } finally {
      isTransferring.value = false;
    }
  }
}

import 'package:flutter/cupertino.dart';
import 'package:mkrempire/app/controllers/virtualCard_controller.dart';
import 'package:mkrempire/app/repository/kycrepo.dart';
import 'package:get/get.dart';
import 'package:mkrempire/resources/screens/others/bottom_nav_bar.dart';
import 'package:mkrempire/resources/screens/virtual_card/virtual_card_screen.dart';

import '../../resources/screens/others/address_verification.dart';
import '../../resources/widgets/custom_dialog.dart';

class KycController extends GetxController {
  late Kycrepo kycrepo;
  var firstName = ''.obs;
  var lastName = ''.obs;
  var dob = ''.obs; // date of birth
  var phoneNumber = ''.obs;
  var gender = ''.obs;
  var pin_Id = ''.obs;
  var bvnController = TextEditingController().obs;
  var isSubmitting = false.obs;
  final isBvnEmpty = true.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    kycrepo = Kycrepo();
    bvnController.value.addListener(() {
      isBvnEmpty.value = bvnController.value.text.isEmpty;
    });
    super.onInit();
  }

  Future<void> submitKyc(
      {required String kycData, required VoidCallback onPressed}) async {
    try {
      isSubmitting.value = true;
      var response = await kycrepo.submitKycData(bvnNo: kycData);
      print(response);
      if (response['data']['status'] == true) {
        var details = response['data']['message']['details'];
        firstName.value = details['first_name'] ?? '';
        lastName.value = details['last_name'] ?? '';
        dob.value = details['dob'] ?? '';
        gender.value = details['gender'] ?? '';
        phoneNumber.value = details['phone_number'] ?? '';

        print("firstName: ${firstName.value}");

        CustomDialog.showSuccess(
            buttonText: "Continue",
            message: response['data']['description'],
            context: Get.context!,
            buttonAction: onPressed);

        // bvnController.value.clear();
      } else {
        CustomDialog.showError(
            message: response['data']['description'],
            context: Get.context!,
            buttonText: "close");
        print('Error: ${response['description']}');
      }
    } catch (e) {
      // Handle error
      CustomDialog.showError(
          message: "An error occurred: ${e.toString()}",
          context: Get.context!,
          buttonText: "close");
      print('Exception: $e');
    } finally {
      isSubmitting.value = false;
    }
  }

  var oTp = ''.obs;
  Future<void> sendOtp(VoidCallback onPressed) async {
    try {
      var response = await kycrepo.sendOtp();
      var otp = response['otp']['original']['smsStatus'] ?? '';
      pin_Id.value = response['otp']['original']['pinId'] ?? '';
      print(response);
      if (response['otp']['original']['status'] == '200') {
        CustomDialog.showSuccess(
            context: Get.context!,
            message: '$otp',
            buttonText: "Continue",
            buttonAction: onPressed);

        update();
        // Handle successful OTP send
      } else {
        // Handle OTP send failure
        CustomDialog.showError(
            context: Get.context!,
            message: "Failed to Send OTP",
            buttonText: "close");
      }
    } catch (e) {
      // Handle error
      print('Error: $e');
    }
  }

  Future<void> verifyOtp(
      {required String otpCode, required String pinId, required String dob, required String customerId,
        required String identificationNumber}) async {
    // try { 33495
      var response =
          await kycrepo.verifyKycData(otpCode: otpCode, pinId: pinId, dob:dob,
              customerId:customerId,
              identificationNumber:identificationNumber);
      print('Otp:$otpCode, pinId: $pinId');
      print(response);
      if (response['data']['status'] == 200) {
        // Handle successful OTP verification
        CustomDialog.showSuccess(
            context: Get.context!,
            message: 'Congrats! your verification is successful!',
            buttonAction: ()=>Get.to(()=> BottomNavBar()),
            buttonText: "Continue");
      } else {
        CustomDialog.showError(
            context: Get.context!,
            message: 'Verification failed',
            buttonText: "close");
      }
    // } catch (e) {
    //   // Handle error
    //   print('Error: $e');
    // }
  }
}

import 'package:mkrempire/app/helpers/hive_helper.dart';
import 'package:mkrempire/app/helpers/keys.dart';
import 'package:mkrempire/app/repository/referral_repo.dart';
import 'package:mkrempire/resources/widgets/custom_dialog.dart';
import 'package:get/get.dart';

class ReferralControllers extends GetxController {
  var isFetching = false.obs;
  late ReferralRepo referralRepo;
  var reward = 0.obs;
  var link = ''.obs;
  var referrals = [].obs;

  @override
  void onInit() {
    referralRepo = ReferralRepo();
    getReferralDetails();
    getReferralList();
    super.onInit();
  }

  Future<void> getReferralList() async {
    try {
      isFetching.value = true;
      var response = await referralRepo.getReferralList();
      print(response);
      if (response['status'] == 'success') {
        referrals.value = response['message']['referUser'];
      } else {
        CustomDialog.showError(
            context: Get.context!,
            message: 'Failed to fetch',
            buttonText: 'close');
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      isFetching.value = false;
    }
  }

  Future<void> getReferralDetails() async {
    try {
      isFetching.value = true;
      var response = await referralRepo.getReferralDetails();
      print(response);
      if (response['status'] == 'success') {
        reward.value = response['message']['refer']['freeTransfer'];
        final url =response['message']['refer']['url'].toString().split('/');
        link.value = url[url.length -1];
        HiveHelper.write(
            Keys.reward, response['message']['refer']['freeTransfer']);
        HiveHelper.write(Keys.link, url[url.length -1]);
      } else {
        CustomDialog.showError(
            context: Get.context!,
            message: 'Failed to fetch',
            buttonText: 'close');
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      isFetching.value = false;
    }
  }
}

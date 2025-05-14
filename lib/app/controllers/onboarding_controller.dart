import 'package:mkrempire/app/helpers/hive_helper.dart';
import 'package:mkrempire/app/helpers/keys.dart';
import 'package:mkrempire/routes/route_names.dart';
import 'package:get/get.dart';

class OnboardingController extends GetxController {
  final currentPage = 0.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    HiveHelper.write(Keys.onBoarded, true);
  }

  void nextPage(onboardingData) {
    if (currentPage.value < onboardingData.length - 1) {
      currentPage.value++;
    } else {
      // Navigate to the next screen (e.g., Login screen)
      Get.offAllNamed(RoutesName.loginScreen);
    }
  }

  void skip() {
    // Skip to the last page or directly to login
    Get.offAllNamed(RoutesName.loginScreen);
  }
}

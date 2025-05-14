import 'package:mkrempire/app/controllers/app_controller.dart';
import 'package:mkrempire/app/controllers/auth_controller.dart';
import 'package:mkrempire/app/controllers/history_controller.dart';
import 'package:mkrempire/app/repository/hidtory_repo.dart';
import 'package:get/get.dart';
import 'package:get/get_instance/src/bindings_interface.dart';

import '../controllers/bill_payments_controller.dart';
import '../controllers/crypto_controller.dart';
import '../controllers/profile_controller.dart';

class InitBindings implements Bindings {
  @override
  void dependencies() {
    Get.put(AuthController());
    Get.put(AppController());
    Get.put(HistoryController(historyRepo: HistoryRepo()));
    Get.put(BillPaymentsController());
    Get.put(ProfileController());
    Get.put(CryptoController());
    // Get.put(VerificationController(), permanent: true);
    //
    // Get.lazyPut<AuthController>(() => AuthController(), fenix: true);
    // Get.lazyPut<ProfileController>(() => ProfileController(), fenix: true);
    // Get.lazyPut<BottomNavController>(() => BottomNavController(), fenix: true);
    // Get.lazyPut<SupportTicketController>(() => SupportTicketController(),
    //     fenix: true);
    // Get.lazyPut<TransactionController>(() => TransactionController(),
    //     fenix: true);
    // Get.lazyPut<FundHistoryController>(() => FundHistoryController(),
    //     fenix: true);
    // Get.lazyPut<PayoutHistoryController>(() => PayoutHistoryController(),
    //     fenix: true);
    // Get.lazyPut<PayoutController>(() => PayoutController(), fenix: true);
    // Get.lazyPut<AddFundController>(() => AddFundController(), fenix: true);
    // Get.lazyPut<NotificationSettingsController>(
    //         () => NotificationSettingsController(),
    //     fenix: true);
    // Get.lazyPut<RecipientListController>(() => RecipientListController(),
    //     fenix: true);
    // Get.lazyPut<RecipientDetailsController>(() => RecipientDetailsController(),
    //     fenix: true);
    // Get.lazyPut<AddRecipientController>(() => AddRecipientController(),
    //     fenix: true);
    // Get.lazyPut<TransferHistoryController>(() => TransferHistoryController(),
    //     fenix: true);
    // Get.lazyPut<CardController>(() => CardController(), fenix: true);
    // Get.lazyPut<CardTransactionController>(() => CardTransactionController(),
    //     fenix: true);
    // Get.lazyPut<WalletController>(() => WalletController(), fenix: true);
    // Get.lazyPut<ReferController>(() => ReferController(), fenix: true);
    // Get.lazyPut<MoneyRequestController>(
    //         () => MoneyRequestController(),
    //     fenix: true);
    // Get.lazyPut<MoneyRequestListController>(() => MoneyRequestListController(),
    //     fenix: true);
  }
}

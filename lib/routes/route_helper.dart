import 'package:mkrempire/app/middlewares/guest_middleware.dart';
import 'package:mkrempire/resources/screens/billpayments/bill_payments.dart';
import 'package:mkrempire/resources/screens/billpayments/mobile_data_screen.dart';
import 'package:mkrempire/resources/screens/bitcoin/buy_sell_crypto.dart';
import 'package:mkrempire/resources/screens/bitcoin/crypto_landing.dart';
import 'package:mkrempire/resources/screens/bitcoin/deposit/withdra.dart';
import 'package:mkrempire/resources/screens/bitcoin/history.dart';
import 'package:mkrempire/resources/screens/bitcoin/swap_crypto.dart';
import 'package:mkrempire/resources/screens/finance/deposit_screen.dart';
import 'package:mkrempire/resources/screens/auth/email_otp_screen.dart';
import 'package:mkrempire/resources/screens/auth/pin_screen.dart';
import 'package:mkrempire/resources/screens/auth/set_pin_screen.dart';
import 'package:mkrempire/resources/screens/auth/signup_screen.dart';
import 'package:mkrempire/resources/screens/finance/transaction_receipt_screen.dart';
import 'package:mkrempire/resources/screens/billpayments/betting_screen.dart';
import 'package:mkrempire/resources/screens/billpayments/airtime_screen.dart';
import 'package:mkrempire/resources/screens/finance/transfer_to_mkrempire.dart';
import 'package:mkrempire/routes/route_names.dart';
import 'package:mkrempire/resources/screens/others/bottom_nav_bar.dart';
import 'package:mkrempire/resources/screens/home_screen.dart';
import 'package:mkrempire/resources/screens/auth/login_screen.dart';
import 'package:mkrempire/resources/screens/others/onboarding_screen.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:mkrempire/resources/screens/others/splash_screen.dart';

import '../resources/screens/billpayments/cable_tv_screen.dart';
import '../resources/screens/billpayments/electricity_screen.dart';
import '../resources/screens/billpayments/internet_screen.dart';
import '../resources/screens/finance/transfer_to_other_banks/transfer_to_other_bank.dart';

class RouteHelper {
  static List<GetPage> routes() => [
        GetPage(
            name: RoutesName.initial,
            page: () => const SplashScreen(),
            transition: Transition.zoom),
        GetPage(
          name: RoutesName.bottomNavBar,
          page: () => BottomNavBar(),
          transition: Transition.fade,
        ),

        GetPage(
          name: RoutesName.onbordingScreen,
          page: () => const OnboardingScreen(),
          transition: Transition.fade,
          // middlewares: [CheckStatus()], // Add middleware here
        ),
        GetPage(
          name: RoutesName.loginScreen,
          page: () => const LoginScreen(),
          transition: Transition.fade,
          // middlewares: [GuestMiddleware()],
        ),
        GetPage(
          name: RoutesName.signUpScreen,
          page: () => const SignupScreen(),
          transition: Transition.fade,
          // middlewares: [GuestMiddleware()],
        ),
        GetPage(
          name: RoutesName.setPinScreen,
          page: () => const SetPinScreen(),
          transition: Transition.fade,
          // middlewares: [CheckStatus()],
        ),
        GetPage(
            name: RoutesName.depositScreen,
            page: () => const DepositScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.transactionReceiptScreen,
            page: () => const TransactionReceiptScreen(),
            transition: Transition.fade),

        GetPage(
            name: RoutesName.pinScreen,
            page: () => const PinScreen(),
            transition: Transition.fade),

        // GetPage(
        //     name: RoutesName.forgotPassScreen,
        //     page: () => ForgotPassScreen(),
        //     transition: Transition.fade),
        // GetPage(
        //     name: RoutesName.emailSentScreen,
        //     page: () => EmailSentScreen(),
        //     transition: Transition.fade),

        GetPage(
            name: RoutesName.emailOtpScreen,
            page: () => const EmailOtpScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.homeScreen,
            page: () => const HomeScreen(),
            transition: Transition.fade),
/******
 * 
 *  BILL PAYMENT AND OTHER SERVICES
 * 
 */
        GetPage(
            name: RoutesName.bettingScreen,
            page: () => const BettingScreen(),
            transition: Transition.fadeIn),
        GetPage(
            name: RoutesName.airtimeScreen,
            page: () => const AirtimeScreen(),
            transition: Transition.fadeIn),
        GetPage(
            name: RoutesName.mobileDataScreen,
            page: () => const MobileDataScreen(),
            transition: Transition.fadeIn),
        GetPage(
            name: RoutesName.electricityScreen,
            page: () => const ElectricityScreen(),
            transition: Transition.fadeIn),
        GetPage(
            name: RoutesName.cableTvScreen,
            page: () => const CableTvScreen(),
            transition: Transition.fadeIn),
        GetPage(
            name: RoutesName.internetScreen,
            page: () => const InternetScreen(),
            transition: Transition.fadeIn),

        // FINALCIAL TRANSACTIONS
        GetPage(
            name: RoutesName.transferTomkrempire,
            page: () => const TransferTomkrempire(),
            transition: Transition.fadeIn),
        GetPage(
            name: RoutesName.transferToOtherBank,
            page: () => const TransferToOtherBank(),
            transition: Transition.fadeIn),
        GetPage(
            name: RoutesName.buyScreen,
            page: () => const BuyCryptoScreen(),
            transition: Transition.fadeIn),
        GetPage(
            name: RoutesName.sellScreen,
            page: () => const SellCryptoScreen(),
            transition: Transition.fadeIn),
        GetPage(
            name: RoutesName.billPayment,
            page: () => const BillPayments(),
            transition: Transition.fadeIn),
        // GetPage(
        //     name: RoutesName.cryptoLanding,
        //     page: () => const CryptoActionsScreen(),
        //     transition: Transition.fadeIn),
        // GetPage(
        //     name: RoutesName.cryptoSwap,
        //     page: () => const SwapCryptoScreen(),
        //     transition: Transition.fadeIn),
        // GetPage(
        //     name: RoutesName.cryptoHistory,
        //     page: () => const CryptoHistoryScreen(),
        //     transition: Transition.fadeIn),
        // GetPage(
        //     name: RoutesName.cryptoDepositWithdraw,
        //     page: () => const DepositWithdrawScreen(),
        //     transition: Transition.fadeIn),
        // // GetPage(
        //     name: RoutesName.transactionScreen,
        //     page: () => TransactionScreen(),
        //     transition: Transition.fade),
        // GetPage(
        //     name: RoutesName.moneyTransferScreen1,
        //     page: () => MoneyTransferScreen1(),
        //     transition: Transition.fade),
        // GetPage(
        //     name: RoutesName.moneyTransferScreen3,
        //     page: () => MoneyTransferScreen3(),
        //     transition: Transition.fade),
        // GetPage(
        //     name: RoutesName.moneyTransferScreen4,
        //     page: () => MoneyTransferScreen4(),
        //     transition: Transition.fade),
        // GetPage(
        //     name: RoutesName.moneyTransferScreen5,
        //     page: () => MoneyTransferScreen5(),
        //     transition: Transition.fade),
        // GetPage(
        //     name: RoutesName.moneyTransferHistoryScreen,
        //     page: () => MoneyTransferHistoryScreen(),
        //     transition: Transition.fade),
        // GetPage(
        //     name: RoutesName.moneyTransferDetailsScreen,
        //     page: () => MoneyTransferDetailsScreen(),
        //     transition: Transition.fade),
        // GetPage(
        //     name: RoutesName.recipientsScreen,
        //     page: () => RecipientsScreen(),
        //     transition: Transition.fade),
        // GetPage(
        //     name: RoutesName.addRecipientsScreen,
        //     page: () => AddRecipientsScreen(),
        //     transition: Transition.fade),
        // GetPage(
        //     name: RoutesName.recipientsDetailsScreen,
        //     page: () => RecipientsDetailsScreen(),
        //     transition: Transition.fade),
        // GetPage(
        //     name: RoutesName.cardScreen,
        //     page: () => VirtualCardScreen(),
        //     transition: Transition.fade),
        // GetPage(
        //     name: RoutesName.virtualCardFormScreen,
        //     page: () => VirtualCardFormScreen(),
        //     transition: Transition.fade),
        // GetPage(
        //     name: RoutesName.cardRequestConfirmScreen,
        //     page: () => CardRequestConfirmScreen(),
        //     transition: Transition.fade),
        // GetPage(
        //     name: RoutesName.cardTransactionScreen,
        //     page: () => CardTransactionScreen(),
        //     transition: Transition.fade),
        // GetPage(
        //     name: RoutesName.addFundScreen,
        //     page: () => AddFundScreen(),
        //     transition: Transition.fade),
        // GetPage(
        //     name: RoutesName.fundHistoryScreen,
        //     page: () => FundHistoryScreen(),
        //     transition: Transition.fade),
        // GetPage(
        //     name: RoutesName.payoutScreen,
        //     page: () => PayoutScreen(),
        //     transition: Transition.fade),
        // GetPage(
        //     name: RoutesName.payoutPreviewScreen,
        //     page: () => PayoutPreviewScreen(),
        //     transition: Transition.fade),
        // GetPage(
        //     name: RoutesName.payoutHistoryScreen,
        //     page: () => PayoutHistoryScreen(),
        //     transition: Transition.fade),
        // GetPage(
        //     name: RoutesName.flutterWaveWithdrawScreen,
        //     page: () => FlutterWaveWithdrawScreen(),
        //     transition: Transition.fade),
        // GetPage(
        //     name: RoutesName.profileSettingScreen,
        //     page: () => ProfileSettingScreen(),
        //     transition: Transition.fade),
        // GetPage(
        //     name: RoutesName.notificationPermissionScreen,
        //     page: () => NotificationPermissionScreen(),
        //     transition: Transition.fade),
        // GetPage(
        //     name: RoutesName.editProfileScreen,
        //     page: () => EditProfileScreen(),
        //     transition: Transition.fade),
        // GetPage(
        //     name: RoutesName.changePasswordScreen,
        //     page: () => ChangePasswordScreen(),
        //     transition: Transition.fade),
        // GetPage(
        //     name: RoutesName.supportTicketListScreen,
        //     page: () => SupportTicketListScreen(),
        //     transition: Transition.fade),
        // GetPage(
        //     name: RoutesName.supportTicketViewScreen,
        //     page: () => SupportTicketViewScreen(),
        //     transition: Transition.fade),
        // GetPage(
        //     name: RoutesName.createSupportTicketScreen,
        //     page: () => CreateSupportTicketScreen(),
        //     transition: Transition.fade),
        // GetPage(
        //     name: RoutesName.twoFaVerificationScreen,
        //     page: () => TwoFaVerificationScreen(),
        //     transition: Transition.fade),
        // GetPage(
        //     name: RoutesName.verificationListScreen,
        //     page: () => VerificationListScreen(),
        //     transition: Transition.fade),
        // GetPage(
        //     name: RoutesName.identityVerificationScreen,
        //     page: () => IdentityVerificationScreen(),
        //     transition: Transition.fade),
        // GetPage(
        //     name: RoutesName.notificationScreen,
        //     page: () => NotificationScreen(),
        //     transition: Transition.fade),
        // GetPage(
        //     name: RoutesName.manualPaymentScreen,
        //     page: () => ManualPaymentScreen(),
        //     transition: Transition.fade),
        // GetPage(
        //     name: RoutesName.referScreen,
        //     page: () => ReferScreen(),
        //     transition: Transition.fade),
        // GetPage(
        //     name: RoutesName.referListScreen,
        //     page: () => ReferListScreen(),
        //     transition: Transition.fade),
        // GetPage(
        //     name: RoutesName.referDetailsScreen,
        //     page: () => ReferDetailsScreen(),
        //     transition: Transition.fade),
        // GetPage(
        //     name: RoutesName.walletExchangeScreen,
        //     page: () => WalletExchangeScreen(),
        //     transition: Transition.fade),
        // GetPage(
        //     name: RoutesName.walletGetOtpScreen,
        //     page: () => WalletGetOtpScreen(),
        //     transition: Transition.fade),
        // GetPage(
        //     name: RoutesName.walletPaymentConfirmScreen,
        //     page: () => WalletPaymentConfirmScreen(),
        //     transition: Transition.fade),
        // GetPage(
        //     name: RoutesName.paymentSuccessScreen,
        //     page: () => PaymentSuccessScreen(),
        //     transition: Transition.fade),
        // GetPage(
        //     name: RoutesName.moneyRequestScreen,
        //     page: () => MoneyRequestScreen(),
        //     transition: Transition.fade),
        // GetPage(
        //     name: RoutesName.moneyRequestHistoryScreen,
        //     page: () => MoneyRequestHistoryScreen(),
        //     transition: Transition.fade),
        // GetPage(
        //     name: RoutesName.moneyRequestHistoryDetailsScreen,
        //     page: () => MoneyRequestHistoryDetailsScreen(),
        //     transition: Transition.fade),
        //
        // GetPage(
        //     name: RoutesName.deleteAccountScreen,
        //     page: () => DeleteAccountScreen(),
        //     transition: Transition.fade),
      ];
}

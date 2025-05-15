// import 'package:flutter/cupertino.dart';
// import 'package:mkrempire/app/controllers/app_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mkrempire/app/controllers/profile_controller.dart';
import 'package:mkrempire/app/helpers/hive_helper.dart';
import 'package:mkrempire/app/helpers/keys.dart';
import 'package:mkrempire/app/repository/auth_repo.dart'; // Importing the AuthRepo
import 'package:mkrempire/resources/screens/auth/forgotCode.dart';
import 'package:mkrempire/resources/screens/auth/login_screen.dart';
import 'package:mkrempire/resources/screens/auth/set_pin_screen.dart';
import 'package:mkrempire/resources/widgets/custom_dialog.dart';
import 'package:mkrempire/routes/route_names.dart';

import '../../resources/screens/auth/resetPassword.dart';
import '../../resources/widgets/custom_app_button.dart';

class AuthController extends GetxController {
  // Instance of AuthRepo
  AuthRepo authRepo = AuthRepo();

  AuthController();

  // Reactive variables
  var isLoggedIn = false.obs;
  var isVerified = false.obs;
  var isOnboarded = false.obs;
  var isLoading = false.obs; // For loading state
  var isSending = false.obs; // For loading state

  // -----------------------sign in--------------------------
  TextEditingController emailEditingController = TextEditingController();
  TextEditingController signInPassEditingController = TextEditingController();

  String singInEmailVal = "";
  String singInPassVal = "";
  String singInPin = "";

  @override
  void onInit() {
    super.onInit();
    _initializeAuthState();
    fetchAds();

    fNameController.value.addListener(() {
      update();
    });
    lNameController.value.addListener(() {
      update();
    });
    emailController.value.addListener(() {
      update();
    });
    passwordController.value.addListener(() {
      update();
    });
    confirmPasswordController.value.addListener(() {
      update();
    });

    phoneController.value.addListener(() {
      update();
    });
  }

  /// Initialize the authentication state
  Future<void> _initializeAuthState() async {
    // Retrieve token from secure storage
    final token = HiveHelper.read(Keys.token);

    // Update login status
    isLoggedIn.value = token != null;

    // Retrieve onboarding state
    final onboarded = HiveHelper.read(Keys.onBoarded);
    isOnboarded.value = onboarded != null;

    // You can add additional checks for verification if needed

    final verified = HiveHelper.read(Keys.isVerified);
    isVerified.value = verified != null;
    //true; // Mocked value, update with real logic if applicable
  }

  bool get isAnyFieldEmpty =>
      fNameController.value.text.isEmpty ||
      lNameController.value.text.isEmpty ||
      emailController.value.text.isEmpty ||
      passwordController.value.text.isEmpty ||
      confirmPasswordController.value.text.isEmpty;

  /// Log the user in by saving the token
  Future<void> login(BuildContext context) async {
    isLoading.value = true;
    try {
      print('{email: $singInEmailVal, password: $singInPassVal}}');
      final response =
          await authRepo.login(email: singInEmailVal, password: singInPassVal);

      print(response);
      if (response['status'] == 'success') {
        setOnboarded(true);
        final message = response['message'];

        HiveHelper.write(Keys.token, message['token']);
        HiveHelper.write(Keys.user, message['user']);
        HiveHelper.write(Keys.accountNumber, message['account_number']);
        HiveHelper.write(Keys.userPin, message['user_pin']);
        HiveHelper.write(Keys.firstName, message['firstname']);
        HiveHelper.write(Keys.userEmail, message['user']['email']);
        HiveHelper.write(Keys.payscribeId, message['user']['payscribe_id']);
        HiveHelper.write(Keys.hasLoginBefore, true);
        HiveHelper.write(
            Keys.accountBalance, message['user']['account_balance']);
        HiveHelper.write(Keys.profilePic, message['user']['image']);
        HiveHelper.write(Keys.country, message['user']['country'] ?? '');
        HiveHelper.write(Keys.username, message['user']['username'] ?? '');
        HiveHelper.write(Keys.lastName, message['user']['lastname'] ?? '');
        HiveHelper.write(
            Keys.languageData, message['user']['language_id'].toString() ?? '');
        HiveHelper.write(
            Keys.countryCode, message['user']['country_code'] ?? '');
        HiveHelper.write(Keys.userPhone, message['user']['phone'] ?? '');
        HiveHelper.write(
            Keys.userPhoneCode, message['user']['phone_code'] ?? '');
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          builder: (BuildContext context) {
            return DraggableScrollableSheet(
              initialChildSize: 0.3, // Default height (30% of screen)
              minChildSize: 0.2, // Minimum height (20% of screen)
              maxChildSize: 0.7, // Maximum height (70% of screen)
              expand: false,
              builder: (context, scrollController) {
                return SingleChildScrollView(
                  controller: scrollController,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.check_circle_outline,
                          size: 50,
                          color: Colors.green,
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Success',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'User Logged in successfully',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 14, color: Colors.black87),
                        ),
                        const SizedBox(height: 20),
                        Obx(() => CustomAppButton(
                              isLoading: isSending.value,
                              onTap: () => fetchDashboardData(),
                              text: 'Continue',
                            )),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );

        // Get.find<ProfileController>().profileImage.value =
        //     'https://mkrempiredigitalservice.com/assets/upload/' +
        //         message['user']['image'];
        isLoggedIn.value = true;
        print('Login successful: $response');
        print('payscribeId: ${HiveHelper.read(Keys.payscribeId)}');

        signInPassEditingController.clear();
        emailEditingController.clear();
      } else {
        String errorText = response['message'];

        CustomDialog.showWarning(
          context: context,
          message: errorText,
          buttonText: 'Cancel',
        );
        // Get.snackbar('Login Failed', response['message']);
      }
    } catch (e) {
      CustomDialog.showError(
        context: context,
        message: e.toString(),
        buttonText: 'Cancel',
      );
      // Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchDashboardData() async {
    isSending.value = true;
    try {
      final response = await authRepo.dashboard();
      print(response);
      if (response['message'] == 'Email Verification Required') {
        Get.toNamed(RoutesName.emailOtpScreen);
      } else {
        Get.offAllNamed(RoutesName.bottomNavBar);
      }
      print('$response');
      // if (response['status'] == 'success') {
      //   Get.toNamed(RoutesName.emailOtpScreen);
      // }
    } catch (e) {
      print('Error fetching dashboard data: $e');
    } finally {
      isSending.value = false;
    }
  }

  var balanceLoading = false.obs;
  final RxString balance = '0.00'.obs;
  Future<void> getBalance() async {
    // balanceLoading.value = true;
    try {
      final response = await authRepo.getBalance(
          customerId: HiveHelper.read(Keys.payscribeId));
      final double numericBalance = double.parse(response['balance']);
      balance.value =
          (numericBalance < 0 ? '0.00' : response['balance'].toString());
      print('Balance: ${balance.value}');
    } catch (e) {
      print("Error: $e");
    }
  }

  bool canProcessTransaction(amount) {
    try {
      final double currentBalance = double.parse(balance.value);
      return currentBalance >= amount;
    } catch (e) {
      debugPrint('Error checking balance: $e');
      return false;
    }
  }

  /// Log the user in by saving the token
  Future<void> loginWithPin(BuildContext context) async {
    isLoading.value = true;
    try {
      print('{email: $singInPin}');
      final response =
          await authRepo.loginWithPin(email: singInEmailVal, pin: singInPin);
      if (response['status'] == 'success') {
        final message = response['message'];
        HiveHelper.write(Keys.token, message['token']);
        HiveHelper.write(Keys.user, message['user']);
        print('HiveHelper write: user = ${message['user']}');
        HiveHelper.write(Keys.accountNumber, message['account_number']);
        HiveHelper.write(Keys.userPin, message['user_pin']);
        HiveHelper.write(Keys.firstName, message['firstname']);
        HiveHelper.write(Keys.userEmail, message['user']['email']);
        HiveHelper.write(
            Keys.accountBalance, message['user']['account_balance']);
        HiveHelper.write(Keys.payscribeId, message['user']['payscribe_id']);
        HiveHelper.write(Keys.hasLoginBefore, true);
        HiveHelper.write(Keys.profilePic, message['user']['image']);
        HiveHelper.write(Keys.country, message['user']['country'] ?? '');
        HiveHelper.write(Keys.username, message['user']['username'] ?? '');
        HiveHelper.write(Keys.lastName, message['user']['lastname'] ?? '');
        HiveHelper.write(
            Keys.languageData, message['user']['language_id'].toString() ?? '');
        HiveHelper.write(
            Keys.countryCode, message['user']['country_code'] ?? '');
        HiveHelper.write(Keys.userPhone, message['user']['phone'] ?? '');
        HiveHelper.write(
            Keys.userPhoneCode, message['user']['phone_code'] ?? '');
        HiveHelper.write(Keys.userPin, message['user_pin']);
        print('HiveHelper write: userPin = ${message['user_pin']}');
        HiveHelper.write(Keys.firstName, message['firstname']);
        print('HiveHelper write: firstName = ${message['firstname']}');
        HiveHelper.write(Keys.userEmail, message['user']['email']);
        print('HiveHelper write: userEmail = ${message['user']['email']}');
        HiveHelper.write(
            Keys.accountBalance, message['user']['account_balance']);
        print(
            'HiveHelper write: accountBalance = ${message['user']['account_balance']}');
        HiveHelper.write(Keys.payscribeId, message['user']['payscribe_id']);
        print(
            'HiveHelper write: payscribeId = ${message['user']['payscribe_id']}');
        HiveHelper.write(Keys.hasLoginBefore, true);
        print('HiveHelper write: hasLoginBefore = true');
        HiveHelper.write(Keys.profilePic, message['user']['image'] ?? '');
        print('HiveHelper write: profilePic = ${message['user']['image']}');
        HiveHelper.write(Keys.country, message['user']['country'] ?? '');
        print(
            'HiveHelper write: country = ${message['user']['country'] ?? ''}');
        HiveHelper.write(Keys.username, message['user']['username'] ?? '');
        print(
            'HiveHelper write: username = ${message['user']['username'] ?? ''}');
        HiveHelper.write(Keys.lastName, message['user']['lastname'] ?? '');
        print(
            'HiveHelper write: lastName = ${message['user']['lastname'] ?? ''}');
        HiveHelper.write(
            Keys.languageData, message['user']['language_id'].toString() ?? '');
        print(
            'HiveHelper write: languageData = ${message['user']['language_id'].toString() ?? ''}');
        HiveHelper.write(
            Keys.countryCode, message['user']['country_code'] ?? '');
        print(
            'HiveHelper write: countryCode = ${message['user']['country_code'] ?? ''}');
        HiveHelper.write(Keys.userPhone, message['user']['phone'] ?? '');
        print(
            'HiveHelper write: userPhone = ${message['user']['phone'] ?? ''}');
        HiveHelper.write(
            Keys.userPhoneCode, message['user']['phone_code'] ?? '');
        print(
            'HiveHelper write: userPhoneCode = ${message['user']['phone_code'] ?? ''}');

        Get.find<ProfileController>().profileImage.value =
            message['user']['image'] != null
                ? 'https://mkrempiredigitalservice.com/assets/upload/' +
                    message['user']['image']
                : '';

        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          builder: (BuildContext context) {
            return DraggableScrollableSheet(
              initialChildSize: 0.3, // Default height (30% of screen)
              minChildSize: 0.2, // Minimum height (20% of screen)
              maxChildSize: 0.7, // Maximum height (70% of screen)
              expand: false,
              builder: (context, scrollController) {
                return SingleChildScrollView(
                  controller: scrollController,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.check_circle_outline,
                          size: 50,
                          color: Colors.green,
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Success',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'User Logged in successfully',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 14, color: Colors.black87),
                        ),
                        const SizedBox(height: 20),
                        Obx(() => CustomAppButton(
                              isLoading: isSending.value,
                              onTap: () => fetchDashboardData(),
                              text: 'Continue',
                            )),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );

        isLoggedIn.value = true;
        print('Login successful: $response');
      } else {
        // String errorText = '';
        // response['message'].forEach((str)=>{
        //   errorText += "$str\n",
        // }).toString();
        CustomDialog.showWarning(
          context: context,
          message: '${response['message']}',
          buttonText: 'Cancel',
        );
        //  Get.snackbar('Login Failed', response['message']);
      }
    } catch (e) {
      CustomDialog.showError(
        context: context,
        message: e.toString(),
        buttonText: 'Cancel',
      );
      // Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  var oldPinController = TextEditingController().obs;
  var pinController = TextEditingController().obs;
  var isResetting = false.obs;
  Future<void> resetPin({required String pin, required String Oldpin}) async {
    try {
      if (Oldpin.isEmpty || pin.isEmpty) {
        return CustomDialog.showWarning(
            buttonText: "Close",
            context: Get.context!,
            message: "Fill all Fields");
      }
      isResetting.value = true;
      var response = await authRepo.resetPin(pin: pin);
      HiveHelper.write(Keys.userPin, pin);
      CustomDialog.showSuccess(
        context: Get.context!,
        message: response['message'],
        buttonText: 'close',
      );
      oldPinController.value.text = '';
      pinController.value.text = '';
    } catch (e) {
      // CustomDialog.showError(
      //     context: Get.context!, message: r, buttonText: 'Close');
      print('Error: $e ');
    } finally {
      isResetting.value = false;
    }
  }

  var authPinController = TextEditingController().obs;
  var confirmauthPinController = TextEditingController().obs;
  Future<void> authResetPin({required String pin}) async {
    try {
      if (pin.isEmpty) {
        return CustomDialog.showWarning(
            buttonText: "Close",
            context: Get.context!,
            message: "Fill all Fields");
      }
      isResetting.value = true;
      var response = await authRepo.resetPin(pin: pin);
      HiveHelper.write(Keys.userPin, pin);
      CustomDialog.showSuccess(
          context: Get.context!,
          message: response['message'],
          buttonText: 'close',
          buttonAction: () {
            Get.offAllNamed(RoutesName.bottomNavBar);
          });
      oldPinController.value.text = '';
      pinController.value.text = '';
    } catch (e) {
      // CustomDialog.showError(
      //     context: Get.context!, message: r, buttonText: 'Close');
      print('Error: $e ');
    } finally {
      isResetting.value = false;
    }
  }

  /// Register the user
  var fNameController = TextEditingController().obs;
  var lNameController = TextEditingController().obs;
  var emailController = TextEditingController().obs;
  var phoneController = TextEditingController().obs;
  var passwordController = TextEditingController().obs;
  var confirmPasswordController = TextEditingController().obs;
  var userNameController = TextEditingController().obs;

  String countryCode = 'NG';
  String phoneCode = '+234';
  String countryName = 'Nigeria';
  Future<void> register(
      {required String countryCode,
      required String countryName,
      required String phoneCode,
      required String email,
      required String password,
      required String phone,
      required String fname,
      required String lname}) async {
    isLoading.value = true;
    // try {
    final response = await authRepo.register(
        email: email,
        password: password,
        phone: phone,
        fname: fname,
        lname: lname,
        phoneCode: phoneCode,
        country: countryName,
        countryCode: countryCode);
    if (response['status'] == "success") {
      final message = response['user'];
      setOnboarded(true);
      HiveHelper.write(Keys.token, response['message'] ?? '');

      HiveHelper.write(Keys.accountNumber, message['account_number'] ?? '');
      HiveHelper.write(Keys.userPin, message['user_pin'] ?? '');
      HiveHelper.write(Keys.firstName, message['firstname'] ?? '');
      HiveHelper.write(Keys.userEmail, message['email'] ?? '');
      HiveHelper.write(Keys.accountBalance, message['account_balance'] ?? '');
      HiveHelper.write(Keys.payscribeId, message['payscribe_id'] ?? '');
      HiveHelper.write(Keys.country, message['country'] ?? '');
      HiveHelper.write(Keys.username, message['username'] ?? '');
      HiveHelper.write(Keys.lastName, message['lastname'] ?? '');
      HiveHelper.write(Keys.languageData, message['language_id'] ?? '');
      HiveHelper.write(Keys.countryCode, message['country_code'] ?? '');
      HiveHelper.write(Keys.userPhone, message['phone'] ?? '');
      HiveHelper.write(Keys.userPhoneCode, message['phone_code'] ?? '');
      showModalBottomSheet(
        context: Get.context!,
        isScrollControlled: true,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        builder: (BuildContext context) {
          return DraggableScrollableSheet(
            initialChildSize: 0.3, // Default height (30% of screen)
            minChildSize: 0.2, // Minimum height (20% of screen)
            maxChildSize: 0.7, // Maximum height (70% of screen)
            expand: false,
            builder: (context, scrollController) {
              return SingleChildScrollView(
                controller: scrollController,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.warning,
                        size: 50,
                        color: Colors.amber,
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Warning',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Registration Successful! Please verify your email to continue',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14, color: Colors.black87),
                      ),
                      const SizedBox(height: 20),
                      Obx(() => CustomAppButton(
                            isLoading: isSending.value,
                            onTap: () => fetchDashboardData(),
                            text: 'Verify Email',
                          )),
                    ],
                  ),
                ),
              );
            },
          );
        },
      );

      print(response);
      // HiveHelper.write(Keys.profilePic, message['image']);
      fNameController.value.clear();
      lNameController.value.clear();
      emailController.value.clear();
      phoneController.value.clear();
      passwordController.value.clear();
      confirmPasswordController.value.clear();
      userNameController.value.clear();
    } else {
      CustomDialog.showError(
          context: Get.context!,
          message: "${response['message']}",
          buttonText: "close");
    }
    // } catch (e) {
    // Get.snackbar('Error', e.toString());
    // print('Error: $e');
    // } finally {
    isLoading.value = false;
    // }
  }

//forgot Password
  TextEditingController forgotPassEmailEditingController =
      TextEditingController();
  var forgotPassEmailVal = "".obs;
  Future<void> forgotPassword(String email) async {
    isLoading.value = true;
    try {
      final response = await authRepo.forgotPassword(
        email: email,
      );
      if (response['status'] == 'success') {
        CustomDialog.showSuccess(
            context: Get.context!,
            message: response['message']['message'],
            buttonText: 'Continue',
            buttonAction: () {
              Get.to(() => Forgotcode(email: email));
            });
      } else {
        CustomDialog.showError(
            context: Get.context!,
            message: response["message"],
            buttonText: "close");
      }
    } catch (e) {
      print('Error, ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  // verify forgot Password Code

  Future<void> verifyForgotPasswordCode(String email, String code) async {
    isLoading.value = true;
    try {
      final response = await authRepo.sendForgotPasswordCode(
        email: email,
        code: code,
      );
      if (code.length != 5) {
        CustomDialog.showError(
            context: Get.context!,
            message: 'Please enter a valid 5-digit OTP.',
            buttonText: 'Back');
      }
      if (response['status'] == 'success') {
        CustomDialog.showSuccess(
            context: Get.context!,
            message: response['message'],
            buttonText: 'Continue',
            buttonAction: () {
              Get.to(() => Resetpassword(
                    email: email,
                  ));
            });
      } else {
        CustomDialog.showError(
            context: Get.context!,
            message: response["message"],
            buttonText: "close");
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// Send password reset email
  var passwordEditingController = TextEditingController();
  var confirmPasswordEditingController = TextEditingController();
  var passwordEditingVal = ''.obs;
  var confirmPasswordEditingVal = ''.obs;
  Future<void> resetPassword(String email, String password) async {
    isLoading.value = true;
    try {
      final response = await authRepo.resetPassword(
        email: email,
        password: password,
      );
      if (response['status'] == 'success') {
        CustomDialog.showSuccess(
            context: Get.context!,
            message: response['message'],
            buttonText: 'Go to Login',
            buttonAction: () {
              Get.offAll(() => const LoginScreen());
            });
      } else {
        CustomDialog.showError(
            context: Get.context!,
            message: response["message"],
            buttonText: "close");
      }
    } catch (e) {
      print('Error, ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  /// Verify email OTP
  Future<void> verifyOtp(String otp) async {
    isLoading.value = true;
    try {
      final response = await authRepo.verifyEmailOtp(otp: otp);
      if (response['status'] == 'success') {
        isVerified.value = true;
        CustomDialog.showSuccess(
            message: 'Email verified successfully.',
            buttonText: 'close',
            context: Get.context!,
            buttonAction: () {
              Get.to(() => const SetPinScreen());
            });
      } else {
        CustomDialog.showError(
            context: Get.context!, message: "", buttonText: "close");
      }
    } catch (e) {
      print('Error, ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  /// Log the user out by clearing the token and resetting the state
  Future<void> logout() async {
    HiveHelper.cleanall();
    isLoggedIn.value = false;
    isVerified.value = false;
    isOnboarded.value = false;
  }

  /// Fetch ads from the server
  var ads = [].obs;
  var isFetchingAds = false.obs;

  Future<void> fetchAds() async {
    isFetchingAds.value = true;
    try {
      final response = await authRepo.displayAds();
      if (response['status'] == 'success') {
        ads.value = response['data'] ?? [];
        print('Ads fetched successfully: $ads');
      } else {
        print('Failed to fetch ads: ${response['message']}');
      }
    } catch (e) {
      print('Error fetching ads: $e');
    } finally {
      isFetchingAds.value = false;
    }
  }

  /// Set onboarding status
  Future<void> setOnboarded(bool value) async {
    HiveHelper.write(Keys.onBoarded, value.toString());
    isOnboarded.value = value;
  }

  /// Check if the user is logged in
  bool get isUserLoggedIn => isLoggedIn.value;

  /// Check if the user is onboarded
  bool get isUserOnboarded => isOnboarded.value;

  /// Check if the user is verified
  bool get isUserVerified => isVerified.value;
}

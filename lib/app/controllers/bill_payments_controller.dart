import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mkrempire/app/controllers/navController.dart';
import 'package:mkrempire/app/models/BettingModel.dart';
import 'package:mkrempire/app/models/MobileDataModel.dart';
import 'package:mkrempire/app/models/ServicesModel.dart';
import 'package:mkrempire/app/repository/billpayment_repo.dart';
import 'package:mkrempire/resources/widgets/custom_dialog.dart';
import 'package:mkrempire/resources/widgets/custom_loading.dart';
import 'package:mkrempire/routes/route_names.dart';
import 'package:get/get.dart';

import '../../resources/widgets/custom_app_button.dart';

class BillPaymentsController extends GetxController {
  var selectedNetwork = "MTN".obs;
  late BillpaymentRepo billpaymentRepo;
  late BuildContext context;
  RxBool isLoading = false.obs;
  RxString logoUrl = ''.obs;
  RxList<Plan> plans = <Plan>[].obs;
  RxList<Services> services = <Services>[].obs;
  RxList meterTypes = ['Prepaid', 'Postpaid'].obs;
  var selectedMeterTypes = "Prepaid".obs;
  RxList<BettingModel> bettings = <BettingModel>[].obs;
  RxString betID = ''.obs;
  RxString serviceID = ''.obs;
  var bouquets = [].obs;
  var specPlan = [].obs;
  var isFetching = false.obs;
  var isPaying = false.obs;
  var selectedPackage = ''.obs;

  //======== SELECTED NETWORK CONTROLLER ========//

  //======= TEXT EDITING CONTROLLERS ========//
  TextEditingController phoneController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController airtphoneController = TextEditingController();
  // TextEditingController airtamountController = TextEditingController();

  TextEditingController electamountController = TextEditingController();
  var customerIDController = TextEditingController().obs;
  var customerNameController = TextEditingController();
  var customerName = ''.obs;
  TextEditingController meterNumberController = TextEditingController();

  void clearVars() {
    // selectedNetwork.value = "MTN";
    // phoneController = TextEditingController();
    // amountController = TextEditingController();
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    billpaymentRepo = BillpaymentRepo();
  }

  Future<void> fetchBouquets({required String serviceId}) async {
    try {
      isFetching.value = true;
      var responseData =
          await billpaymentRepo.fetchBouquets(services: serviceId);
      if (responseData['status'] == true) {
        // Ensure we're getting the correct path to bouquets
        final bouquetData = responseData['message']?["details"] ?? [];
        bouquets.assignAll(bouquetData);
        print("bouquets: $bouquets");

        // Reset selected package when bouquets change
        selectedPackage.value = '';
        amountController.text = '';
      } else {
        errorMessage.value =
            responseData['message'] ?? 'Failed to fetch bouquets';
        CustomDialog.showError(
            context: Get.context!,
            message: errorMessage.value,
            buttonText: "close");
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      isFetching.value = false;
    }
  }

  Future<void> validateSmartcardNumber({
    required String serviceId,
    required String planId,
    required String customerId,
    required String amount,
    required int month,
  }) async {
    isLoading.value = true;
    try {
      final response = await billpaymentRepo.validateSmartCardNumber(
        service: serviceId,
        planId: planId,
        month: 1,
        smartCardNumber: customerId,
      );

      if (response['status'] == true) {
        customerName.value = response['message']['details']['customer_name'];
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
                        Icon(
                          Icons.check_circle_outline,
                          size: 50,
                          color: Colors.green,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Success',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Smartcard validated successfully for ${customerName.value}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 14, color: Colors.black87),
                        ),
                        const SizedBox(height: 20),
                        Obx(() => CustomAppButton(
                              isLoading: isPaying.value,
                              onTap: () => buyCableTv(
                                  smartCardNumber: customerId,
                                  serviceId: serviceId,
                                  planId: planId,
                                  month: month,
                                  customerName: customerName.value,
                                  amount: amount),
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
      } else {
        CustomDialog.showWarning(
          context: context,
          message: '${response['description']}',
          buttonText: 'Retry',
        );
      }
    } catch (e) {
      CustomDialog.showError(
        context: context,
        message: 'Error: ${e.toString()}',
        buttonText: 'Close',
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> buyCableTv({
    required String smartCardNumber,
    required String serviceId,
    required String planId,
    required int month,
    required String customerName,
    required String amount,
  }) async {
    isPaying.value = true;
    try {
      final response = await billpaymentRepo.buyCableTv(
        smartCardNumber: smartCardNumber,
        service: serviceId,
        planId: planId,
        month: month,
        customerName: customerName,
        amount: amount,
      );
      Get.back();
      if (response['status'] == true) {
        CustomDialog.showSuccess(
          context: context,
          message: '${response['description']}',
          buttonText: 'Go Home',
          buttonAction: () => Get.offAllNamed(RoutesName.bottomNavBar),
        );
      } else if (response['status'] == false) {
        CustomDialog.showWarning(
          context: context,
          message: '${response['description']}',
          buttonText: 'Close',
          buttonAction: () {
            Get.back();
          },
        );
      } else {
        CustomDialog.showError(
          context: context,
          message: '${response['message']}',
          buttonText: 'close',
        );
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      isPaying.value = false;
    }
  }

  Future<void> purchaseAitrtime() async {
    isLoading.value = true;
    print(
        "${amountController.text} ${airtphoneController.text} ${selectedNetwork.value}");
    try {
      final response = await billpaymentRepo.purchaseAirtime(
          network: selectedNetwork.value.toLowerCase(),
          phone: airtphoneController.text,
          amount: amountController.text);

      print('airtime response: $response ');
      if (response['status'] == 'true') {
        CustomDialog.showWarning(
            context: context,
            message: '${response['description']}',
            buttonText: 'Home',
            buttonAction: () {
              Get.toNamed(RoutesName.bottomNavBar);
            });
      } else {
        CustomDialog.showWarning(
            context: context,
            message: '${response['description']}',
            buttonText: 'Home',
            buttonAction: () {
              Get.toNamed(RoutesName.bottomNavBar);
            });
      }
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;

      print('Error:$e');
      // rethrow;
    } finally {
      clearVars();
      isLoading.value = false;
    }
    //
  }

  Future<void> buyMobileData(
      {required network,
      required recipient,
      required plan,
      required amount}) async {
    isLoading.value = true;
    try {
      final response = await billpaymentRepo.buyMobileData(
          network: network, recipient: recipient, plan: plan, amount: amount);
      print('airtime response: $response ');
      if (response['status'] == true) {
        CustomDialog.showSuccess(
            context: context,
            message: '${response['description']}',
            buttonText: 'Continue',
            buttonAction: () {
              Get.toNamed(RoutesName.bottomNavBar);
            });
      } else if (response['status'] == false) {
        CustomDialog.showWarning(
            context: context,
            message: '${response['description']}',
            buttonText: 'Close',
            buttonAction: () {
              Get.back();
            });
      } else {
        CustomDialog.showError(
            context: context,
            message: '${response['message']}',
            buttonText: 'close',
            buttonAction: () {
              Get.back();
            });
      }
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;

      CustomDialog.showError(
        context: context,
        message: '${e.toString()}',
        buttonText: 'Cancel',
      );
      // rethrow;
    } finally {
      clearVars();
      isLoading.value = false;
    }
    isLoading.value = false;
    //
  }

  Future<void> dataLookUp({required String network}) async {
    isLoading.value = true;
    try {
      final response = await billpaymentRepo.dataLookUp(network: network);

      if (response['status'] == true) {
        final mobileDataModel = Mobiledatamodel.fromJson(response);
        logoUrl.value = mobileDataModel.message.details.logoUrl;
        plans.value = <Plan>[];
        plans.addAll(mobileDataModel.message.details.plans);
      } else {
        CustomDialog.showWarning(
          context: context,
          message: '${response['description']}',
          buttonText: 'Home',
          buttonAction: () {
            Get.toNamed(RoutesName.bottomNavBar);
          },
        );
        return; // Simply return instead of returning a list
      }
    } catch (e) {
      CustomDialog.showWarning(
        context: context,
        message: 'Error: ${e.toString()}',
        buttonText: 'Cancel',
      );
      rethrow; // Preserve original exception stack trace
    } finally {
      clearVars();
      isLoading.value = false;
    }
    isLoading.value = false;
  }

  var betProviders = [].obs;
  var errorMessage = ''.obs;
  Future<void> fetchServices() async {
    // Defer setting isLoading to avoid Obx rebuild inside the build phase
    Future.delayed(Duration.zero, () {
      isLoading.value = true;
    });

    try {
      final response = await billpaymentRepo.fetchServices();
      print('$response');

      if (response['status'] == true) {
        //   final Map<String, dynamic> data = json.decode(response['body']);
        final List<dynamic> betProvider = response['message']['details'];
        betProviders.value = betProvider.map((provider) {
          return ServicesModel(
            id: provider['id'],
            name: provider['title'],
            imageAsset: _getProviderImage(provider['title']),
            isActive: provider['active'] ?? true,
          );
        }).toList();
      } else {
        errorMessage.value = 'Failed to load betting providers';
        print('Error: ${response['statusCode']}');
      }
    } catch (e) {
      errorMessage.value = 'Error: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  String _getProviderImage(String providerName) {
    // Map provider names to asset images
    final Map<String, String> providerImages = {
      'NaijaBet': 'assets/images/images.png',
      'MerryBet': 'assets/images/merrybet.png',
      'MsSport': 'assets/images/msport.png',
      'Naira Bet': 'assets/images/nairabet-logo.png',
      'SupaBet': 'assets/images/supabet.png',
      'SportyBet': 'assets/images/sportybet-logo.png',
      'Paripesa': 'assets/images/paripesa.png',
      'One X Bet': 'assets/images/1xbet1.png',
      'BangBet': 'assets/images/bangbet.png',
      'MyLottoHub': 'assets/images/mylottohub.png',
      'BetKing': 'assets/images/betking.png',
      'Bet9ja': 'assets/images/bet9ja.png',
      'BetWay': 'assets/images/betway-Logo.png',
    };

    // Return default image if provider not found in mapping
    return providerImages[providerName] ?? 'assets/images/ball.png';
  }

  // Future<void> fetchServices({required String service}) async {
  //   if(isLoading.value == true){
  //     isLoading.value = false;
  //   }
  //   isLoading.value = true;
  //   try {
  //     final response = await billpaymentRepo.fetchServices(service: service);
  //
  //     if (response['status'] == true) {
  //       final servicesModel = ServicesModel.fromJson(response);
  //
  //       // Remove duplicates based on `id`
  //       final uniqueServices = {
  //         for (var service in servicesModel.details) service.id: service
  //       }.values.toList();
  //
  //       services.assignAll(uniqueServices); // Instead of addAll(), use assignAll()
  //
  //       print('Fetched Services: ${services.map((s) => s.title).toList()}');
  //     } else {
  //       CustomDialog.showWarning(
  //         context: context,
  //         message: '${response}',
  //         buttonText: 'Cancel',
  //         buttonAction: () {
  //           Get.back();
  //         },
  //       );
  //     }
  //   } catch (e) {
  //     CustomDialog.showWarning(
  //       context: context,
  //       message: 'Error: ${e.toString()}',
  //       buttonText: 'Cancel',
  //     );
  //     rethrow;
  //   } finally {
  //     isLoading.value = false;
  //   }
  //   isLoading.value = false;
  // }
  var isValidating = false.obs;
  final RxString successMessage = ''.obs;
  final RxString validationError = ''.obs;
  Timer? _debounceTimer;
  final nameController = TextEditingController().obs;
  Future<void> validateBetAccount({
    required String betId,
    required String accountNumber,
  }) async {
    try {
      if (accountNumber.length < 4) return;
      isValidating.value = true;

      validationError.value = '';
      final response = await billpaymentRepo.validateBet(betId, accountNumber);

      if (response['status'] == true) {
        customerName.value = response['message']['details']['name'];

        successMessage.value = response['description'];
      } else {
        validationError.value = 'Failed to validate account';
        nameController.value.text = '';
        print('Error: ${response['description']}');
      }
    } catch (e) {
      validationError.value = 'Error: ${e.toString()}';
    } finally {
      isValidating.value = false;
    }
  }

  void debouncedValidation(String betId, String accountNumber) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      if (accountNumber.isNotEmpty) {
        validateBetAccount(
          betId: betId,
          accountNumber: accountNumber,
        );
      } else {}
    });
  }

  // bool canProcessTransaction(amount) {
  //   try {
  //     final double currentBalance =
  //         double.parse(balanceController.balance.value);
  //     return currentBalance >= amount;
  //   } catch (e) {
  //     debugPrint('Error checking balance: $e');
  //     return false;
  //   }
  // }
  var isfundValidating = false.obs;
  Future<void> placeBet({
    required String betId,
    required String accountNumber,
    required String customer_name,
    required double amount,
  }) async {
    try {
      isfundValidating.value = true;
      validationError.value = '';

      // if (!canProcessTransaction(amount)) {
      //   errorMessage.value = 'Insufficient balance for this transaction';
      //   UsableDialog.showError(
      //       context: context,
      //       message: "Insufficient Balance for this transaction",
      //       buttonText: "close");
      //   return;
      // }

      final response = await billpaymentRepo.fundBetWallet(
          betId, accountNumber, amount, customer_name);

      if (response['status'] == true) {
        successMessage.value = response['description'];

        CustomDialog.showSuccess(
            context: context,
            message: "${successMessage.value} ",
            buttonText: "close",
            buttonAction: () {
              clearBettingFields();
              Get.back();
            });

        // await balanceController.getBalance();
      } else if (response['status'] == false) {
        validationError.value = 'Failed to place bet';
        print('Error: ${response['description']}');
        CustomDialog.showError(
            context: context,
            message: response['description'],
            buttonText: 'close',
            buttonAction: () {
              clearBettingFields();
              Get.back();
            });
      } else {
        CustomDialog.showError(
            context: context,
            message: response['message'],
            buttonText: 'close',
            buttonAction: () {
              clearBettingFields();
              Get.back();
            });
      }
    } catch (e) {
      validationError.value = 'Error: ${e.toString()}';
    } finally {
      isfundValidating.value = false;
    }
  }

  void clearBettingFields() {
    customerIDController.value.clear();
    nameController.value.clear();
    amountController.clear();
    // Reset any other relevant state
    successMessage.value = '';
    validationError.value = '';
  }

  Future<void> fetchOtherServices({required String service}) async {
    // Defer setting isLoading to avoid Obx rebuild inside the build phase
    Future.delayed(Duration.zero, () {
      isLoading.value = true;
    });

    try {
      final response =
          await billpaymentRepo.fetchotherServices(group_by: service);

      if (response['status'] == true) {
        final servicesModel = ServicesModels.fromJson(response);

        // Remove duplicates based on `id`
        final uniqueServices = {
          for (var service in servicesModel.details) service.id: service
        }.values.toList();

        services.assignAll(uniqueServices);
        print('Fetched Services: ${services.map((s) => s.title).toList()}');
      } else {
        CustomDialog.showWarning(
          context: context,
          message: '${response}',
          buttonText: 'Cancel',
          buttonAction: () {
            Get.back();
          },
        );
      }
    } catch (e) {
      CustomDialog.showWarning(
        context: context,
        message: 'Error: ${e.toString()}',
        buttonText: 'Cancel',
      );
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  var isLoadings = false.obs;
  Future<void> fetchSpectranetPlans() async {
    isLoadings.value = true;
    try {
      final response = await billpaymentRepo.fetchSpectranetPlans();

      if (response['status'] == true) {
        specPlan.value = response['message']['details'] ?? [];
      } else {
        CustomDialog.showWarning(
          context: context,
          message: '${response['description']}',
          buttonText: 'Close',
        );
      }
    } catch (e) {
      CustomDialog.showError(
        context: context,
        message: 'Error: ${e.toString()}',
        buttonText: 'Close',
      );
    } finally {
      isLoadings.value = false;
    }
  }

  Future<void> purchaseSpectranetPlan({
    required int qty,
    required String planId,
  }) async {
    isLoading.value = true;
    try {
      final response = await billpaymentRepo.purchaseSpectranetPlan(
        qty: qty,
        planId: planId,
      );

      if (response['status'] == true) {
        CustomDialog.showSuccess(
          context: context,
          message: '${response['description']}',
          buttonText: 'Continue',
          buttonAction: () {
            Get.toNamed(RoutesName.bottomNavBar);
          },
        );
      } else {
        CustomDialog.showWarning(
          context: context,
          message: '${response['description']}',
          buttonText: 'Retry',
          buttonAction: () {
            Get.back();
          },
        );
      }
    } catch (e) {
      CustomDialog.showError(
        context: context,
        message: 'Error: ${e.toString()}',
        buttonText: 'Close',
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> payElectricity() async {
    // 422984
    isLoading.value = true;
    var meterType = selectedMeterTypes.value.toLowerCase();
    var meterNumber = meterNumberController.text;
    var amount = double.parse(electamountController.text);
    var service = serviceID.value;

    try {
      final response = await billpaymentRepo.validateElectricity(
          meterNumber, meterType, amount, service);

      if (response['status'] == true) {
        customerNameController.text =
            '${response['message']['details']['customer_name']}';
        var message =
            'Customer name - ${response['message']['details']['customer_name']}\n '
            'Account number - ${response['message']['details']['account_number']}\n ';
        CustomDialog.showSuccess(
            title: "${response['description']}",
            context: context,
            message: message,
            buttonText: 'Pay Now',
            buttonAction: () async {
              isLoading.value = true;
              Get.back();
              final fundResponse = await billpaymentRepo.payElectricity(
                  meterNumber,
                  meterType,
                  amount,
                  service,
                  customerNameController.value.text);

              if (fundResponse['status'] == true) {
                isLoading.value = false;
                CustomDialog.showSuccess(
                    context: context,
                    message: 'Top Up successful ',
                    buttonText: 'Continue',
                    buttonAction: () {
                      Get.toNamed(RoutesName.bottomNavBar);
                    });
              } else if (fundResponse['status'] == false) {
                isLoading.value = false;
                CustomDialog.showWarning(
                  context: context,
                  message: '${fundResponse['description']}',
                  buttonText: 'Cancel',
                  buttonAction: () {
                    Get.back();
                  },
                );
              } else {
                isLoading.value = false;
                CustomDialog.showError(
                  context: context,
                  message: '${fundResponse['message']}',
                  buttonText: 'Cancel',
                  buttonAction: () {
                    Get.back();
                  },
                );
              }

              isLoading.value = false;
            });

        // print('Fetched bettings: ${bettings}');
      } else {
        CustomDialog.showWarning(
          context: context,
          message: '${response['description']}',
          buttonText: 'Cancel',
          buttonAction: () {
            Get.back();
          },
        );
      }
    } catch (e) {
      CustomDialog.showWarning(
        context: context,
        message: 'Error: ${e.toString()}',
        buttonText: 'Cancel',
      );
      rethrow;
    } finally {
      isLoading.value = false;
    }
    isLoading.value = false;
  }
}

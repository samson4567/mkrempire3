import 'dart:convert';

import 'package:get/get.dart';

import '../models/giftcardModels.dart';
import '../repository/giftCard_repo.dart';

class Giftcardcontroller extends GetxController {
  late GiftcardRepo giftcardRepo;
  Rx<AllGiftcardModel?> allGiftCards = Rx<AllGiftcardModel?>(null);
  Rx<GiftcarModel?> selectedGiftCard = Rx<GiftcarModel?>(null);
  Rx<AllGiftcardModel?> filteredGiftCards = Rx<AllGiftcardModel?>(null);
  var filteredCountries = [].obs;
  var isLoading = false.obs;
  var isOrdering = false.obs;
  var isGetting = false.obs;
  var countries = [].obs;
  dynamic quantity = 1.obs;
  RxDouble unitPrice = 1.00.obs;
  dynamic unitPricelength = 0.obs;
  RxInt unitPriceIndex = 0.obs;
  dynamic amountInUSD = 0.00.obs;
  dynamic amountInNGN = 0.00.obs;
  dynamic ngnRate = 1750.00.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    giftcardRepo = GiftcardRepo();
  }

  Future<void> getGiftcardCountries() async {
    try {
      isLoading.value = true;
      update();

      // The issue is here - fetchCountries() is returning a List, not a Map
      final response = await giftcardRepo.fetchCountries();

      // No need to check if response is List since we know it is
      countries.value = parseGiftCardCategories(response);
      update();
    } catch (e) {
      print("Error fetching categories: $e");
    } finally {
      isLoading.value = false;
      update();
    }
  }

  Future<void> getGiftcards({dynamic countryCode}) async {
    try {
      isGetting.value = true;

      final response =
          await giftcardRepo.fetchGiftcards(countryCode: countryCode);
      allGiftCards.value = AllGiftcardModel.fromJson(response);
      print(allGiftCards.value);
    } catch (e) {
      isGetting.value = false;
      print('Error:$e');
    }
  }

  Future<Map<String, dynamic>> OrderGiftcards(
      {required Map<String, dynamic> fields}) async {
    try {
      isOrdering.value = true;
      final response = await giftcardRepo.OrderGiftcards(json: fields);
      return response;
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to order gift cards');
    } finally {
      isOrdering.value = false;
    }
  }

  Future<Map<String, dynamic>> redeemGiftcards(
      {required Map<String, dynamic> fields}) async {
    try {
      isOrdering.value = true;
      final response = await giftcardRepo.redeemGiftcards(json: fields);
      return response;
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to order gift cards');
    } finally {
      isOrdering.value = false;
    }
  }
}

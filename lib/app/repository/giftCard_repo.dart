import 'package:mkrempire/app/repository/base_repo.dart';

import '../../routes/api_endpoints.dart';

class GiftcardRepo extends BaseRepo {
  Future<List<dynamic>> fetchCountries() async {
    try {
      const String endpoint = ApiEndpoints.getGiftcardCountriesUrl;

      var response = await getRequest(endpoint);

      print(response);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> fetchGiftcards(
      {required String countryCode}) async {
    try {
      const String endpoint = ApiEndpoints.getGiftcardsUrl;
      Map<String, dynamic> json = {
        "productName": "",
        "countryCode": countryCode,
        "productCategoryId": "",
        "size": 0,
        "page": 0,
        "inclueRange": true,
        "includeFixed": true
      };
      var response = await postWithToken(json, endpoint);

      print(response);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> OrderGiftcards(
      {required Map<String, dynamic> json}) async {
    try {
      const String endpoint = ApiEndpoints.getorderGiftCardUrl;

      var response = await postWithToken(json, endpoint);

      print(response);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> redeemGiftcards(
      {required Map<String, dynamic> json}) async {
    try {
      const String endpoint = ApiEndpoints.getRedeemCodeUrl;

      var response = await postWithToken(json, endpoint);

      print(response);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}

import 'package:mkrempire/app/repository/base_repo.dart';
import 'package:mkrempire/routes/api_endpoints.dart';

class Waecrepo extends BaseRepo {
  Future<Map<String, dynamic>> getPins() async {
    try {
      const String endpoints = ApiEndpoints.getPins;
      var response = await getRequest(endpoints);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> purchasePins({
    required int qty,
    required String id,
    required String ref,
    required String amount,
  }) async {
    try {
      String endpoint = '/payscribe/purchase-epin';
      Map<String, dynamic> json = {
        "qty": qty,
        "id": id,
        "ref": ref,
        "amount": amount
      };
      var response = await postWithToken(json, endpoint);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}

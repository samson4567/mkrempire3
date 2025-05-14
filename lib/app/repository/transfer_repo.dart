import 'package:mkrempire/app/repository/base_repo.dart';
import 'package:mkrempire/routes/api_endpoints.dart';

class TransferRepo extends BaseRepo {
  Future<Map<String, dynamic>> accountLookup(
      {required String acctNo, required String bank}) async {
    try {
      Map<String, dynamic> json = {'account': acctNo, 'bank': bank};
      const String endpoint = ApiEndpoints.accountLookup;
      var response = await postWithToken(json, endpoint);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> payOutFees({
    required String amount,
  }) async {
    try {
      Map<String, dynamic> json = {
        'amount': amount,
      };
      const String endpoint = ApiEndpoints.payoutFee;
      var response = await postWithToken(json, endpoint);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> transfer(
      {required String acctNo,
      required String bank,
      required String currencies,
      required String narration,
      required String amount}) async {
    try {
      Map<String, dynamic> json = {
        'amount': amount,
        'bank': bank,
        'account': acctNo,
        'currency': currencies,
        'narration': narration
      };
      const String endpoint = ApiEndpoints.transfer;
      var response = await postWithToken(json, endpoint);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}

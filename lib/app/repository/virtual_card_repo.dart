import 'package:mkrempire/app/repository/base_repo.dart';

import '../../routes/api_endpoints.dart';

class VirtualCardRepo extends BaseRepo {
  Future<Map<String, dynamic>> createCards(
      {required Map<String, dynamic> json}) async {
    try {
      const String endpoint = ApiEndpoints.virtualCardsUrl;

      var response = await postWithToken(json, endpoint);

      print(response);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> TopUp(
      {required Map<String, dynamic> json}) async {
    try {
      const String endpoint = '/payscribe/topup-card';

      var response = await postWithToken(json, endpoint);

      print(response);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> terminateCards(
      {required Map<String, dynamic> json}) async {
    try {
      const String endpoint = '/payscribe/terminate-card';

      var response = await postWithToken(json, endpoint);

      print(response);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> freezeCards(
      {required Map<String, dynamic> json}) async {
    try {
      const String endpoint = '/payscribe/freeze-card';

      var response = await postWithToken(json, endpoint);

      print(response);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> unfreezeCards(
      {required Map<String, dynamic> json}) async {
    try {
      const String endpoint = '/payscribe/unfreeze-card';

      var response = await postWithToken(json, endpoint);

      print(response);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> withdraw(
      {required Map<String, dynamic> json}) async {
    try {
      const String endpoint = '/payscribe/withdraw-from-card';

      var response = await postWithToken(json, endpoint);

      print(response);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> transactions(
      {required Map<String, dynamic> json}) async {
    try {
      const String endpoint = '/payscribe/card-transactions';

      var response = await postWithToken(json, endpoint);

      print(response);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}

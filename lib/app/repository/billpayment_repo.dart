import 'package:mkrempire/app/helpers/hive_helper.dart';
import 'package:mkrempire/app/helpers/keys.dart';

import '../../routes/api_endpoints.dart';
import 'base_repo.dart';

class BillpaymentRepo extends BaseRepo {
  BillpaymentRepo();

  Future<Map<String, dynamic>> purchaseAirtime({
    required String network,
    required String phone,
    required String amount,
  }) async {
    try {
      const String endpoint = ApiEndpoints.airtimeUrl;
      final Map<String, dynamic> body = {
        "network": network,
        "amount": amount,
        "recipient": phone,
        "ported": false
      };
      print(body);

      final response = await postWithToken(body, endpoint);

      print(response);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> buyMobileData({
    required String network,
    required String recipient,
    required String plan,
    required String amount,
  }) async {
    try {
      const String endpoint = ApiEndpoints.buyMobileDataUrl;
      final Map<String, dynamic> body = {
        "plan": plan,
        "recipient": recipient,
        "network": network,
        "amount": amount,
      };
      print(body);

      final response = await postWithToken(body, endpoint);

      print(response);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> dataLookUp({
    required String network,
  }) async {
    try {
      const String endpoint = ApiEndpoints.mobileDataLookupUrl;
      print(endpoint);
      final Map<String, dynamic> body = {"network": network};
      print(body);

      final response = await postWithToken(body, endpoint);

      print(response);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> fetchServices() async {
    try {
      const String endpoint = ApiEndpoints.fetchBettingServiceProvidersUrl;

      final response = await getRequest(endpoint);

      print(response);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> fetchotherServices({
    required String group_by,
  }) async {
    try {
      const String endpoint = ApiEndpoints.fetchServicesUrl;
      Map<String, dynamic> body = {"group_by": group_by};

      final response = await getRequestWithParam(body, endpoint);

      print(response);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> validateBet(betID, customerID) async {
    try {
      const String endpoint = ApiEndpoints.validateBetAccountUrl;
      dynamic body = {"bet_id": betID, "customer_id": customerID};
      final response = await postWithToken(body, endpoint);
      print(response);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> validateElectricity(
      meterNumber, meterType, amount, service) async {
    try {
      const String endpoint = ApiEndpoints.validateElectricityUrl;
      dynamic body = {
        "meter_number": meterNumber,
        "meter_type": meterType,
        "amount": amount,
        "service": service
      };
      final response = await postWithToken(body, endpoint);
      print(response);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> fetchSpectranetPlans() async {
    try {
      const String endpoint = '/payscribe/spectranet-pin-plans';

      final response = await getRequest(endpoint);

      print(response);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> purchaseSpectranetPlan({
    required String planId,
    required int qty,
  }) async {
    try {
      const String endpoint = '/payscribe/purchase-spectranet-plans';
      final Map<String, dynamic> body = {"plan_id": planId, "qty": qty};
      final response = await postWithToken(body, endpoint);
      print(response);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> payElectricity(
      meterNumber, meterType, amount, service, customerName) async {
    try {
      const String endpoint = ApiEndpoints.payElectricityUrl;
      dynamic body = {
        "meter_number": meterNumber,
        "meter_type": meterType,
        "amount": amount,
        "service": service,
        "phone": "0${HiveHelper.read(Keys.user)['phone']}",
        "customer_name": customerName
      };
      final response = await postWithToken(body, endpoint);
      print(response);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> fundBetWallet(
      betID, customerID, amount, customerName) async {
    try {
      const String endpoint = ApiEndpoints.fundBetWallet;
      dynamic body = {
        "bet_id": betID,
        "customer_id": customerID,
        "customer_name": customerName,
        "amount": amount
      };
      final response = await postWithToken(body, endpoint);
      print(response);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> fetchBouquets({required String services}) async {
    try {
      String endpoint = '/payscribe/fetch-bouquents';
      var json = {"service": services};
      var response = await postWithToken(json, endpoint);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> validateSmartCardNumber({
    required String smartCardNumber,
    required String service,
    required String planId,
    required int month,
  }) async {
    try {
      const String endpoint = '/payscribe/validate-smartcardnumber';
      final Map<String, dynamic> body = {
        "service": service,
        "account": smartCardNumber,
        "month": month,
        "plan_id": planId
      };
      final response = await postWithToken(body, endpoint);
      print(response);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> buyCableTv({
    required String smartCardNumber,
    required String service,
    required String planId,
    required int month,
    required String customerName,
    required String amount,
  }) async {
    try {
      const String endpoint = '/payscribe/pay-cabletv';
      final Map<String, dynamic> body = {
        "service": service,
        "account": smartCardNumber,
        "month": month,
        "plan_id": planId,
        "email": HiveHelper.read(Keys.userEmail),
        "customer_name": customerName,
        "phone": "0${HiveHelper.read(Keys.userPhone)}",
        "amount": amount,
      };
      final response = await postWithToken(body, endpoint);
      print(response);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}

import 'package:mkrempire/app/repository/base_repo.dart';
import 'package:mkrempire/routes/api_endpoints.dart';

class Kycrepo extends BaseRepo {
  Future<Map<String, dynamic>> submitKycData({required String bvnNo}) async {
    try {
      Map<String, dynamic> json = {'type': 'bvn', 'value': bvnNo};
      const String endpoint = ApiEndpoints.kycLookupUrl;
      var response = await postWithToken(json, endpoint);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> sendOtp() async {
    try {
      const String endpoint = ApiEndpoints.sendOtpUrl;
      var response = await getRequest(endpoint);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> verifyKycData(
      {required String pinId, required String otpCode,
        required String dob, required String customerId,
        required String identificationNumber}) async {
    try {
      Map<String, dynamic> json = {
      'otp_code': otpCode,
      'pin_id': pinId,
      'dob': dob,
      'customer_id': customerId,
      'identification_number': identificationNumber,
      };
      const String endpoint = ApiEndpoints.verifyUrl;
      var response = await postWithToken(json, endpoint);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}

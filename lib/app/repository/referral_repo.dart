import 'package:mkrempire/app/repository/base_repo.dart';

class ReferralRepo extends BaseRepo {
  Future<Map<String, dynamic>> getReferralList() async {
    try {
      String endpoint = '/referral-list';
      var response = await getRequest(endpoint);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getReferralDetails() async {
    try {
      String endpoint = '/referral-details';
      var response = await getRequest(endpoint);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}

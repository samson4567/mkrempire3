import 'package:mkrempire/app/repository/base_repo.dart';

class HistoryRepo extends BaseRepo {
  Future<Map<String, dynamic>> fetchTransactions({
    required int page,
  }) async {
    try {
      final String endpoint = "/payscribe/transactions?page=$page";

      var response = await getRequest(endpoint);

      print(response);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}

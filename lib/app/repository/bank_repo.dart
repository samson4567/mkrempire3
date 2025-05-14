import 'package:mkrempire/app/repository/base_repo.dart';
import 'package:mkrempire/routes/api_endpoints.dart';
import 'package:get/get.dart';

class BanksRepo extends BaseRepo {
  Future<Map<String, dynamic>> fetchBanks() async {
    try {
      const String endpoint = ApiEndpoints.getBanks;
      var response = await getRequest(endpoint);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}

class BanksController extends GetxController {
  var _banks = [].obs;
  late BanksRepo banksRepo;

  // Getter for the banks list
  RxList get banks => _banks;

  // Loading state
  var _isLoading = false.obs;
  RxBool get isLoading => _isLoading;

  // Error handling
  String? _error;
  String? get error => _error;

  @override
  void onInit() {
    banksRepo = BanksRepo();
    fetchBanks();

    super.onInit();
  }

  // Fetch banks and map to model
  Future<void> fetchBanks() async {
    try {
      _isLoading.value = true;
      _error = null;

      final response = await banksRepo.fetchBanks();

      final List<dynamic> banks = response['bankList'];
      _banks.value = banks;
      print('banks: $_banks');
    } catch (e) {
      _error = "Error fetching banks: $e";
      print("$_error");
    } finally {
      _isLoading.value = false;
    }
  }
}

import 'package:mkrempire/app/helpers/hive_helper.dart';
import 'package:mkrempire/app/helpers/keys.dart';
import 'package:mkrempire/app/repository/base_repo.dart';
import 'package:mkrempire/routes/api_endpoints.dart';

class AuthRepo extends BaseRepo {
  AuthRepo();

  /// Login Method
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      const String endpoint = ApiEndpoints.loginUrl;
      final Map<String, dynamic> body = {
        'username': email,
        'password': password,
      };
      print(body);
      final response = await postWithoutToken(body, endpoint);

      if (response.containsKey('token')) {
        HiveHelper.write(Keys.token, response['token']);
      }

      return response;
    } catch (e) {
      rethrow;
    }
  }

  //Dashboard
  Future<Map<String, dynamic>> dashboard() async {
    try {
      const String endpoint = '/dashboard';
      var response = await getRequest(endpoint);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  /// Display Ads Method
  Future<Map<String, dynamic>> displayAds() async {
    try {
      const String endpoint = '/ads';
      final response = await getRequest(endpoint);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  /// loginWithPin Method
  Future<Map<String, dynamic>> loginWithPin({
    required String email,
    required String pin,
  }) async {
    try {
      const String endpoint = ApiEndpoints.loginWithPinUrl;
      final Map<String, dynamic> body = {
        'username': email,
        'pin': pin,
      };
      print(body);

      final response = await postWithoutToken(body, endpoint);

      if (response.containsKey('token')) {
        HiveHelper.write(Keys.token, response['token']);
      }

      print(response);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  /// Logout Method
  Future<void> logout() async {
    try {
      const String endpoint = '/auth/logout';

      await postWithToken({}, endpoint);
      HiveHelper.remove(Keys.token);
      HiveHelper.cleanall();
    } catch (e) {
      rethrow;
    }
  }

  /// Registration Method
  Future<Map<String, dynamic>> register({
    required String fname,
    required String lname,
    required String email,
    required String phoneCode,
    required String password,
    required String phone,
    required String country,
    required String countryCode,
    // required String name
  }) async {
    try {
      const String endpoint = '/register';
      final Map<String, dynamic> body = {
        "firstname": fname,
        "lastname": lname,
        "email": email,
        "password": password,
        "password_confirmation": password,
        "phone_code": phoneCode,
        "phone": phone,
        "country": country,
        "country_code": countryCode
      };

      final response = await postWithoutToken(body, endpoint);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  /// Forgot Password Method
  Future<Map<String, dynamic>> forgotPassword({
    required String email,
  }) async {
    try {
      const String endpoint = '/recovery-pass/get-email';
      final Map<String, dynamic> body = {
        'email': email,
      };

      final response = await postWithoutToken(body, endpoint);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> sendForgotPasswordCode(
      {required String email, required String code}) async {
    try {
      const String endpoint = '/recovery-pass/get-code';
      final Map<String, dynamic> body = {
        "code": code,
        'email': email,
      };

      final response = await postWithoutToken(body, endpoint);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  /// Reset Password Method
  Future<Map<String, dynamic>> resetPassword(
      {required String email, required String password}) async {
    try {
      const String endpoint = '/update-pass';
      final Map<String, dynamic> body = {
        'email': email,
        "password": password,
        "password_confirmation": password
      };

      final response = await postWithoutToken(body, endpoint);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  /// Verify Email OTP Method
  Future<Map<String, dynamic>> verifyEmailOtp({
    required String otp,
  }) async {
    try {
      const String endpoint = '/mail-verify';
      final Map<String, dynamic> body = {
        'code': otp,
      };

      final response = await postWithToken(body, endpoint);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Future<

  Future<Map<String, dynamic>> getBalance({required customerId}) async {
    try {
      const String endpoint = ApiEndpoints.getBalance;
      final Map<String, dynamic> json = {
        'customer_id': customerId,
      };

      final response = await postWithToken(json, endpoint);

      if (response.containsKey('token')) {
        HiveHelper.write(Keys.token, response['token']);
      }

      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> resetPin({required pin}) async {
    try {
      const String endpoint = ApiEndpoints.resetPin;
      final Map<String, dynamic> json = {
        'pin': pin,
      };
      var response = await postWithToken(json, endpoint);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}

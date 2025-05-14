import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'package:mkrempire/app/repository/base_repo.dart';
import 'package:get/get.dart';

import '../../routes/api_endpoints.dart';

class ProfileRepo extends BaseRepo {
  Future<Map<String, dynamic>> updatePassword(
      {required String email, required String newPass}) async {
    try {
      Map<String, dynamic> json = {
        "email": email,
        "password": newPass,
        "password_confirmation": newPass
      };
      const String endpoint = ApiEndpoints.updatePassUrl;
      var response = await postWithToken(json, endpoint);
      return response;
    } catch (e) {
      rethrow;
    }
  }



  Future<Map<String, dynamic>> getUserProfile() async {
    try {
      const String endpoint = '/profile';
      var response = await getRequest(
        endpoint
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> uploadProfileImage({
    required File imageFile,
  }) async {
    try {
      const String endpoint = '/profile-update/image';
      var response = await postMultipartWithToken(
        endpoint,
        file: imageFile,
        fileField: "image",
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> updateProfile(
      {required String fname,
      required String lname,
      // required String userName,
      required int languageId,
      required String address,
      required String phoneCode,
      required String phone,
      required String country,
      required String countryCode}) async {
    try {
      Map<String, dynamic> json = {
        "first_name": fname,
        "last_name": lname,
        // "username": userName,
        "language_id": languageId,
        "address_one": address,
        "phone_code": phoneCode,
        "phone": phone,
        "country": country,
        "country_code": countryCode
      };
      const String endpoint = '/profile-update';
      var response = await postWithToken(json, endpoint);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}

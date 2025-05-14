import 'dart:io';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mkrempire/app/helpers/hive_helper.dart';
import 'package:mkrempire/app/helpers/keys.dart';
import 'package:mkrempire/routes/api_endpoints.dart';

class BaseRepo {
  final String baseUrl = ApiEndpoints.baseUrl;

  String _getToken() {
    return HiveHelper.read(Keys.token);
  }

  Future<dynamic> postWithToken(
      Map<String, dynamic> json, String endpoint) async {
    try {
      final token = _getToken();
      if (token.isEmpty) {
        throw Exception('Authorization token not found');
      }
      print(token);
      print(jsonEncode(json));
      print('$baseUrl$endpoint');

      final response = await http.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(json),
      );
      // print("responsebody ${response.body}");

      // if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      // } else {
      //   throw Exception('Failed to post data: ${response.statusCode}');
      // }
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> postWithoutToken(
      Map<String, dynamic> json, String endpoint) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(json),
      );
      print('$baseUrl$endpoint');
      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to post data: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> getRequest(String endpoint) async {
    try {
      final token = _getToken();
      if (token.isEmpty) {
        throw Exception('Authorization token not found');
      }

      final response = await http.get(
        Uri.parse('$baseUrl$endpoint'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      print('$baseUrl$endpoint');
      // print(response.body);
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to fetch data: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> getRequestWithParam(
      Map<String, dynamic> param, String endpoint) async {
    try {
      final token = _getToken();
      if (token.isEmpty) {
        throw Exception('Authorization token not found');
      }

      final uri =
          Uri.parse('$baseUrl$endpoint').replace(queryParameters: param);
      final response = await http.get(
        uri,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to fetch data: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Add this new function to your BaseRepo class
  Future<dynamic> postMultipartWithToken(
    String endpoint, {
    Map<String, String>? fields,
    required File file,
    required String fileField,
  }) async {
    try {
      final token = _getToken();
      if (token.isEmpty) {
        throw Exception('Authorization token not found');
      }

      var uri = Uri.parse('$baseUrl$endpoint');
      var request = http.MultipartRequest('POST', uri);

      // Add authorization header
      request.headers.addAll({
        'Authorization': 'Bearer $token',
      });

      // Add text fields if provided
      if (fields != null && fields.isNotEmpty) {
        request.fields.addAll(fields);
      }

      // Add the file
      var multipartFile = await http.MultipartFile.fromPath(
        fileField, // This is the field name expected by your API (e.g., "image")
        file.path,
      );
      request.files.add(multipartFile);

      print('Sending multipart request to: $uri');

      // Send the request
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception(
            'Failed to upload file: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> deleteRequest(String endpoint) async {
    try {
      final token = _getToken();
      if (token.isEmpty) {
        throw Exception('Authorization token not found');
      }

      final response = await http.delete(
        Uri.parse('$baseUrl$endpoint'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        return jsonDecode(response.body.isNotEmpty ? response.body : '{}');
      } else {
        throw Exception('Failed to delete data: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> patchRequest(
      Map<String, dynamic> json, String endpoint) async {
    try {
      final token = _getToken();
      if (token.isEmpty) {
        throw Exception('Authorization token not found');
      }

      final response = await http.patch(
        Uri.parse('$baseUrl$endpoint'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(json),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        return jsonDecode(response.body.isNotEmpty ? response.body : '{}');
      } else {
        throw Exception('Failed to patch data: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }
}

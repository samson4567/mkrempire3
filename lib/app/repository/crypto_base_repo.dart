import 'dart:convert';

import 'package:http/http.dart' as http;

class CryptoBaseRepo {
  final String baseUrl = 'https://pro-api.coinmarketcap.com';
  final String endpoint = '/v1/cryptocurrency/listings/latest?aux=cmc_rank';

  Future<dynamic> getCryptoList() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl$endpoint'),
        headers: {
          'X-CMC_PRO_API_KEY': 'ed2088ab-eb07-43cd-87a6-ec15c41ece88',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to fetch crypto list: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }
}

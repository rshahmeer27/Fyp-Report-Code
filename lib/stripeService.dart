import 'dart:convert';

import 'package:http/http.dart' as http;

import 'constant.dart';

class StripeService {
  static const String _baseUrl = 'https://api.stripe.com/v1/';
  static const String _apiKey = secretKey;

  static Future<Map<String, dynamic>> _postRequest(
      String endpoint, Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse(_baseUrl + endpoint),
      body: data,
      headers: {
        'Authorization': 'Bearer $_apiKey',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to perform API call: ${response.body}');
    }
  }

  static Future<Map<String, dynamic>> createPayout(
      String accountId, var amount) async {
    final data = {
      'amount': amount,
      'currency': 'usd',
      'method': 'standard',
      'destination': accountId,
    };

    return _postRequest('payouts', data);
  }
}

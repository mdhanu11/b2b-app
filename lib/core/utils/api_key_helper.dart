import 'dart:convert';
import 'package:flutter/services.dart';

class ApiKeyHelper {
  static Future<String> getApiKey() async {
    try {
      final configString = await rootBundle.loadString('assets/config.json');
      final config = jsonDecode(configString) as Map<String, dynamic>;
      return config['places_api_key'] as String;
    } catch (e) {
      throw Exception("Failed to load API key: $e");
    }
  }
}

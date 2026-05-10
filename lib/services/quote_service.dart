import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/quote_model.dart';

class QuoteService {
  static const String _baseUrl = 'https://zenquotes.io/api/random';

  Future<QuoteModel> fetchRandomQuote() async {
    try {
      final response = await http
          .get(Uri.parse(_baseUrl))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final list = jsonDecode(response.body) as List<dynamic>;
        final json = list[0] as Map<String, dynamic>;
        return QuoteModel(
          content: json['q'] ?? '',
          author: json['a'] ?? 'Unknown',
        );
      } else {
        throw 'Failed to load quote';
      }
    } catch (e) {
      throw 'Could not fetch quote. Please check your connection.';
    }
  }
}
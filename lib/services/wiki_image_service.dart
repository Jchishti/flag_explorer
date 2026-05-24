import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/// Fetches thumbnail image URLs from Wikipedia's REST API.
/// Results are cached in memory for the session.
class WikiImageService {
  WikiImageService._();
  static final WikiImageService instance = WikiImageService._();

  final Map<String, String?> _cache = {};

  /// Returns a thumbnail URL for the given Wikipedia article title,
  /// or null if not found. Results are cached.
  Future<String?> getThumbnail(String articleTitle) async {
    if (_cache.containsKey(articleTitle)) return _cache[articleTitle];

    try {
      final encoded = Uri.encodeComponent(articleTitle.replaceAll(' ', '_'));
      final uri = Uri.parse(
          'https://en.wikipedia.org/api/rest_v1/page/summary/$encoded');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final thumbnail = data['thumbnail'] as Map<String, dynamic>?;
        final url = thumbnail?['source'] as String?;
        _cache[articleTitle] = url;
        return url;
      }
    } catch (e) {
      debugPrint('WikiImageService error for "$articleTitle": $e');
    }

    _cache[articleTitle] = null;
    return null;
  }
}

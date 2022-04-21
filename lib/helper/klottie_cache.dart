import 'dart:typed_data';

import 'package:http/http.dart' as http;

abstract class KLottieCache {
  static Map<String, Uint8List> _cache = {};

  static Future<void> load(List<String> urls) async {
    urls.forEach((url) async {
      var client = http.Client();
      try {
        if (!_cache.containsKey(url)) {
          var response = await client.get(Uri.parse(url));
          if (response.statusCode == 200) {
            _cache[url] = response.bodyBytes;
          }
        }
      } finally {
        client.close();
      }
    });
  }

  static Uint8List? get(String url) {
    return _cache[url];
  }
}

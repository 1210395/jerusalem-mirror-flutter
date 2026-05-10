import 'dart:convert';
import 'package:http/http.dart' as http;

class FalAiClient {
  // TODO: Replace with your own FAL key, or move behind --dart-define / a backend proxy.
  // Mirroring the bosalati pattern; this key will be visible in the APK.
  static const _apiKey =
      'e299769e-3103-43e6-ae21-bcd1b4fb8283:dac09f32773e0be9b2b1d4c1d51def91';
  static const _endpoint = 'https://fal.run/fal-ai/flux-2-pro/edit';

  static Future<String?> generateImage({
    required String imageBase64,
    required String prompt,
  }) async {
    final response = await http.post(
      Uri.parse(_endpoint),
      headers: {
        'Authorization': 'Key $_apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'image_urls': [imageBase64],
        'prompt': prompt,
        'aspect_ratio': '3:4',
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['images'] != null && data['images'].isNotEmpty) {
        return data['images'][0]['url'];
      }
    }
    throw Exception(
        'Generation failed: ${response.statusCode} ${response.body}');
  }
}

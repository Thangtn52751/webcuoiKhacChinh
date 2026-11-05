import 'dart:convert';

import 'package:http/http.dart' as http;

class InvitationApi {
  InvitationApi._();

static String get _baseUrl {
  const configuredUrl = String.fromEnvironment('API_BASE_URL');

  if (configuredUrl.isNotEmpty) {
    return configuredUrl;
  }

  if (Uri.base.host == 'localhost' ||
      Uri.base.host == '127.0.0.1') {
    return 'http://localhost:3000/api';
  }

  return '${Uri.base.origin}/api';
}
  static const slug = 'minimalism-nau-demo';
  static final _client = http.Client();

  static Uri _uri(String suffix) =>
      Uri.parse('$_baseUrl/invitations/$slug$suffix');

  static Future<Map<String, dynamic>> submitRsvp({
    required String guestName,
    required bool attending,
    required int guestCount,
    String note = '',
  }) async {
    final response = await _client
        .post(
          _uri('/rsvps'),
          headers: const {'Content-Type': 'application/json'},
          body: jsonEncode({
            'guestName': guestName,
            'attendance': attending ? 'attending' : 'not-attending',
            'guestCount': attending ? guestCount : 0,
            'note': note,
          }),
        )
        .timeout(const Duration(seconds: 10));
    return _decodeResponse(response);
  }

  static Future<List<Map<String, dynamic>>> loadGuestbook() async {
    final response = await _client
        .get(_uri('/guestbook?page=1&limit=20'))
        .timeout(const Duration(seconds: 10));
    final result = _decodeResponse(response);
    final entries = result['data'];
    if (entries is! List) return const [];
    return entries
        .whereType<Map>()
        .map((entry) => Map<String, dynamic>.from(entry))
        .toList();
  }

  static Future<List<Map<String, dynamic>>> loadFamilyMaps() async {
    final response = await _client
        .get(_uri('/map/families'))
        .timeout(const Duration(seconds: 10));
    final result = _decodeResponse(response);
    final data = result['data'];
    final locations = data is Map ? data['locations'] : null;
    if (locations is! List) return const [];
    return locations
        .whereType<Map>()
        .map((location) => Map<String, dynamic>.from(location))
        .toList();
  }

  static Future<Map<String, dynamic>> addGuestbookEntry({
    required String name,
    required String message,
  }) async {
    final response = await _client
        .post(
          _uri('/guestbook'),
          headers: const {'Content-Type': 'application/json'},
          body: jsonEncode({'name': name, 'message': message}),
        )
        .timeout(const Duration(seconds: 10));
    return _decodeResponse(response);
  }

  static Map<String, dynamic> _decodeResponse(http.Response response) {
    final dynamic decoded;
    try {
      decoded = jsonDecode(utf8.decode(response.bodyBytes));
    } on FormatException {
      throw InvitationApiException('Máy chủ trả về dữ liệu không hợp lệ.');
    }

    final body = decoded is Map
        ? Map<String, dynamic>.from(decoded)
        : <String, dynamic>{};
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw InvitationApiException(
        body['message']?.toString() ?? 'Không thể kết nối máy chủ.',
      );
    }
    return body;
  }
}

class InvitationApiException implements Exception {
  const InvitationApiException(this.message);

  final String message;

  @override
  String toString() => message;
}

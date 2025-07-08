import 'package:forty_two_planet/services/token_service.dart';
import 'package:http/http.dart' as http;
import 'package:forty_two_planet/services/logger_service.dart';

enum HttpMethod { get, post, delete }

Uri createUri({
  required String endpoint,
  Map<String, String>? queryParameters,
}) {
  const String baseUrl = "https://api.intra.42.fr/v2";
  final String queryString = queryParameters?.entries
          .map((entry) => '${entry.key}=${entry.value}')
          .join('&') ??
      '';
  final String fullUrl = queryString.isEmpty
      ? '$baseUrl$endpoint'
      : '$baseUrl$endpoint?$queryString';

  return Uri.parse(fullUrl);
}

Map<String, String> tokenHeader(String token) {
  return {
    'Authorization': 'Bearer $token',
  };
}

int getPagesNumberFromHeader(http.Response response) {
  final linkHeader = response.headers['link'];
  if (linkHeader != null) {
    final regex = RegExp(r'<[^>]+page=(\d+)[^>]+>; rel="last"');
    final match = regex.firstMatch(linkHeader);
    if (match != null) {
      return int.parse(match.group(1)!);
    } else {
      return 1;
    }
  } else {
    return 1;
  }
}

Future<http.Response> requestWithRetry(
  HttpMethod requestType,
  Uri url,
  bool isAppToken,
) async {
  int retries = 20;
  int successCode = 200;
  String? token;
  if (isAppToken) {
    token = await TokenService.getToken('app');
  } else {
    token = await TokenService.getToken('user');
  }
  if (token == null) {
    throw Exception('No token found');
  }
  Map<String, String> headers = tokenHeader(token);
  while (retries > 0) {
    http.Response response;
    switch (requestType) {
      case HttpMethod.get:
        response = await http.get(url, headers: headers);
        successCode = 200;
        break;
      case HttpMethod.post:
        response = await http.post(url, headers: headers);
        successCode = 201;
        break;
      case HttpMethod.delete:
        response = await http.delete(url, headers: headers);
        successCode = 204;
        break;
    }
    if (response.statusCode == successCode) {
      return response;
    } else if (response.statusCode == 429) {
      String retryAfterHeader = response.headers['retry-after'] ?? '1';
      int retryAfter = int.tryParse(retryAfterHeader) ?? 1;
      logger.d('Rate limit hit, retrying after $retryAfter seconds...');
      await Future.delayed(Duration(seconds: retryAfter));
      retries--;
    } else if (response.statusCode == 401) {
      logger.d(response.body);
      bool tokenRefreshed = await TokenService.checkTokens();
      if (!tokenRefreshed) {
        throw Exception('Failed to refresh token. Restart the app.');
      } else {
        token = await TokenService.getToken(isAppToken ? 'app' : 'user');
        if (token == null) {
          throw Exception('No token found');
        }
        headers = tokenHeader(token);
      }
    } else {
      throw Exception('${response.statusCode}: ${response.body}');
    }
  }

  throw Exception('Failed after 3 attempts due to rate limit');
}

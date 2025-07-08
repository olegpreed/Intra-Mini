import 'dart:convert';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:forty_two_planet/services/logger_service.dart';
import 'package:forty_two_planet/services/remote_config_service.dart';
import 'package:forty_two_planet/utils/http_utils.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

class TokenService {
  static const FlutterAppAuth appAuth = FlutterAppAuth();
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  static Future<bool> checkTokens() async {
    String? userToken = await TokenService.getToken('user');
    String? appToken = await TokenService.getToken('app');

    if (userToken != null && appToken != null) {
      bool userTokenExpired = await TokenService.isTokenExpired('user');
      bool appTokenExpired = await TokenService.isTokenExpired('app');

      if (await _refreshTokenIfExpired('user', userTokenExpired) &&
          await _refreshTokenIfExpired('app', appTokenExpired)) {
        return true;
      }
    }
    return false;
  }

  static Future<String?> getToken(String type) async {
    return await _secureStorage.read(key: '${type}_token');
  }

  static Future<bool> isTokenExpired(String type) async {
    const int bufferTime = 60; // 1 minute
    String? expiryDateString =
        await _secureStorage.read(key: '${type}_expiry_date');
    if (expiryDateString != null &&
        DateTime.parse(expiryDateString)
            .isAfter(DateTime.now().add(const Duration(seconds: bufferTime)))) {
      return false;
    }
    logger.d('$type token is expired');
    return true;
  }

  static Future<bool> _refreshTokenIfExpired(
      String tokenType, bool isExpired) async {
    if (isExpired && tokenType == 'user') {
      try {
        await TokenService.refreshUserToken();
      } catch (e) {
        logger.e('Failed to refresh user token: $e');
        await TokenService.eraseStorage();
        return false;
      }
      logger.d('$tokenType token succesfully refreshed!');
    }
    if (isExpired && tokenType == 'app') {
      bool refreshSuccess = await TokenService.requestAndSaveAppToken();
      if (!refreshSuccess) {
        await TokenService.eraseStorage();
        logger.e('Failed to refresh app token');
        return false;
      }
      logger.d('$tokenType token succesfully refreshed!');
    }
    return true;
  }

  static Future<bool> refreshUserToken() async {
    final String? refreshToken =
        await _secureStorage.read(key: 'user_refresh_token');
    final String clientId = RemoteConfigService().uid;
    final String redirectUrl = RemoteConfigService().redirectUri;
    if (refreshToken == null || clientId.isEmpty || redirectUrl.isEmpty) {
      logger.e('Missing refreshToken, clientId or redirectUrl');
      return false;
    }
    final TokenResponse result =
        await appAuth.token(TokenRequest(clientId, redirectUrl,
            serviceConfiguration: const AuthorizationServiceConfiguration(
              authorizationEndpoint: 'https://api.intra.42.fr/oauth/authorize',
              tokenEndpoint: 'https://api.intra.42.fr/oauth/token',
            ),
            refreshToken: refreshToken));
    await saveToken('user', result.accessToken!, result.refreshToken!,
        result.accessTokenExpirationDateTime!);
    return true;
  }

  static Future<bool> requestAndSaveUserToken() async {
    AuthorizationTokenResponse response =
        await appAuth.authorizeAndExchangeCode(
      AuthorizationTokenRequest(
        RemoteConfigService().uid,
        RemoteConfigService().redirectUri,
        serviceConfiguration: const AuthorizationServiceConfiguration(
          authorizationEndpoint: 'https://api.intra.42.fr/oauth/authorize',
          tokenEndpoint: 'https://api.intra.42.fr/oauth/token',
        ),
        clientSecret: RemoteConfigService().clientSecret,
        scopes: <String>['public', 'profile', 'projects'],
      ),
    );
    if (response.accessToken == null) {
      logger.e('Failed to get user token');
      return false;
    }
    await saveToken('user', response.accessToken!, response.refreshToken!,
        response.accessTokenExpirationDateTime!);
    return true;
  }

  static Future<bool> requestAndSaveAppToken() async {
    final Response response = await http
        .post(Uri.parse('https://api.intra.42.fr/oauth/token'), headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
    }, body: {
      'grant_type': 'client_credentials',
      'client_id': RemoteConfigService().uid,
      'client_secret': RemoteConfigService().clientSecret,
      'scope': 'public profile projects',
    });
    if (response.statusCode != 200) {
      logger.e('Failed to get app token');
      logger.e(response.body);
      return false;
    }
    final Map<String, dynamic> responseData = json.decode(response.body);
    await saveToken('app', responseData['access_token'], null,
        DateTime.now().add(Duration(seconds: responseData['expires_in'])));
    return true;
  }

  static Future<void> saveToken(String type, String token, String? refreshToken,
      DateTime expiryDate) async {
    await _secureStorage.write(key: '${type}_token', value: token);
    if (type == 'user') {
      await _secureStorage.write(
          key: '${type}_refresh_token', value: refreshToken);
    }
    await _secureStorage.write(
        key: '${type}_expiry_date', value: expiryDate.toIso8601String());
  }

  static Future<void> eraseStorage() async {
    await _secureStorage.deleteAll();
  }

  static void printAllStorage() async {
    final Map<String, String> storage = await _secureStorage.readAll();
    logger.d(storage);
  }

  static void getTokenInfo(String type) async {
    final String? accessToken = await getToken(type);
    if (accessToken == null) {
      logger.e('No $type token found');
      return;
    }
    final Response response = await requestWithRetry(HttpMethod.get,
        Uri.parse('https://api.intra.42.fr/oauth/token/info'), type == 'app');
    logger.d(response.body);
  }
}

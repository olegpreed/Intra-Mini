import 'package:firebase_remote_config/firebase_remote_config.dart';

class RemoteConfigService {
  static final RemoteConfigService _instance = RemoteConfigService._internal();
  factory RemoteConfigService() => _instance;
  RemoteConfigService._internal();

  final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;

  Future<void> init() async {
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 10),
      minimumFetchInterval: const Duration(minutes: 5),
    ));

    await remoteConfig.fetchAndActivate();
  }

  String get uid => remoteConfig.getString('CLIENT_ID');
  String get clientSecret => remoteConfig.getString('CLIENT_SECRET');
  String get redirectUri => remoteConfig.getString('REDIRECT_URI');

  Future<void> refreshClientSecret() async {
    await remoteConfig.fetchAndActivate();
  }
}

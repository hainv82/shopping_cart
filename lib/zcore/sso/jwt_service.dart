import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'jwt_default_config.dart';

class JwtService {
  Dio _apiClient;

  static late JwtService _instance;

  JwtDefaultConfig _jwtDefaultConfig;
  SharedPreferences _storageClient;

  factory JwtService(JwtDefaultConfig config, SharedPreferences storage) {
    _instance = JwtService._internal(config, storage, Dio());
    return _instance;
  }
  JwtService._internal(
      this._jwtDefaultConfig, this._storageClient, this._apiClient);

  /// The value this wraps.
  static JwtService get instance => _instance;

  static JwtDefaultConfig get jwtDefaultConfig => _instance._jwtDefaultConfig;
  static SharedPreferences get storageClient => _instance._storageClient;
  static Dio get apiClient => _instance._apiClient;

  static Future<String?> get getToken async =>
      storageClient.getString(jwtDefaultConfig.storageTokenKeyName);

  Future<String?> get getRefreshToken async =>
      storageClient.getString(jwtDefaultConfig.storageRefreshTokenKeyName);

  Future<bool> setToken(String accessToken) async => await storageClient
      .setString(jwtDefaultConfig.storageTokenKeyName, accessToken);

  Future<bool> cleanToken() =>
      storageClient.remove(jwtDefaultConfig.storageTokenKeyName);

  Future<bool> cleanRefreshToken() =>
      storageClient.remove(jwtDefaultConfig.storageRefreshTokenKeyName);

  Future<bool> setRefreshToken(String refreshToken) async => await storageClient
      .setString(jwtDefaultConfig.storageRefreshTokenKeyName, refreshToken);

  static dynamic login(String username, String password) async {
    var formData = FormData.fromMap({
      'client_id': jwtDefaultConfig.clientId,
      'client_secret': jwtDefaultConfig.clientSecret,
      'scope': jwtDefaultConfig.scope,
      'grant_type': jwtDefaultConfig.grantType,
      'username': username,
      'password': password,
    });
    apiClient.interceptors.clear();
    var response = await apiClient.post(
        '${jwtDefaultConfig.baseIdentity}${jwtDefaultConfig.loginEndpoint}',
        data: formData);
    await instance.cacheToken(response);
    return response.data;
  }

  static dynamic refreshToken() async {
    var refreshToken = await instance.getRefreshToken;
    var formData = FormData.fromMap({
      'client_id': jwtDefaultConfig.clientId,
      'client_secret': jwtDefaultConfig.clientSecret,
      'grant_type': 'refresh_token',
      'refresh_token': refreshToken ?? ''
    });
    apiClient.interceptors.clear();
    var response = await apiClient.post(
        '${jwtDefaultConfig.baseIdentity}${jwtDefaultConfig.refreshEndpoint}',
        data: formData);
    await instance.cacheToken(response);
    return response.data;
  }

  static dynamic userInfo() async {
    var token = await getToken;
    apiClient.interceptors.clear();
    apiClient.interceptors.add(
      InterceptorsWrapper(
        onRequest: (request, handler) {
          if (token != null && token != '') {
            request.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(request);
        },
      ),
    );
    var response = await apiClient.post(
        '${jwtDefaultConfig.baseIdentity}${jwtDefaultConfig.userInfoEndpoint}');
    await instance.cacheToken(response);
    return response.data;
  }

  static dynamic logout() async {
    await instance.cleanCache();
    return true;
  }

  Future<bool> cacheToken(dynamic response) async {
    Map<String, dynamic> responseJson = json.decode(response.toString());
    if (responseJson.isNotEmpty &&
        responseJson.containsKey(jwtDefaultConfig.apiTokenKeyName) &&
        responseJson.containsKey(jwtDefaultConfig.apiRefreshTokenKeyName)) {
      await setToken(responseJson[jwtDefaultConfig.apiTokenKeyName]);
      await setRefreshToken(
          responseJson[jwtDefaultConfig.apiRefreshTokenKeyName]);
      return true;
    }
    return false;
  }

  Future<bool> cleanCache() async {
    await cleanToken();
    await cleanRefreshToken();
    return true;
  }
}

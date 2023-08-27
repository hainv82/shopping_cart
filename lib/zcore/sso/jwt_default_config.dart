class JwtDefaultConfig {
  final String _loginEndpoint;
  final String _refreshEndpoint;
  final String _userInfoEndpoint;
  final String _tokenType;
  final String _storageTokenKeyName;
  final String _storageRefreshTokenKeyName;
  final String _apiTokenKeyName;
  final String _apiRefreshTokenKeyName;

  final String _baseIdentity;
  final String _clientId;
  final String _clientSecret;
  final String _scope;
  final String _grantType;

  static late JwtDefaultConfig _instance;

  factory JwtDefaultConfig({
    required String baseIdentity,
    required String clientId,
    required String clientSecret,
    required String scope,
    required String grantType,
    loginEndpoint = '/connect/token',
    refreshEndpoint = '/connect/token',
    userInfoEndpoint = '/connect/userinfo',
    tokenType = 'Bearer',
    storageTokenKeyName = 'accessToken',
    storageRefreshTokenKeyName = 'refreshToken',
    apiTokenKeyName = 'access_token',
    apiRefreshTokenKeyName = 'refresh_token',
  }) {
    _instance = JwtDefaultConfig._internal(
      baseIdentity,
      clientId,
      clientSecret,
      scope,
      grantType,
      loginEndpoint,
      refreshEndpoint,
      userInfoEndpoint,
      tokenType,
      storageTokenKeyName,
      storageRefreshTokenKeyName,
      apiTokenKeyName,
      apiRefreshTokenKeyName,
    );
    return _instance;
  }

  JwtDefaultConfig._internal(
      this._baseIdentity,
      this._clientId,
      this._clientSecret,
      this._scope,
      this._grantType,
      this._loginEndpoint,
      this._refreshEndpoint,
      this._userInfoEndpoint,
      this._tokenType,
      this._storageTokenKeyName,
      this._storageRefreshTokenKeyName,
      this._apiTokenKeyName,
      this._apiRefreshTokenKeyName,
      );

  static JwtDefaultConfig get instance => _instance;

  String get baseIdentity => _instance._baseIdentity;

  String get loginEndpoint => _instance._loginEndpoint;

  String get refreshEndpoint => _instance._refreshEndpoint;

  String get userInfoEndpoint => _instance._userInfoEndpoint;

  String get tokenType => _instance._tokenType;

  String get storageTokenKeyName => _instance._storageTokenKeyName;

  String get storageRefreshTokenKeyName =>
      _instance._storageRefreshTokenKeyName;

  String get clientId => _instance._clientId;

  String get clientSecret => _instance._clientSecret;

  String get scope => _instance._scope;

  String get grantType => _instance._grantType;

  String get apiTokenKeyName => _instance._apiTokenKeyName;

  String get apiRefreshTokenKeyName => _instance._apiRefreshTokenKeyName;
}

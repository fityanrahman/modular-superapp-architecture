enum AppEnvironment { development, production }

class AppConfig {
  const AppConfig({
    required this.appName,
    required this.environment,
    this.apiBaseUrl = 'https://api.superapp.example',
    this.enableAnalytics = true,
  });

  const AppConfig.development({String appName = 'SuperApp'})
      : this(
          appName: appName,
          environment: AppEnvironment.development,
          enableAnalytics: false,
        );

  const AppConfig.production({String appName = 'SuperApp'})
      : this(
          appName: appName,
          environment: AppEnvironment.production,
        );

  final String appName;
  final AppEnvironment environment;
  final String apiBaseUrl;
  final bool enableAnalytics;

  bool get isProduction => environment == AppEnvironment.production;
}

import 'package:contracts/contracts.dart';
import 'package:core/core.dart';
import 'package:food/food.dart';
import 'package:ride/ride.dart';
import 'package:wallet/wallet.dart';

class AppCompositionRoot {
  AppCompositionRoot({
    AppConfig? config,
    ApiClient? apiClient,
    AnalyticsService? analytics,
    AppLogger? logger,
  }) : config = config ?? const AppConfig.production() {
    final AppLogger appLogger = logger ?? AppLogger(tag: this.config.appName);
    this.logger = appLogger;
    this.analytics = analytics ??
        (this.config.enableAnalytics
            ? ConsoleAnalyticsService(logger: appLogger)
            : const NoopAnalyticsService());
    this.apiClient = apiClient ?? FakeApiClient(routes: _mockRoutes());
    authService = InMemoryAuthService();

    final WalletModule wallet = WalletModule(
      apiClient: this.apiClient,
      analytics: this.analytics,
      logger: AppLogger(tag: 'Wallet'),
    );
    final FoodModule food = FoodModule(
      apiClient: this.apiClient,
      paymentLauncher: wallet.paymentLauncher,
      analytics: this.analytics,
      logger: AppLogger(tag: 'Food'),
    );
    final RideModule ride = RideModule(
      apiClient: this.apiClient,
      analytics: this.analytics,
      logger: AppLogger(tag: 'Ride'),
    );

    modules = List<ModuleLauncher>.unmodifiable(<ModuleLauncher>[
      ride,
      food,
      wallet,
    ]);

    this.logger.info('Composed ${modules.length} modules');
  }

  final AppConfig config;
  late final AppLogger logger;
  late final AnalyticsService analytics;
  late final ApiClient apiClient;
  late final AuthService authService;
  late final List<ModuleLauncher> modules;

  static Map<String, Object?> _mockRoutes() => <String, Object?>{
        ...rideMockRoutes(),
        ...foodMockRoutes(),
        ...walletMockRoutes(),
      };
}

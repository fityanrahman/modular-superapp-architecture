import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ride/ride.dart';
import 'package:ride_dev_app/main.dart';

void main() {
  testWidgets('ride dev app hosts the Ride module', (WidgetTester tester) async {
    final RideModule rideModule = RideModule(
      apiClient: FakeApiClient(
        routes: rideMockRoutes(),
        latency: Duration.zero,
      ),
    );

    await tester.pumpWidget(RideDevApp(rideModule: rideModule));
    await tester.pumpAndSettle();

    expect(find.text('Ride'), findsWidgets);
  });
}

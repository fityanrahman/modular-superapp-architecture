import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('PrimaryButton renders its label and reacts to taps',
      (WidgetTester tester) async {
    var tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PrimaryButton(
            label: 'Pay now',
            onPressed: () => tapped = true,
          ),
        ),
      ),
    );

    expect(find.text('Pay now'), findsOneWidget);

    await tester.tap(find.text('Pay now'));
    expect(tapped, isTrue);
  });

  test('AppTheme exposes the brand primary color', () {
    final theme = AppTheme.light();

    expect(theme.colorScheme.primary, AppColors.primary);
  });
}

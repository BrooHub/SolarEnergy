import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tkw/app.dart';

import 'package:tkw/screens/map_page.dart';

void main() {
  testWidgets('Solar Enerji Keşifçisi test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const SolarEnergyExplorer());

    // Verify initial state
    expect(find.text('Solar Enerji Keşifçisi'), findsOneWidget);
    expect(find.byType(AppBar), findsOneWidget);

    // Verify map page is shown initially
    expect(find.byType(MapPage), findsOneWidget);
  });
}

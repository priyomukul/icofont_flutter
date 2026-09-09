// Verifies the example app builds and renders icons from the package.

import 'package:flutter_test/flutter_test.dart';
import 'package:icofont_flutter/icofont_flutter.dart';

import 'package:example/main.dart';

void main() {
  testWidgets('renders IcoFont icons', (WidgetTester tester) async {
    await tester.pumpWidget(IcoFontExampleApp());

    expect(find.text('IcoFont Flutter Example'), findsOneWidget);
    expect(find.byIcon(IcoFontIcons.abacus), findsOneWidget);
    expect(find.byIcon(IcoFontIcons.abacusAlt), findsOneWidget);
  });

  testWidgets('tapping an icon rebuilds it', (WidgetTester tester) async {
    await tester.pumpWidget(IcoFontExampleApp());

    await tester.tap(find.byIcon(IcoFontIcons.abacus));
    await tester.pump();

    expect(find.byIcon(IcoFontIcons.abacus), findsOneWidget);
  });
}

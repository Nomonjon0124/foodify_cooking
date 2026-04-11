import 'package:flutter_test/flutter_test.dart';

import 'package:foodify_cooking/app/app.dart';
import 'package:foodify_cooking/core/di/injection_container.dart';

void main() {
  setUpAll(() async {
    await configureDependencies();
  });

  tearDownAll(() async {
    await getIt.reset();
  });

  testWidgets('App boots and shows guest shell', (tester) async {
    await tester.pumpWidget(const App());
    await tester.pump(const Duration(milliseconds: 1900));
    await tester.pumpAndSettle();

    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Recipes'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
  });
}

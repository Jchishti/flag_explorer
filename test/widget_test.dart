import 'package:flutter_test/flutter_test.dart';

import 'package:flag_explorer/main.dart';

void main() {
  testWidgets('App renders home screen', (WidgetTester tester) async {
    await tester.pumpWidget(const FlagExplorerApp());
    expect(find.text('Flag Explorer'), findsOneWidget);
    expect(find.text('Explore'), findsOneWidget);
  });
}

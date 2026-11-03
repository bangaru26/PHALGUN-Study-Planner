import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fintech_kalp/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('Fintech Kalp launches with dashboard and navigation', (tester) async {
    await tester.pumpWidget(const FintechKalpApp());
    await tester.pumpAndSettle();

    expect(find.text('FINTECH KALP'), findsOneWidget);
    expect(find.text('LEARN FINANCE. BUILD WHAT MATTERS.'), findsOneWidget);
    expect(find.text('Your learning pathways'), findsOneWidget);

    // The compact navigation should expose the core learner sections.
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Learn'), findsOneWidget);
    expect(find.text('Practice'), findsOneWidget);
    expect(find.text('Capstone'), findsOneWidget);
  });

  testWidgets('Curriculum navigation opens the curriculum explorer', (tester) async {
    await tester.pumpWidget(const FintechKalpApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Learn'));
    await tester.pumpAndSettle();

    expect(find.text('Curriculum explorer'), findsOneWidget);
    expect(find.text('Learning path'), findsOneWidget);
  });
}

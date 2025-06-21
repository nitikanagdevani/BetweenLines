import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:between_lines/screens/login.dart'; // 🔁 Update path if needed

void main() {
  group('🧪 LoginScreen Widget Tests', () {

    testWidgets('Test 1: Shows error on empty fields', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: LoginPage()));

      await tester.tap(find.text('Login'));
      await tester.pump(); // Let UI rebuild

      expect(find.textContaining('Please'), findsWidgets); // Assumes error starts with "Please..."
    });

    testWidgets('Test 2: Input fields accept user text', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: LoginPage()));

      final emailField = find.byType(TextField).at(0);
      final passwordField = find.byType(TextField).at(1);

      await tester.enterText(emailField, 'test@domain.com');
      await tester.enterText(passwordField, 'securepass');

      expect(find.text('test@domain.com'), findsOneWidget);
      expect(find.text('securepass'), findsOneWidget);
    });

    testWidgets('Test 3: Tapping Sign up navigates to Signup page', (WidgetTester tester) async {
      bool navigated = false;

      await tester.pumpWidget(MaterialApp(
        home: const LoginPage(),
        routes: {
          '/signup': (context) {
            navigated = true;
            return const Scaffold(body: Text('Signup Screen'));
          },
        },
      ));

      await tester.tap(find.text("Don't have an account? Sign up."));
      await tester.pumpAndSettle();

      expect(find.text('Signup Screen'), findsOneWidget);
      expect(navigated, isTrue);
    });

  });
}

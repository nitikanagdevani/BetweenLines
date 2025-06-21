import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:between_lines/screens/homepage.dart'; // ✅ Correct import path
import 'package:between_lines/screens/profile.dart';     // ✅ For ProfilePage
import 'package:between_lines/screens/Library.dart';     // ✅ For LibraryPage

import 'package:between_lines/screens/News.dart';       // ✅ For NewsPage

void main() {
  group('🧪 HomePage Widget Tests', () {
    testWidgets('Test 1: Home UI elements render properly', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: HomePage()));

      expect(find.text('Home'), findsAtLeastNWidgets(1));
      expect(find.text('Featured Book'), findsOneWidget);
      expect(find.text('Trending Books'), findsOneWidget);
      for (int i = 0; i < 5; i++) {
        expect(find.text('Book Title $i'), findsOneWidget);
      }
    });

   // testWidgets('Test 2: Tapping Profile tab shows ProfilePage', (WidgetTester tester) async {
    //  await tester.pumpWidget(MaterialApp(home: HomePage()));

//      await tester.tap(find.byIcon(Icons.person));
      //await tester.pumpAndSettle();

  //    expect(find.byType(ProfilePage), findsOneWidget);
    //});

    testWidgets('Test 3: Tapping Library tab shows LibraryPage', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: HomePage()));

      await tester.tap(find.byIcon(Icons.library_books));
      await tester.pumpAndSettle();

      expect(find.byType(LibraryPage), findsOneWidget);
    });
  });
}

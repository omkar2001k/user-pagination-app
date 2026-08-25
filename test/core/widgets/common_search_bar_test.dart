import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:user_pagination_app/core/widgets/common_search_bar.dart';

void main() {
  group('CommonSearchBar Widget Tests', () {
    testWidgets('should render text field and handle user text entry and clear action', (WidgetTester tester) async {
      String changedText = '';
      bool clearTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CommonSearchBar(
              onChanged: (val) {
                changedText = val;
              },
              onClear: () {
                clearTapped = true;
              },
            ),
          ),
        ),
      );

      expect(find.byKey(const Key('search_bar_text_field')), findsOneWidget);
      expect(find.text('Search by name...'), findsOneWidget);

      // Enter text
      await tester.enterText(find.byKey(const Key('search_bar_text_field')), 'George');
      await tester.pump();

      expect(changedText, 'George');
      expect(find.byKey(const Key('search_bar_clear_button')), findsOneWidget);

      // Tap clear button
      await tester.tap(find.byKey(const Key('search_bar_clear_button')));
      await tester.pump();

      expect(changedText, '');
      expect(clearTapped, true);
    });

    testWidgets('should update text controller when initialValue changes and text is empty', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CommonSearchBar(
              initialValue: '',
              onChanged: (_) {},
            ),
          ),
        ),
      );

      expect(find.text(''), findsWidgets);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CommonSearchBar(
              initialValue: 'New Value',
              onChanged: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('New Value'), findsOneWidget);
    });
  });
}

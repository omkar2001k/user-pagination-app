import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:user_pagination_app/core/widgets/common_empty_widget.dart';

void main() {
  testWidgets('CommonEmptyWidget renders default title and message', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: CommonEmptyWidget(),
        ),
      ),
    );

    expect(find.text('No Users Found'), findsOneWidget);
    expect(find.text('Try searching with a different name or keyword.'), findsOneWidget);
    expect(find.byIcon(Icons.search_off_rounded), findsOneWidget);
  });

  testWidgets('CommonEmptyWidget renders custom title, message, and icon', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: CommonEmptyWidget(
            title: 'Custom Empty Title',
            message: 'Custom empty description message.',
            icon: Icons.inbox_outlined,
          ),
        ),
      ),
    );

    expect(find.text('Custom Empty Title'), findsOneWidget);
    expect(find.text('Custom empty description message.'), findsOneWidget);
    expect(find.byIcon(Icons.inbox_outlined), findsOneWidget);
  });
}

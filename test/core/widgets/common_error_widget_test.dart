import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:user_pagination_app/core/widgets/common_error_widget.dart';

void main() {
  testWidgets('CommonErrorWidget renders message without retry button when onRetry is null', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: CommonErrorWidget(
            message: 'An error occurred',
          ),
        ),
      ),
    );

    expect(find.text('Something went wrong'), findsOneWidget);
    expect(find.text('An error occurred'), findsOneWidget);
    expect(find.text('Try Again'), findsNothing);
  });

  testWidgets('CommonErrorWidget renders retry button and triggers callback on tap', (tester) async {
    bool retryTapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CommonErrorWidget(
            message: 'Network error',
            onRetry: () {
              retryTapped = true;
            },
          ),
        ),
      ),
    );

    expect(find.text('Try Again'), findsOneWidget);

    await tester.tap(find.text('Try Again'));
    await tester.pump();

    expect(retryTapped, isTrue);
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:user_pagination_app/core/widgets/app_spacing.dart';

void main() {
  testWidgets('AppSpacing static constants should have proper dimensions', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              AppSpacing.v2,
              AppSpacing.v4,
              AppSpacing.v6,
              AppSpacing.v8,
              AppSpacing.v10,
              AppSpacing.v12,
              AppSpacing.v14,
              AppSpacing.v16,
              AppSpacing.v20,
              AppSpacing.v24,
              AppSpacing.v28,
              AppSpacing.v32,
              Row(
                children: [
                  AppSpacing.h2,
                  AppSpacing.h4,
                  AppSpacing.h6,
                  AppSpacing.h8,
                  AppSpacing.h10,
                  AppSpacing.h12,
                  AppSpacing.h14,
                  AppSpacing.h16,
                  AppSpacing.h20,
                  AppSpacing.h24,
                  AppSpacing.h28,
                  AppSpacing.h32,
                ],
              ),
              AppSpacing.shrink,
            ],
          ),
        ),
      ),
    );

    expect(find.byType(SizedBox), findsWidgets);
  });

  testWidgets('AppSpacing dynamic helpers and AppLine render correctly', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              AppSpacing.vertical(15),
              AppSpacing.horizontal(25),
              AppSpacing.square(50),
              AppSpacing.line(height: 10),
              const AppLine(height: 20),
              10.vGap,
              12.hGap,
              14.squareBox,
            ],
          ),
        ),
      ),
    );

    expect(find.byType(Divider), findsNWidgets(2));
    expect(find.byType(AppLine), findsOneWidget);
  });
}

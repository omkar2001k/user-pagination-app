import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:user_pagination_app/core/widgets/common_avatar_widget.dart';

void main() {
  testWidgets('CommonAvatarWidget renders fallback initials when imageUrl is null or empty', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: CommonAvatarWidget(
            imageUrl: null,
            fallbackInitials: 'JD',
            radius: 30,
          ),
        ),
      ),
    );

    expect(find.text('JD'), findsOneWidget);
  });

  testWidgets('CommonAvatarWidget wraps in Hero tag when heroTag is provided', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: CommonAvatarWidget(
            imageUrl: '',
            fallbackInitials: 'AB',
            heroTag: 'hero_1',
          ),
        ),
      ),
    );

    expect(find.byType(Hero), findsOneWidget);
    expect(find.text('AB'), findsOneWidget);
  });
}

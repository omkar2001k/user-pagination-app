import 'package:flutter/material.dart';
import 'package:user_pagination_app/core/widgets/app_spacing.dart';

class CommonEmptyWidget extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;

  const CommonEmptyWidget({
    super.key,
    this.title = 'No Users Found',
    this.message = 'Try searching with a different name or keyword.',
    this.icon = Icons.search_off_rounded,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: theme.primaryColor.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 56,
                color: theme.primaryColor,
              ),
            ),
            AppSpacing.v20,
            Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            AppSpacing.v8,
            Text(
              message,
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

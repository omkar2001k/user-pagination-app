import 'package:flutter/material.dart';
import 'package:user_pagination_app/core/widgets/app_spacing.dart';
import 'package:user_pagination_app/core/widgets/common_avatar_widget.dart';
import 'package:user_pagination_app/modules/user/domain/entities/user_entity.dart';

class UserCardWidget extends StatelessWidget {
  final UserEntity user;
  final VoidCallback onTap;

  const UserCardWidget({
    super.key,
    required this.user,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        splashColor: theme.primaryColor.withValues(alpha: 0.08),
        highlightColor: theme.primaryColor.withValues(alpha: 0.04),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              CommonAvatarWidget(
                imageUrl: user.avatar,
                fallbackInitials: user.initials,
                radius: 28,
                heroTag: 'avatar_${user.id}',
              ),
              AppSpacing.h14,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            user.fullName,
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontSize: 16,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: theme.primaryColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '#${user.id}',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: theme.primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    AppSpacing.v4,
                    Text(
                      user.email,
                      style: theme.textTheme.bodyMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              AppSpacing.h8,
              Icon(
                Icons.chevron_right_rounded,
                color: Colors.grey.shade400,
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

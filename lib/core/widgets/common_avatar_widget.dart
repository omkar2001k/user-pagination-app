import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CommonAvatarWidget extends StatelessWidget {
  final String? imageUrl;
  final String fallbackInitials;
  final double radius;
  final String? heroTag;

  const CommonAvatarWidget({
    super.key,
    required this.imageUrl,
    required this.fallbackInitials,
    this.radius = 28,
    this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = radius * 2;

    Widget avatarContent;

    if (imageUrl != null && imageUrl!.trim().isNotEmpty) {
      avatarContent = CachedNetworkImage(
        imageUrl: imageUrl!.trim(),
        width: size,
        height: size,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          width: size,
          height: size,
          color: theme.primaryColor.withValues(alpha: 0.1),
          child: const Center(
            child: SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
        ),
        errorWidget: (context, url, error) => _buildFallback(context),
      );
    } else {
      avatarContent = _buildFallback(context);
    }

    Widget containerWidget = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipOval(child: avatarContent),
    );

    if (heroTag != null && heroTag!.isNotEmpty) {
      return Hero(
        tag: heroTag!,
        child: containerWidget,
      );
    }

    return containerWidget;
  }

  Widget _buildFallback(BuildContext context) {
    const fallbackGreen = Color(0xFF10B981);
    return Container(
      color: fallbackGreen.withValues(alpha: 0.15),
      child: Center(
        child: Text(
          fallbackInitials.toUpperCase(),
          style: TextStyle(
            color: fallbackGreen,
            fontWeight: FontWeight.bold,
            fontSize: radius * 0.75,
          ),
        ),
      ),
    );
  }
}

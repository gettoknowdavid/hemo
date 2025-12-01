import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hemo/_shared/ui/theme/theme.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HAvatar extends StatelessWidget {
  const HAvatar({
    this.radius,
    this.url,
    this.placeholder = const Icon(
      PhosphorIconsRegular.user,
      color: HColors.primary,
    ),
    this.isLoading = false,
    super.key,
  });

  final double? radius;
  final String? url;
  final Widget placeholder;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final effectiveRadius = radius ?? 32.r;
    final diameter = effectiveRadius * 2;

    final backgroundColor = HColors.primary.withValues(alpha: 0.1);

    Widget child;

    if (url == null) {
      child = CircleAvatar(
        radius: radius ?? 32.r,
        backgroundColor: backgroundColor,
        child: IconTheme(
          data: const IconThemeData(color: HColors.primary),
          child: placeholder,
        ),
      );
    } else {
      child = CachedNetworkImage(
        imageUrl: url!,
        height: diameter.r,
        width: diameter.r,
        fit: BoxFit.contain,
        imageBuilder: (context, imageProvider) => CircleAvatar(
          radius: effectiveRadius,
          backgroundImage: imageProvider,
        ),
        progressIndicatorBuilder: (context, url, progress) => Skeletonizer(
          child: Skeleton.unite(
            child: CircleAvatar(
              radius: effectiveRadius,
              backgroundColor: backgroundColor,
            ),
          ),
        ),
        errorWidget: (context, url, error) => CircleAvatar(
          radius: effectiveRadius,
          backgroundColor: backgroundColor,
          child: placeholder,
        ),
      );
    }

    return Skeletonizer(
      enabled: isLoading,
      child: Skeleton.unite(
        child: child,
      ),
    );
  }
}

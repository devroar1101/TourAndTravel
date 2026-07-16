import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Gold star rating with half-star support.
class RatingStars extends StatelessWidget {
  const RatingStars(this.rating, {super.key, this.size = 15, this.color});

  final double rating;
  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final starColor = color ?? AppColors.gold;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        final icon = rating >= i + 0.75
            ? Icons.star_rounded
            : rating >= i + 0.25
                ? Icons.star_half_rounded
                : Icons.star_outline_rounded;
        return Icon(icon, size: size, color: starColor);
      }),
    );
  }
}

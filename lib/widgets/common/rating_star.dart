import 'package:flutter/material.dart';

/// Full 5-star display used on Product Detail screen
class RatingStars extends StatelessWidget {
  final double rating; // e.g. 3.0, 4.5, etc.
  final double size;   // icon size
  final bool allowHalf; // if true you can show half star (optional)

  const RatingStars({
    super.key,
    required this.rating,
    this.size = 18,
    this.allowHalf = false,
  });

  @override
  Widget build(BuildContext context) {
    // if you want half star support, use rating - floor to decide
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final pos = index + 1;
        if (!allowHalf) {
          // simple integer fill logic
          return Icon(
            index < rating.floor() ? Icons.star : Icons.star_border,
            color: Colors.amber,
            size: size,
          );
        } else {
          // half star support
          if (rating >= pos) {
            return Icon(Icons.star, color: Colors.amber, size: size);
          } else if (rating > (pos - 1) && rating < pos) {
            return Icon(Icons.star_half, color: Colors.amber, size: size);
          } else {
            return Icon(Icons.star_border, color: Colors.grey, size: size);
          }
        }
      }),
    );
  }
}

class CompactSingleStar extends StatelessWidget {
  final double rating;
  final double size;
  final Color filledColor;
  final Color halfColor;
  final Color emptyColor;

  const CompactSingleStar({
    super.key,
    required this.rating,
    this.size = 16,
    this.filledColor = Colors.amber,
    this.halfColor = Colors.amber,
    this.emptyColor = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    IconData icon;

    if (rating < 1) {
      icon = Icons.star_border;              // empty
    } else if (rating >= 1 && rating <= 2) {
      icon = Icons.star_half;                // half-filled
    } else {
      icon = Icons.star;                     // full filled
    }

    return Icon(
      icon,
      color: icon == Icons.star_border ? emptyColor : filledColor,
      size: size,
    );
  }
}

import 'package:flutter/material.dart';

// ZPromoBanner model
class ZPromoBanner {
  final String id;
  final String headline;
  final String subline;
  final String ctaLabel;
  final String imageUrl;
  final Color bgColor;

  const ZPromoBanner({
    required this.id,
    required this.headline,
    required this.subline,
    required this.ctaLabel,
    required this.imageUrl,
    required this.bgColor,
  });
}

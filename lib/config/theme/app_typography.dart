import 'package:flutter/material.dart';

abstract final class AppTypography {
  static const TextStyle headline = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: Color(0xFF1A1A1A),
  );

  static const TextStyle body = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: Color(0xFF1A1A1A),
  );

  static const TextStyle navLabel = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
  );
}

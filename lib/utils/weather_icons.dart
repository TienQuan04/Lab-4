import 'package:flutter/material.dart';

class WeatherIcons {
  static IconData getIcon(String condition) {
    final c = condition.toLowerCase();

    if (c.contains('cloud')) return Icons.cloud;
    if (c.contains('rain') || c.contains('drizzle')) return Icons.umbrella;
    if (c.contains('storm') || c.contains('thunder')) return Icons.flash_on;
    if (c.contains('snow')) return Icons.ac_unit;
    if (c.contains('mist') || c.contains('fog')) return Icons.blur_on;
    if (c.contains('wind')) return Icons.air;

    return Icons.wb_sunny;
  }
}

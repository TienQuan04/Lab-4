import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/models/forecast_model.dart';
import 'package:weather_app/providers/settings_provider.dart';

class HourlyForecastList extends StatelessWidget {
  final List<ForecastModel> forecasts;
  const HourlyForecastList({super.key, required this.forecasts});
  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final items = forecasts.take(8).toList();

    if (items.isEmpty) {
      return const SizedBox.shrink();
    }
    return SizedBox(
      height: 170,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        itemBuilder: (context, index) {
          final f = items[index];

          double temp = f.temperature;
          String unit = '°C';
          if (!settings.isCelsius) {
            temp = temp * 9 / 5 + 32;
            unit = '°F';
          }
          return Container(
            width: 90,
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  settings.is24h
                      ? DateFormat('HH:mm').format(f.dateTime)
                      : DateFormat('hh:mm a').format(f.dateTime),
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
                const SizedBox(height: 8),
                CachedNetworkImage(
                  imageUrl:
                      'https://openweathermap.org/img/wn/${f.icon}@2x.png',
                  width: 40,
                  height: 40,
                ),
                const SizedBox(height: 8),
                Text(
                  '${temp.round()}$unit',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Rain ${(f.pop * 100).round()}%',
                  style: const TextStyle(fontSize: 11, color: Colors.white70),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

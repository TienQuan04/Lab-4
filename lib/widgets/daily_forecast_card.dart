import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/models/forecast_model.dart';
import 'package:weather_app/providers/settings_provider.dart';
import 'package:weather_app/utils/date_formatter.dart';

class DailyForecastSection extends StatelessWidget {
  final List<ForecastModel> forecasts;

  const DailyForecastSection({super.key, required this.forecasts});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final List<ForecastModel> days = [];
    for (var i = 0; i < forecasts.length; i += 8) {
      days.add(forecasts[i]);
    }

    if (days.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          const Text(
            '5-day forecast',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          ...days.take(5).map((f) {
            double min = f.tempMin;
            double max = f.tempMax;
            String unit = '°C';

            if (!settings.isCelsius) {
              min = min * 9 / 5 + 32;
              max = max * 9 / 5 + 32;
              unit = '°F';
            }

            return Card(
              margin: const EdgeInsets.symmetric(vertical: 4),
              child: ListTile(
                leading: CachedNetworkImage(
                  imageUrl:
                      'https://openweathermap.org/img/wn/${f.icon}@2x.png',
                  width: 40,
                  height: 40,
                  errorWidget: (context, url, error) =>
                      const Icon(Icons.cloud, size: 34, color: Colors.grey),
                ),

                title: Text(DateFormatter.formatShortDay(f.dateTime)),
                subtitle: Text(f.description),

                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${min.round()}$unit / ${max.round()}$unit',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Rain: ${(f.pop * 100).round()}%',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

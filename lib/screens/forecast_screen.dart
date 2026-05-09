import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/providers/weather_provider.dart';
import 'package:weather_app/utils/date_formatter.dart';

class ForecastScreen extends StatelessWidget {
  const ForecastScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final forecast = context.watch<WeatherProvider>().forecast;

    return Scaffold(
      appBar: AppBar(title: const Text('Forecast')),
      body: forecast.isEmpty
          ? const Center(child: Text('No forecast data'))
          : ListView.builder(
              itemCount: forecast.length,
              itemBuilder: (context, index) {
                final f = forecast[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  child: ListTile(
                    leading: CachedNetworkImage(
                      imageUrl:
                          'https://openweathermap.org/img/wn/${f.icon}@2x.png',
                      width: 40,
                      height: 40,
                    ),
                    title: Text(DateFormatter.formatFullDate(f.dateTime)),
                    subtitle: Text(f.description),
                    trailing: Text(
                      '${f.tempMin.round()}° / ${f.tempMax.round()}°',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

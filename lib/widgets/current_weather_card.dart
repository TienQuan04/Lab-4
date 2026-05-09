import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/providers/settings_provider.dart';

class CurrentWeatherCard extends StatelessWidget {
  final WeatherModel weather;
  const CurrentWeatherCard({super.key, required this.weather});
  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    double temp = weather.temperature;
    double feels = weather.feelsLike;
    String unitSymbol = '°C';
    if (!settings.isCelsius) {
      temp = temp * 9 / 5 + 32;
      feels = feels * 9 / 5 + 32;
      unitSymbol = '°F';
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: _getWeatherGradient(weather.description),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(
            weather.cityName,
            style: const TextStyle(fontSize: 32, color: Colors.white),
          ),
          Text(
            DateFormat('EEEE, MMM d').format(weather.dateTime),
            style: const TextStyle(fontSize: 16, color: Colors.white70),
          ),
          const SizedBox(height: 20),
          CachedNetworkImage(
            imageUrl:
                'https://openweathermap.org/img/wn/${weather.icon}@4x.png',
            height: 120,
          ),
          Text(
            '${temp.round()}$unitSymbol',
            style: const TextStyle(fontSize: 80, color: Colors.white),
          ),
          Text(
            weather.description.toUpperCase(),
            style: const TextStyle(fontSize: 20, color: Colors.white),
          ),
          Text(
            'Feels like ${feels.round()}$unitSymbol',
            style: const TextStyle(fontSize: 16, color: Colors.white70),
          ),
        ],
      ),
    );
  }

  LinearGradient _getWeatherGradient(String condition) {
    final c = condition.toLowerCase();
    if (c.contains('clear')) {
      return const LinearGradient(
        colors: [Color(0xFF4A90E2), Color(0xFF87CEEB)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    } else if (c.contains('rain')) {
      return const LinearGradient(
        colors: [Color(0xFF4A5568), Color(0xFF718096)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    } else if (c.contains('cloud')) {
      return const LinearGradient(
        colors: [Color(0xFFA0AEC0), Color(0xFFCBD5E0)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    } else {
      return const LinearGradient(
        colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    }
  }
}

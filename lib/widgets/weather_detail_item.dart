import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/providers/settings_provider.dart';
import 'package:weather_app/utils/constants.dart';
import 'package:weather_app/utils/weather_icons.dart';
class WeatherDetailsSection extends StatelessWidget {
  final WeatherModel weather;
  const WeatherDetailsSection({super.key, required this.weather});
  String _formatWindDirection(int deg) {
    const dirs = ['N', 'NE', 'E', 'SE', 'S', 'SW', 'W', 'NW'];
    final index = ((deg % 360) / 45).round() % 8;
    return dirs[index];
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();

    double speed = weather.windSpeed; 
    String unitLabel = 'm/s';

    switch (settings.windUnit) {
      case WindUnit.kmh:
        speed = weather.windSpeed * 3.6; 
        unitLabel = 'km/h';
        break;
      case WindUnit.mph:
        speed = weather.windSpeed * 2.23694; 
        unitLabel = 'mph';
        break;
      default:
        speed = weather.windSpeed;
        unitLabel = 'm/s';
        break;
    }

    final visibilityKm = weather.visibility != null
        ? (weather.visibility! / 1000).toStringAsFixed(1)
        : 'N/A';

    final clouds = weather.cloudiness != null
        ? '${weather.cloudiness}%'
        : 'N/A';

    final windDirection = _formatWindDirection(weather.windDeg);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Details',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        WeatherDetailItem(
                          icon: WeatherIcons.getIcon('humidity'),
                          label: AppConstants.humidityLabel,
                          value: '${weather.humidity}%',
                        ),
                        const SizedBox(height: 12),
                        WeatherDetailItem(
                          icon: WeatherIcons.getIcon('wind'),
                          label: AppConstants.windSpeedLabel,
                          value:
                              '${speed.toStringAsFixed(1)} $unitLabel $windDirection',
                        ),
                        const SizedBox(height: 12),
                        WeatherDetailItem(
                          icon: Icons.compress,
                          label: AppConstants.pressureLabel,
                          value: '${weather.pressure} hPa',
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 16),

                  Expanded(
                    child: Column(
                      children: [
                        WeatherDetailItem(
                          icon: Icons.visibility,
                          label: AppConstants.visibilityLabel,
                          value: '$visibilityKm km',
                        ),
                        const SizedBox(height: 12),
                        WeatherDetailItem(
                          icon: WeatherIcons.getIcon('cloud'),
                          label: AppConstants.cloudsLabel,
                          value: clouds,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WeatherDetailItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const WeatherDetailItem({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20),
        const SizedBox(width: 8),
        Expanded(child: Text(label, style: const TextStyle(fontSize: 14))),
        Text(
          value,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

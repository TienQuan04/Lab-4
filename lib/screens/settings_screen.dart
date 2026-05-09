import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/providers/settings_provider.dart';

class SettingsScreen extends StatelessWidget {
  static const routeName = '/settings';
  const SettingsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Temperature unit'),
            subtitle: Text(
              settings.isCelsius ? 'Celsius (°C)' : 'Fahrenheit (°F)',
            ),
            value: settings.isCelsius,
            onChanged: (value) {
              context.read<SettingsProvider>().setIsCelsius(value);
            },
          ),
          SwitchListTile(
            title: const Text('Time format'),
            subtitle: Text(settings.is24h ? '24-hour' : '12-hour'),
            value: settings.is24h,
            onChanged: (value) {
              context.read<SettingsProvider>().setIs24h(value);
            },
          ),

          const Divider(),
          ListTile(
            title: const Text('Wind speed unit'),
            subtitle: Text(settings.windUnitLabel),
            trailing: DropdownButton<WindUnit>(
              value: settings.windUnit,
              onChanged: (unit) {
                if (unit != null) {
                  context.read<SettingsProvider>().setWindUnit(unit);
                }
              },
              items: const [
                DropdownMenuItem(
                  value: WindUnit.ms,
                  child: Text('Meters per second (m/s)'),
                ),
                DropdownMenuItem(
                  value: WindUnit.kmh,
                  child: Text('Kilometers per hour (km/h)'),
                ),
                DropdownMenuItem(
                  value: WindUnit.mph,
                  child: Text('Miles per hour (mph)'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

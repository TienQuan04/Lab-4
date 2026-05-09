import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/providers/settings_provider.dart';
import 'package:weather_app/providers/weather_provider.dart';
import 'package:weather_app/screens/search_screen.dart';
import 'package:weather_app/screens/settings_screen.dart';
import 'package:weather_app/widgets/current_weather_card.dart';
import 'package:weather_app/widgets/daily_forecast_card.dart';
import 'package:weather_app/widgets/error_widget.dart';
import 'package:weather_app/widgets/hourly_forecast_list.dart';
import 'package:weather_app/widgets/loading_shimmer.dart';
import 'package:weather_app/widgets/weather_detail_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> {
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final provider = context.read<WeatherProvider>();
      provider.loadFromCacheIfAvailable();
      _initialized = true;
    }
  }
  @override
  Widget build(BuildContext context) {
    final weatherProvider = context.watch<WeatherProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location),
            tooltip: 'Vị trí hiện tại',
            onPressed: () {
              weatherProvider.fetchWeatherByCurrentLocation();
            },
          ),
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: 'Search city',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SearchScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Settings',
            onPressed: () {
              Navigator.pushNamed(context, SettingsScreen.routeName);
            },
          ),
        ],
      ),
      body: _buildBody(weatherProvider),
    );
  }

  Widget _buildBody(WeatherProvider provider) {
    switch (provider.state) {
      case WeatherState.initial:
        return const Center(
          child: Text('Hãy chọn thành phố hoặc dùng vị trí hiện tại'),
        );
      case WeatherState.loading:
        return const LoadingShimmer();
      case WeatherState.error:
        return ErrorWidgetCustom(
          message: provider.errorMessage ?? 'Đã xảy ra lỗi',
          onRetry: () {
            if (provider.currentWeather != null) {
              provider.fetchWeatherByCity(provider.currentWeather!.cityName);
            } else {
              provider.fetchWeatherByCurrentLocation();
            }
          },
        );
      case WeatherState.loaded:
        final settings = context.watch<SettingsProvider>();
        final weather = provider.currentWeather;
        final forecast = provider.forecast;

        if (weather == null) {
          return const Center(child: Text('No data'));
        }

        return ListView(
          children: [
            CurrentWeatherCard(weather: weather),
            WeatherDetailsSection(weather: weather),
            HourlyForecastList(forecasts: forecast),
            DailyForecastSection(forecasts: forecast),
            if (provider.lastUpdated != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 16.0),
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (provider.isFromCache)
                        const Icon(Icons.cloud_off, size: 16),
                      if (provider.isFromCache) const SizedBox(width: 4),
                      Text(
                        'Last updated: ${settings.is24h ? DateFormat('HH:mm dd/MM/yyyy').format(provider.lastUpdated!) : DateFormat('hh:mm a dd/MM/yyyy').format(provider.lastUpdated!)}${provider.isFromCache ? ' (offline data)' : ''}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        );
    }
  }
}

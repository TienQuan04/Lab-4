import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/models/forecast_model.dart';
import 'package:weather_app/models/weather_model.dart';

class LastWeatherCache {
  final WeatherModel weather;
  final List<ForecastModel> forecast;
  final DateTime lastUpdated;

  LastWeatherCache({
    required this.weather,
    required this.forecast,
    required this.lastUpdated,
  });
}

class StorageService {
  static const lastWeatherKey = 'last_weather';
  static const lastForecastKey = 'last_forecast';
  static const lastUpdatedKey = 'last_updated';
  static const recentCitiesKey = 'recent_cities';

  Future<void> saveLastWeather(
    WeatherModel weather,
    List<ForecastModel> forecast,
    DateTime lastUpdated,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(lastWeatherKey, jsonEncode(weather.toJson()));
    prefs.setString(
      lastForecastKey,
      jsonEncode(forecast.map((e) => e.toJson()).toList()),
    );
    prefs.setString(lastUpdatedKey, lastUpdated.toIso8601String());
  }
  Future<LastWeatherCache?> loadLastWeather() async {
    final prefs = await SharedPreferences.getInstance();
    final weatherStr = prefs.getString(lastWeatherKey);
    final forecastStr = prefs.getString(lastForecastKey);
    final updatedStr = prefs.getString(lastUpdatedKey);
    if (weatherStr == null || forecastStr == null || updatedStr == null) {
      return null;
    }
    final weatherJson = jsonDecode(weatherStr) as Map<String, dynamic>;
    final forecastJson = jsonDecode(forecastStr) as List<dynamic>;
    final lastUpdated = DateTime.parse(updatedStr);
    final weather = WeatherModel.fromJson(weatherJson);
    final forecast = forecastJson
        .map((e) => ForecastModel.fromJson(e as Map<String, dynamic>))
        .toList();
    return LastWeatherCache(
      weather: weather,
      forecast: forecast,
      lastUpdated: lastUpdated,
    );
  }
  Future<void> saveRecentCities(List<String> cities) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(recentCitiesKey, cities);
  }
  Future<List<String>> getRecentCities() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(recentCitiesKey) ?? [];
  }
}

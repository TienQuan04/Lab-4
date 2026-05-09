import 'package:flutter/material.dart';

import 'package:weather_app/models/forecast_model.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/services/location_service.dart';
import 'package:weather_app/services/storage_service.dart';
import 'package:weather_app/services/weather_service.dart';

enum WeatherState { initial, loading, loaded, error }

class WeatherProvider extends ChangeNotifier {
  final WeatherService _weatherService;
  final LocationService _locationService;
  final StorageService _storageService;

  WeatherProvider(
    this._weatherService,
    this._locationService,
    this._storageService,
  );

  WeatherModel? _currentWeather;
  List<ForecastModel> _forecast = [];
  WeatherState _state = WeatherState.initial;
  String? _errorMessage;
  DateTime? _lastUpdated;
  bool _isFromCache = false;

  WeatherModel? get currentWeather => _currentWeather;
  List<ForecastModel> get forecast => _forecast;
  WeatherState get state => _state;
  String? get errorMessage => _errorMessage;
  DateTime? get lastUpdated => _lastUpdated;
  bool get isFromCache => _isFromCache;

  Future<void> loadFromCacheIfAvailable() async {
    final cached = await _storageService.loadLastWeather();
    if (cached == null) return;

    _currentWeather = cached.weather;
    _forecast = cached.forecast;
    _lastUpdated = cached.lastUpdated;
    _isFromCache = true;
    _state = WeatherState.loaded;
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> fetchWeatherByCity(String cityName) async {
    final trimmed = cityName.trim();
    if (trimmed.isEmpty) return;

    _state = WeatherState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final current = await _weatherService.getCurrentWeatherByCity(trimmed);
      final forecast = await _weatherService.getForecast(trimmed);

      _currentWeather = current;
      _forecast = forecast;
      _lastUpdated = DateTime.now();
      _isFromCache = false;

      await _storageService.saveLastWeather(current, forecast, _lastUpdated!);

      _state = WeatherState.loaded;
    } catch (e) {
      _state = WeatherState.error;

      if (e is WeatherException) {
        _errorMessage = e.message;
      } else {
        _errorMessage =
            'Đã xảy ra lỗi khi tải dữ liệu thời tiết. Vui lòng thử lại.';
      }
    }

    notifyListeners();
  }

  Future<void> fetchWeatherByCurrentLocation() async {
    _state = WeatherState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final position = await _locationService.getCurrentLocation();

      final current = await _weatherService.getCurrentWeatherByCoordinates(
        position.latitude,
        position.longitude,
      );

      final cityName = await _locationService.getCityName(
        position.latitude,
        position.longitude,
      );

      final forecast = await _weatherService.getForecast(cityName);

      _currentWeather = current;
      _forecast = forecast;
      _lastUpdated = DateTime.now();
      _isFromCache = false;

      await _storageService.saveLastWeather(current, forecast, _lastUpdated!);

      _state = WeatherState.loaded;
    } catch (e) {
      _state = WeatherState.error;

      if (e is WeatherException) {
        _errorMessage = e.message;
      } else {
        _errorMessage =
            'Đã xảy ra lỗi khi tải dữ liệu thời tiết. Vui lòng thử lại.';
      }

      await loadFromCacheIfAvailable();
    }

    notifyListeners();
  }

  Future<void> refreshWeather() async {
    if (_currentWeather != null) {
      await fetchWeatherByCity(_currentWeather!.cityName);
    } else {
      await fetchWeatherByCurrentLocation();
    }
  }
}

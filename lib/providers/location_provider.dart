import 'package:flutter/material.dart';
import 'package:weather_app/services/location_service.dart';

class LocationProvider extends ChangeNotifier {
  final LocationService _locationService;

  bool _isLoading = false;
  String? _currentCity;
  String? _errorMessage;

  LocationProvider(this._locationService);

  bool get isLoading => _isLoading;
  String? get currentCity => _currentCity;
  String? get errorMessage => _errorMessage;

  Future<void> loadCurrentCity() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final position = await _locationService.getCurrentLocation();
      final cityName = await _locationService.getCityName(
        position.latitude,
        position.longitude,
      );
      _currentCity = cityName;
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }
}

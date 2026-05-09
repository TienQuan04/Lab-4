import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum WindUnit {
  ms, // meters per second
  kmh, // kilometers per hour
  mph, // miles per hour
}

class SettingsProvider extends ChangeNotifier {
  bool _isCelsius = true;
  bool _is24h = true;
  WindUnit _windUnit = WindUnit.ms;

  bool get isCelsius => _isCelsius;
  bool get is24h => _is24h;
  WindUnit get windUnit => _windUnit;

  SettingsProvider() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    _isCelsius = prefs.getBool('temp_celsius') ?? true;
    _is24h = prefs.getBool('time_24h') ?? true;

    final windStr = prefs.getString('wind_unit') ?? 'ms';
    switch (windStr) {
      case 'kmh':
        _windUnit = WindUnit.kmh;
        break;
      case 'mph':
        _windUnit = WindUnit.mph;
        break;
      case 'ms':
      default:
        _windUnit = WindUnit.ms;
        break;
    }

    notifyListeners();
  }

  Future<void> setIsCelsius(bool value) async {
    _isCelsius = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('temp_celsius', value);
    notifyListeners();
  }

  Future<void> setIs24h(bool value) async {
    _is24h = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('time_24h', value);
    notifyListeners();
  }

  Future<void> setWindUnit(WindUnit unit) async {
    _windUnit = unit;
    final prefs = await SharedPreferences.getInstance();

    String value;
    switch (unit) {
      case WindUnit.kmh:
        value = 'kmh';
        break;
      case WindUnit.mph:
        value = 'mph';
        break;
      default:
        value = 'ms';
        break;
    }

    await prefs.setString('wind_unit', value);
    notifyListeners();
  }

  String get windUnitLabel {
    switch (_windUnit) {
      case WindUnit.kmh:
        return 'km/h';
      case WindUnit.mph:
        return 'mph';
      default:
        return 'm/s';
    }
  }
}

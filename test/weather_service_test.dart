import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/models/weather_model.dart';

class FakeWeatherService {
  Future<WeatherModel> getCurrentWeatherByCity(String city) async {
    if (city == 'InvalidCity') {
      throw Exception('City not found');
    }
    final json = {
      "name": city,
      "dt": 1700000000,
      "main": {
        "temp": 25.0,
        "feels_like": 26.0,
        "humidity": 70,
        "pressure": 1012,
      },
      "wind": {"speed": 3.5, "deg": 180},
      "visibility": 10000,
      "clouds": {"all": 40},
      "sys": {"sunrise": 1700000000, "sunset": 1700040000},
      "weather": [
        {"description": "clear sky", "icon": "01d"},
      ],
    };

    return WeatherModel.fromJson(json);
  }
}

void main() {
  group('WeatherService Tests', () {
    final weatherService = FakeWeatherService();

    test('Parse weather JSON correctly', () async {
      final weather = await weatherService.getCurrentWeatherByCity(
        'Ho Chi Minh City',
      );

      expect(weather.temperature, 25.0);
      expect(weather.cityName, 'Ho Chi Minh City');
    });

    test('Handle API error gracefully', () async {
      expect(
        () => weatherService.getCurrentWeatherByCity('InvalidCity'),
        throwsException,
      );
    });
  });
}

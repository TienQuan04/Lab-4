import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/models/weather_model.dart';

void main() {
  group('WeatherModel Tests', () {
    test('Parse weather JSON correctly', () {
      final json = {
        "name": "Ho Chi Minh City",
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

      final weather = WeatherModel.fromJson(json);

      expect(weather.cityName, 'Ho Chi Minh City');
      expect(weather.temperature, 25.0);
      expect(weather.feelsLike, 26.0);
      expect(weather.humidity, 70);
      expect(weather.pressure, 1012);
      expect(weather.windSpeed, 3.5);
      expect(weather.windDeg, 180);
      expect(weather.description, 'clear sky');
      expect(weather.icon, '01d');
    });
  });
}

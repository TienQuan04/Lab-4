import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weather_app/config/api_config.dart';
import 'package:weather_app/models/forecast_model.dart';
import 'package:weather_app/models/weather_model.dart';

class WeatherException implements Exception {
  final String message;
  WeatherException(this.message);
  @override
  String toString() => message;
}

class WeatherService {
  final String apiKey;
  WeatherService({required this.apiKey});
  Future<WeatherModel> getCurrentWeatherByCity(String cityName) async {
    final url = ApiConfig.buildUrl(ApiConfig.currentWeather, {'q': cityName});
    print(url);
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return WeatherModel.fromJson(json.decode(response.body));
      }
      handleErrorStatus(response.statusCode);
      throw WeatherException('Unknown error');
    } catch (e) {
      throw WeatherException(e.toString());
    }
  }
  Future<WeatherModel> getCurrentWeatherByCoordinates(
    double lat,
    double lon,
  ) async {
    final url = ApiConfig.buildUrl(ApiConfig.currentWeather, {
      'lat': lat.toString(),
      'lon': lon.toString(),
    });
    print(url);
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return WeatherModel.fromJson(json.decode(response.body));
      }
      handleErrorStatus(response.statusCode);
      throw WeatherException('Unknown error');
    } catch (e) {
      throw WeatherException(e.toString());
    }
  }
  Future<List<ForecastModel>> getForecast(String cityName) async {
    final url = ApiConfig.buildUrl(ApiConfig.forecast, {'q': cityName});
    print(url);
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> forecastList = data['list'] as List<dynamic>;
        return forecastList
            .map((item) => ForecastModel.fromJson(item))
            .toList();
      }
      handleErrorStatus(response.statusCode);
      throw WeatherException('Unknown error');
    } catch (e) {
      throw WeatherException(e.toString());
    }
  }
  void handleErrorStatus(int statusCode) {
    if (statusCode == 401) {
      throw WeatherException(
        'API key không hợp lệ. Vui lòng kiểm tra lại cấu hình API.',
      );
    } else if (statusCode == 404) {
      throw WeatherException(
        'Không tìm thấy thành phố. Vui lòng kiểm tra lại tên và thử lại.',
      );
    } else if (statusCode == 429) {
      throw WeatherException(
        'Bạn đã vượt quá giới hạn số lần gọi API. Vui lòng đợi một lúc rồi thử lại.',
      );
    } else {
      throw WeatherException(
        'Không thể tải dữ liệu (mã lỗi: $statusCode). Vui lòng thử lại sau.',
      );
    }
  }
  String getIconUrl(String iconCode) {
    return 'https://openweathermap.org/img/wn/$iconCode@2x.png';
  }
}

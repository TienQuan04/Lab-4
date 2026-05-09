import 'dart:convert';

class WeatherModel {
  final String cityName;
  final double temperature;
  final double feelsLike;
  final int humidity;
  final double windSpeed;
  final int windDeg;
  final int pressure;
  final int? visibility;
  final int? cloudiness;
  final DateTime dateTime;
  final DateTime? sunrise;
  final DateTime? sunset;
  final String description;
  final String icon;

  WeatherModel({
    required this.cityName,
    required this.temperature,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
    required this.windDeg,
    required this.pressure,
    this.visibility,
    this.cloudiness,
    required this.dateTime,
    this.sunrise,
    this.sunset,
    required this.description,
    required this.icon,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      cityName: json['name'] ?? '',
      temperature: (json['main']['temp'] as num).toDouble(),
      feelsLike: (json['main']['feels_like'] as num).toDouble(),
      humidity: json['main']['humidity'] as int,
      windSpeed: (json['wind']['speed'] as num).toDouble(),
      windDeg: (json['wind']['deg'] as num?)?.toInt() ?? 0,
      pressure: json['main']['pressure'] as int,
      visibility: json['visibility'] as int?,
      cloudiness: json['clouds']?['all'] as int?,
      dateTime: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000),
      sunrise: json['sys']?['sunrise'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['sys']['sunrise'] * 1000)
          : null,
      sunset: json['sys']?['sunset'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['sys']['sunset'] * 1000)
          : null,
      description: json['weather'][0]['description'] as String,
      icon: json['weather'][0]['icon'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': cityName,
      'main': {
        'temp': temperature,
        'feels_like': feelsLike,
        'humidity': humidity,
        'pressure': pressure,
      },
      'wind': {'speed': windSpeed, 'deg': windDeg},
      'visibility': visibility,
      'clouds': {'all': cloudiness},
      'dt': dateTime.millisecondsSinceEpoch ~/ 1000,
      'sys': {
        'sunrise': sunrise?.millisecondsSinceEpoch ?? 0 ~/ 1000,
        'sunset': sunset?.millisecondsSinceEpoch ?? 0 ~/ 1000,
      },
      'weather': [
        {'description': description, 'icon': icon},
      ],
    };
  }

  String toJsonString() => jsonEncode(toJson());

  static WeatherModel fromJsonString(String source) =>
      WeatherModel.fromJson(jsonDecode(source) as Map<String, dynamic>);
}

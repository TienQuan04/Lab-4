import 'dart:convert';

class ForecastModel {
  final DateTime dateTime;
  final double temperature;
  final double tempMin;
  final double tempMax;
  final String description;
  final String icon;
  final double pop;

  ForecastModel({
    required this.dateTime,
    required this.temperature,
    required this.tempMin,
    required this.tempMax,
    required this.description,
    required this.icon,
    required this.pop,
  });
  factory ForecastModel.fromJson(Map<String, dynamic> json) {
    return ForecastModel(
      dateTime: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000),
      temperature: (json['main']['temp'] as num).toDouble(),
      tempMin: (json['main']['temp_min'] as num).toDouble(),
      tempMax: (json['main']['temp_max'] as num).toDouble(),
      description: json['weather'][0]['description'] as String,
      icon: json['weather'][0]['icon'] as String,
      pop: (json['pop'] as num?)?.toDouble() ?? 0.0,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'dt': dateTime.millisecondsSinceEpoch ~/ 1000,
      'main': {'temp': temperature, 'temp_min': tempMin, 'temp_max': tempMax},
      'weather': [
        {'description': description, 'icon': icon},
      ],
      'pop': pop,
    };
  }

  static List<ForecastModel> listFromJson(List<dynamic> list) {
    return list.map((e) => ForecastModel.fromJson(e)).toList();
  }

  String toJsonString() => jsonEncode(toJson());

  static ForecastModel fromJsonString(String source) =>
      ForecastModel.fromJson(jsonDecode(source) as Map<String, dynamic>);
}

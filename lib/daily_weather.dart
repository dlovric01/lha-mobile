// daily_weather.dart

class DailyWeather {
  final DateTime date;
  final String description;
  final double tempDay;
  final double tempNight;
  final double rain;

  DailyWeather({
    required this.date,
    required this.description,
    required this.tempDay,
    required this.tempNight,
    required this.rain,
  });

  factory DailyWeather.fromJson(Map<String, dynamic> json) {
    return DailyWeather(
      date: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000),
      description: json['weather'][0]['description'],
      tempDay: (json['temp']['day'] as num).toDouble(),
      tempNight: (json['temp']['night'] as num).toDouble(),
      rain: json.containsKey('rain') ? (json['rain'] as num).toDouble() : 0.0,
    );
  }
}

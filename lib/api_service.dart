import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:lha_mobile/daily_weather.dart';
import 'package:weather/weather.dart';

class ApiService {
  final Dio _dio = Dio();
  final String _baseUrl = dotenv.env['BASE_URL']!;
  final String _jwt = dotenv.env['JWT']!;
  final String _weatherApiKey = dotenv.env['WEATHER']!;

  ApiService() {
    _dio.options = BaseOptions(
      baseUrl: 'https://$_baseUrl',
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
      headers: {
        'Authorization': 'Bearer $_jwt',
        'Content-Type': 'application/json',
      },
    );
  }

  Future<Response> toggleGarage(String garage) async {
    try {
      await Future.delayed(
        Duration(milliseconds: 500),
      ); // added for button spamming
      return await _dio.post('/garage/$garage');
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Response> toggleSlidingGate() async {
    await Future.delayed(
      Duration(milliseconds: 500),
    ); // added for button spamming

    throw 'Kapija još nije podržana. Dolazi uskoro 🚧';
  }

  Future<Weather> getWeather() async {
    try {
      final wf = WeatherFactory(_weatherApiKey, language: Language.CROATIAN);
      return await wf.currentWeatherByCityName('Donja Bistra');
    } catch (e) {
      throw 'Greška pri dohvaćanju vremena: $e';
    }
  }

  Future<List<dynamic>> getThreeHourForecast() async {
    try {
      final response = await _dio.get(
        'https://api.openweathermap.org/data/2.5/forecast',
        queryParameters: {
          'q': 'Donja Bistra,HR',
          'units': 'metric',
          'lang': 'hr',
          'appid': _weatherApiKey,
        },
      );
      return response.data['list'] as List<dynamic>;
    } catch (e) {
      throw 'Greška pri dohvaćanju detaljne prognoze: $e';
    }
  }

  Future<List<DailyWeather>> getDailyForecast() async {
    try {
      final response = await _dio.get(
        'https://api.openweathermap.org/data/2.5/forecast',
        queryParameters: {
          'q': 'Donja Bistra,HR',
          'units': 'metric',
          'lang': 'hr',
          'appid': _weatherApiKey,
        },
      );

      final List<dynamic> forecastList = response.data['list'];
      return _parseDailyForecast(forecastList);
    } catch (e) {
      throw 'Greška pri dohvaćanju prognoze: $e';
    }
  }

  List<DailyWeather> _parseDailyForecast(List<dynamic> list) {
    final Map<String, List<dynamic>> daily = {};

    for (var entry in list) {
      final dt = DateTime.fromMillisecondsSinceEpoch(entry['dt'] * 1000);
      final key = '${dt.year}-${dt.month}-${dt.day}';
      daily.putIfAbsent(key, () => []).add(entry);
    }

    return daily.entries.map((entry) {
      final parts = entry.key.split('-').map(int.parse).toList();
      final date = DateTime(parts[0], parts[1], parts[2]);
      final tempsDay = <double>[];
      final tempsNight = <double>[];
      final descriptions = <String>[];
      double totalRain = 0;

      for (var e in entry.value) {
        final hour = DateTime.fromMillisecondsSinceEpoch(e['dt'] * 1000).hour;
        final temp = e['main']['temp']?.toDouble() ?? 0.0;
        final desc = e['weather'][0]['description'] ?? '';
        final rain = e['rain']?['3h']?.toDouble() ?? 0.0;

        if (hour >= 6 && hour <= 18) {
          tempsDay.add(temp);
        } else {
          tempsNight.add(temp);
        }

        if (desc.isNotEmpty) descriptions.add(desc);
        totalRain += rain;
      }

      final avgDay =
          tempsDay.isNotEmpty
              ? tempsDay.reduce((a, b) => a + b) / tempsDay.length
              : 0.0;
      final avgNight =
          tempsNight.isNotEmpty
              ? tempsNight.reduce((a, b) => a + b) / tempsNight.length
              : 0.0;
      final desc =
          descriptions.isNotEmpty
              ? descriptions.reduce(
                (a, b) =>
                    descriptions.where((x) => x == a).length >=
                            descriptions.where((x) => x == b).length
                        ? a
                        : b,
              )
              : '';

      return DailyWeather(
        date: date,
        tempDay: avgDay,
        tempNight: avgNight,
        description: desc,
        rain: totalRain,
      );
    }).toList();
  }

  /// Optional: centralizirani error parser
  String _handleDioError(DioException e) {
    if (e.response?.statusCode == 401) {
      return 'Neautorizirano – provjeri JWT token.';
    } else if (e.type == DioExceptionType.connectionTimeout) {
      return 'Timeout spajanja na server.';
    } else if (e.type == DioExceptionType.badResponse) {
      return 'Greška: ${e.response?.statusCode} ${e.response?.statusMessage}';
    } else {
      return 'Nepoznata greška: ${e.message}';
    }
  }
}

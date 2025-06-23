import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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
      return await _dio.post('/garage/$garage');
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<Response> toggleSlidingGate() async {
    throw Exception('Kapija još nije podržana. Dolazi uskoro 🚧');
  }

  Future<Weather> getWeather() async {
    try {
      final wf = WeatherFactory(_weatherApiKey, language: Language.CROATIAN);
      return await wf.currentWeatherByCityName('Donja Bistra');
    } catch (e) {
      throw Exception('Greška pri dohvaćanju vremena: $e');
    }
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

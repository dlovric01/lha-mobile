import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiService {
  final Dio _dio = Dio();
  final String _baseUrl = dotenv.env['BASE_URL']!;
  final String _jwt = dotenv.env['JWT']!;

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
    return await _dio.post('/gate');
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

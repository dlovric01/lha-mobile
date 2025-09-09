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
    try {
      await Future.delayed(
        Duration(milliseconds: 500),
      ); // added for button spamming
      return await _dio.post('/gate');
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Optional: centralizirani error parser
  String _handleDioError(DioException e) {
    return 'Nesto je poslo po krivu pokusajte kasnije';
  }
}

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiService {
  final Dio _dio = Dio();

  ApiService() {
    // Optionally set some defaults, like timeouts:
    _dio.options.connectTimeout = Duration(seconds: 5); // 5 seconds
    _dio.options.receiveTimeout = Duration(seconds: 3); // 3 seconds
  }

  Future<Response> toggleGarage(String garage) async {
    final baseUrl = dotenv.env['BASE_URL'] ?? 'localhost';
    final jwt = dotenv.env['JWT'] ?? '';
    final url = 'https://$baseUrl/garage/$garage';

    try {
      final response = await _dio.post(
        url,
        options: Options(
          headers: {
            'Authorization': 'Bearer $jwt',
            'Content-Type': 'application/json',
          },
        ),
      );
      return response;
    } on DioException {
      // You can throw or handle errors here as needed
      rethrow;
    }
  }
}

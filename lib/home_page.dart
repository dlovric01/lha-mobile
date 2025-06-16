import 'package:flutter/material.dart';
import 'package:lha_mobile/api_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final ApiService apiService = ApiService();
  String responseMessage = '';

  Future<void> toggleGarage(String garage) async {
    try {
      final response = await apiService.toggleGarage(garage);
      setState(() {
        responseMessage = 'Success: ${response.data}';
      });
    } catch (e) {
      setState(() {
        responseMessage = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Garage Control')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                spacing: 10,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => toggleGarage('left'),
                      child: Text('Lijeva garaža'),
                    ),
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => toggleGarage('right'),
                      child: Text('Desna garaža'),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text(responseMessage),
          ],
        ),
      ),
    );
  }
}

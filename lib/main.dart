import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<void> _triggerGarage() async {
    const piIp = '192.168.1.9';
    const localApiUrl = 'http://$piIp:3000/trigger';

    try {
      final response = await http.get(Uri.parse(localApiUrl));
      if (response.statusCode == 200) {
        _showMessage('Garage triggered!');
      } else {
        _showMessage('Failed: ${response.statusCode}');
      }
    } catch (e) {
      _showMessage('Error: $e');
    }
  }

  void _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                ElevatedButton(onPressed: () {}, child: Text('Lijeva garaza')),
                Spacer(),
                ElevatedButton(
                  onPressed: _triggerGarage,
                  child: Text('Desna garaza'),
                ),
              ],
            ),
            ElevatedButton(onPressed: () {}, child: Text('Kapija')),
          ],
        ),
      ),
    );
  }
}

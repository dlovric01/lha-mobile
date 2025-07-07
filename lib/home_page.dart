// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:lha_mobile/api_service.dart';
import 'package:lha_mobile/control_section.dart';

enum LHAEnum {
  garageLeft('Lijeva garaža', 'left'),
  garageRight('Desna garaža', 'right'),
  slidingGate('Kapija', 'gate');

  final String description;
  final String value;
  const LHAEnum(this.description, this.value);
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
  }

  void _loadData() {
    // No weather data to load
  }

  Future<void> toggleItem(LHAEnum item) async {
    try {
      switch (item) {
        case LHAEnum.slidingGate:
          await apiService.toggleSlidingGate();
          break;
        default:
          await apiService.toggleGarage(item.value);
      }
      showCustomSnackbar('${item.description} OK');
    } catch (e) {
      showCustomSnackbar(e.toString(), isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF004E92), Color(0xFF000428)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: const Text(
              'Lovrić Dom',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.only(bottom: 100),
            child: Column(
              spacing: 10,
              children: [
                ControlSection(onToggle: toggleItem),
              ],
            ),
          ),
        ),
      ],
    );
  }








  void showCustomSnackbar(String message, {bool isError = false}) {
    final color = isError ? Colors.redAccent : Colors.greenAccent.shade400;
    final icon =
        isError ? Icons.warning_amber_rounded : Icons.check_circle_rounded;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
        content: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color.withOpacity(0.9),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(icon, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}

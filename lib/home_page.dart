// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lha_mobile/api_service.dart';
import 'package:lha_mobile/control_section.dart';
import 'package:weather/weather.dart';

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
  String responseMessage = '';

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

  late Future<Weather> _weatherFuture;

  @override
  void initState() {
    super.initState();
    _weatherFuture = apiService.getWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,

      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF004E92), Color(0xFF000428)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 70),
        child: Column(
          children: [
            const Text(
              'Lovrić Home Assistant',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            FutureBuilder<Object>(
              future: _weatherFuture,
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const SizedBox();
                final weather = snapshot.data as Weather;

                return Card(
                  color: Colors.white.withOpacity(0.1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Stack(
                      children: [
                        Column(
                          children: [
                            Text(
                              weather.areaName ?? '',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.thermostat,
                                  color: Colors.amberAccent,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  '${weather.temperature?.celsius?.toStringAsFixed(1) ?? '-'} °C',
                                  style: const TextStyle(
                                    fontSize: 32,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              weather.weatherDescription ?? '',
                              style: const TextStyle(color: Colors.white70),
                            ),
                            const SizedBox(height: 10),
                            Wrap(
                              alignment: WrapAlignment.center,
                              spacing: 16,
                              children: [
                                if (weather.tempFeelsLike?.celsius != null)
                                  _weatherDetail(
                                    'Osjećaj',
                                    '${weather.tempFeelsLike!.celsius!.toStringAsFixed(1)} °C',
                                  ),
                                if (weather.humidity != null)
                                  _weatherDetail(
                                    'Vlaga',
                                    '${weather.humidity}%',
                                  ),
                                if (weather.windSpeed != null)
                                  _weatherDetail(
                                    'Vjetar',
                                    '${weather.windSpeed} m/s',
                                  ),
                                if ((weather.rainLastHour ?? 0) > 0)
                                  _weatherDetail(
                                    'Kiša (1h)',
                                    '${weather.rainLastHour!.toStringAsFixed(1)} mm',
                                  ),
                                if ((weather.rainLast3Hours ?? 0) > 0)
                                  _weatherDetail(
                                    'Kiša (3h)',
                                    '${weather.rainLast3Hours!.toStringAsFixed(1)} mm',
                                  ),
                                if ((weather.snowLastHour ?? 0) > 0)
                                  _weatherDetail(
                                    'Snijeg',
                                    '${weather.snowLastHour!.toStringAsFixed(1)} mm',
                                  ),
                                if (weather.sunrise != null &&
                                    weather.sunset != null)
                                  _weatherDetail(
                                    'Sunce',
                                    '↑ ${_formatTime(weather.sunrise!)} ↓ ${_formatTime(weather.sunset!)}',
                                  ),
                              ],
                            ),
                          ],
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _weatherFuture = apiService.getWeather();
                              });
                            },
                            child: Icon(Icons.refresh, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 10),
            ControlSection(onToggle: toggleItem),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime dt) {
    final local = dt.toLocal();
    final sat = local.hour.toString().padLeft(2, '0');
    final min = local.minute.toString().padLeft(2, '0');
    return '$sat:$min';
  }

  Widget _weatherDetail(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white60, fontSize: 12),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
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

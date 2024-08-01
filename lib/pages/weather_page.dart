// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/data/dio/dio_client.dart';
import 'package:weather_app/models/weather_model.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final DioClient _dioClient =
      DioClient(apiKey: '5f7a88034e7692b2315dedae95c18e42', dioClient: Dio());
  WeatherModel? _weather;

  @override
  void initState() {
    super.initState();
    fetchWeather();
  }

  // Animacoes do clima
  String getWeatherAnimation(String? mainCondition) {
    if (_weather == null) {
      return 'assets/sunny.json';
    }
    switch (mainCondition) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/cloud.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/rain_sun.json';
      case 'thunderstorm':
        return 'assets/raining.json';
      case 'clear':
        return 'assets/sunny.json';
      default:
        return 'assets/sunny.json';
    }
  }

  // Buscar clima
  Future<void> fetchWeather() async {
    try {
      // Pegar a cidade atual
      String cityName = await _dioClient.getCurrentCity();
      if (cityName == 'Unknown' || cityName.isEmpty || cityName == '') {
        print('Nome da cidade inválido.');
        return;
      }
      print('Cidade atual: $cityName');
      // Buscar o clima da cidade
      final weather = await _dioClient.getWeather(cityName: cityName);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[600],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _weather?.cityName ?? 'Loading city...',
              style: GoogleFonts.oswald(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            // Animation
            Lottie.asset(
                getWeatherAnimation(_weather?.mainCondition.toLowerCase())),
            Text(
              '${_weather?.temperature.round() ?? ''} °C',
              style: GoogleFonts.oswald(
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              _weather?.mainCondition ?? 'Loading...',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

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
  final TextEditingController _cityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Inicialmente, buscar clima para a cidade atual
    _dioClient.getCurrentCity().then((cityName) {
      _cityController.text =
          cityName; // Atualiza o campo de texto com a cidade atual
      fetchWeatherFromCurrentCity(cityName);
    });
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

  // Buscar clima da cidade atual
  Future<void> fetchWeatherFromCurrentCity(String cityName) async {
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

  // Buscar clima da cidade digitada
  Future<void> fetchWeatherFromTypedCity(String cityName) async {
    try {
      // Pegar a cidade atual
      String cityName = _cityController.text;
      if (cityName == 'Unknown' || cityName.isEmpty || cityName == '') {
        print('Nome da cidade inválido.');
        return;
      }
      print('Cidade Digitada: $cityName');
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
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 72.0),
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.only(right: 24.0, left: 24.0, bottom: 48.0),
              child: TextField(
                controller: _cityController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[500],
                  hintText: 'Enter a city',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  isDense: true,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      fetchWeatherFromTypedCity(_cityController.text);
                    },
                  ),
                ),
              ),
            ),
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
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Min: ${_weather?.minTemperature.substring(0, 2) ?? 'Loading...'} °C',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 16),
                Text(
                  'Max: ${_weather?.maxTemperature.substring(0, 2) ?? 'Loading...'} °C',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

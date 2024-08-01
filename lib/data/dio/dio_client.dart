// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dio/dio.dart';

import 'package:weather_app/models/weather_model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

abstract class IdioClient {
  Future<WeatherModel> getWeather({required String cityName});
  Future<String> getCurrentCity();
}

class DioClient implements IdioClient {
  final Dio dioClient;
  // ignore: constant_identifier_names
  static const String BASE_URL =
      'https://api.openweathermap.org/data/2.5/weather';
  final String apiKey;
  DioClient({
    required this.dioClient,
    required this.apiKey,
  });

  @override
  @override
  Future<WeatherModel> getWeather({required String cityName}) async {
    try {
      print('Buscando clima para a cidade: $cityName');
      final response = await dioClient.get(BASE_URL, queryParameters: {
        'q': cityName,
        'appid': apiKey,
        'units': 'metric',
      });
      print('Resposta da API: ${response.data}');
      return WeatherModel.fromMap(response.data);
    } on DioException catch (e) {
      print('Erro ao buscar clima: ${e.message}');
      print('Código de status: ${e.response?.statusCode}');
      print('Resposta da API: ${e.response?.data}');
      throw Exception(e.message);
    }
  }

  @override
  Future<String> getCurrentCity() async {
    // pegar a permissao do usuario
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    // Verificar se a permissão foi negada permanentemente
    if (permission == LocationPermission.deniedForever) {
      print('Permissão de localização negada permanentemente.');
      return 'Unknown';
    }

    // Verificar se a permissão foi negada
    if (permission == LocationPermission.denied) {
      print('Permissão de localização negada.');
      return 'Unknown';
    }

    try {
      //buscar localizacao atual:
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      print(
          'Posição atual: Latitude: ${position.latitude}, Longitude: ${position.longitude}');

      //converter a localizacao em nome da cidade
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks[0];
        print('Placemark completo: ${placemark.toJson()}');

        // Verificar todos os campos disponíveis
        print('Locality: ${placemark.locality}');
        print('SubAdministrativeArea: ${placemark.subAdministrativeArea}');
        print('AdministrativeArea: ${placemark.administrativeArea}');
        print('Country: ${placemark.country}');
        String? city = placemark.locality ??
            placemark.subAdministrativeArea ??
            placemark.administrativeArea;
        if (city == '') {
          city = placemark.subAdministrativeArea;
        }
        print('Cidade encontrada: $city');
        return city ?? 'Unknown';
      } else {
        print('Nenhum local encontrado.');
        return 'Unknown';
      }
    } catch (e) {
      print('Erro ao obter a localização: $e');
      return 'Unknown';
    }
  }
}

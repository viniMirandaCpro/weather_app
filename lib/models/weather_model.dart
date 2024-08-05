// ignore_for_file: public_member_api_docs, sort_constructors_first
class WeatherModel {
  final String cityName;
  final double temperature;
  final String mainCondition;
  final String maxTemperature;
  final String minTemperature;

  WeatherModel({
    required this.cityName,
    required this.temperature,
    required this.mainCondition,
    required this.maxTemperature,
    required this.minTemperature,
  });

  factory WeatherModel.fromMap(Map<String, dynamic> map) {
    return WeatherModel(
      cityName: map['name'],
      temperature: map['main']['temp'].toDouble(),
      mainCondition: map['weather'][0]['main'],
      maxTemperature: map['main']['temp_max'].toString(),
      minTemperature: map['main']['temp_min'].toString(),
    );
  }
}

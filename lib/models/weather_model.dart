class WeatherModel {
  final String cityName;
  final double temperature;
  final String mainCondition;

  WeatherModel({
    required this.cityName,
    required this.temperature,
    required this.mainCondition,
  });

  factory WeatherModel.fromMap(Map<String, dynamic> map) {
    return WeatherModel(
      cityName: map['name'],
      temperature: map['main']['temp'].toDouble(),
      mainCondition: map['weather'][0]['main'],
    );
  }
}

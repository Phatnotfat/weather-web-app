class Weather {
  final String? city;
  final String? date;
  final double? temperature;
  final double? wind;
  final int? humidity;
  final String? conditionText;
  final String? iconUrl;

  Weather({
    this.city,
    this.date,
    this.temperature,
    this.wind,
    this.humidity,
    this.conditionText,
    this.iconUrl,
  });

  // Parse current weather
  factory Weather.fromJson(
    Map<String, dynamic> current,
    Map<String, dynamic> location,
  ) {
    return Weather(
      city: location['name'],
      date: location['localtime']?.split(' ')[0],
      temperature: (current['temp_c'] as num).toDouble(),
      wind: (current['wind_kph'] as num).toDouble() / 3.6, // Convert KPH to M/S
      humidity: current['humidity'],
      conditionText: current['condition']['text'],
      iconUrl: 'https:${current['condition']['icon']}',
    );
  }

  // Parse forecast day (1 item in forecastday)
  factory Weather.fromForecastJson(Map<String, dynamic> dayForecast) {
    final day = dayForecast['day'];
    final condition = day['condition'];

    return Weather(
      date: dayForecast['date'],
      temperature: (day['avgtemp_c'] as num).toDouble(),
      wind: (day['maxwind_kph'] as num).toDouble() / 3.6,
      humidity: day['avghumidity'].round(),
      conditionText: condition['text'],
      iconUrl: 'https:${condition['icon']}',
    );
  }
  @override
  String toString() {
    return 'Weather(city: $city, date: $date, temperature: $temperature, wind: $wind, humidity: $humidity, conditionText: $conditionText, iconUrl: $iconUrl)';
  }
}

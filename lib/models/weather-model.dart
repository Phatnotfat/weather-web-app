class Weather {
  final String? city;
  final String? country;
  final String? lastUpdated;
  final double? tempC;
  final double? windKph;
  final int? humidity;
  final String? conditionText;
  final String? conditionIcon;
  final String? date;
  final int? rainChance;

  Weather({
    this.city,
    this.country,
    this.lastUpdated,
    this.tempC,
    this.windKph,
    this.humidity,
    this.conditionText,
    this.conditionIcon,
    this.date,
    this.rainChance,
  });

  factory Weather.fromJson(
    Map<String, dynamic> json,
    Map<String, dynamic> location,
  ) {
    return Weather(
      city: location['name'],
      country: location['country'],
      lastUpdated: json['last_updated'],
      tempC: (json['temp_c'] as num?)?.toDouble(),
      windKph: (json['wind_kph'] as num?)?.toDouble(),
      humidity: json['humidity'] as int?,
      conditionText: json['condition'] as String?,
      conditionIcon: json['icon'] as String?,
    );
  }

  factory Weather.fromForecastJson(Map<String, dynamic> json) {
    return Weather(
      date: json['date'],
      tempC: (json['avgtemp_c'] as num?)?.toDouble(),
      conditionText: json['condition'] as String?,
      conditionIcon: json['icon'] as String?,
      rainChance: json['rain_chance'] as int?,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather_web/controllers/weather-controller.dart';

class RightContent extends GetView<WeatherController> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.weatherData.value.city == null) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 5,
                ),
              ],
            ),
            child: const Text(
              'Please enter a city name or use your current location to view the weather.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
                fontWeight: FontWeight.w800,
              ),
            ),
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Current weather card
            WeatherCard(
              city: controller.weatherData.value.city ?? '',
              date: controller.weatherData.value.date ?? '',
              temperature: controller.weatherData.value.tempC ?? 0,
              wind: controller.weatherData.value.windKph ?? 0,
              humidity: controller.weatherData.value.humidity ?? 0,
              conditionText: controller.weatherData.value.conditionText ?? '',
              iconUrl: controller.weatherData.value.conditionIcon ?? '',
            ),

            const SizedBox(height: 20),
            const Text(
              '4-Day Forecast',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(4, (index) {
                final item = controller.forecastData[index + 1];

                return ForecastItem(
                  date: item.date ?? '',
                  iconUrl: item.conditionIcon ?? '',
                  temperature: item.tempC ?? 0,
                  wind: item.windKph ?? 0,
                  humidity: item.humidity ?? 0,
                );
              }),
            ),
            const SizedBox(height: 16),
            Obx(
              () =>
                  controller.forecastMoreData.isNotEmpty
                      ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Divider(),
                          const SizedBox(height: 16),
                          const Text(
                            'Load More Forecast',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: List.generate(4, (index) {
                              final item = controller.forecastMoreData[index];
                              return ForecastItem(
                                date: item.date ?? '',
                                iconUrl: item.conditionIcon ?? '',
                                temperature: item.tempC ?? 0,
                                wind: item.windKph ?? 0,
                                humidity: item.humidity ?? 0,
                              );
                            }),
                          ),
                        ],
                      )
                      : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          OutlinedButton(
                            onPressed: () {
                              controller.handleLoadMore();
                            },
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(
                                color: Colors.blue,
                                width: 1.5,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 8,
                              ),
                              child: Text(
                                'Load More',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
            ),
          ],
        );
      }),
    );
  }
}

class WeatherCard extends StatelessWidget {
  final String city;
  final String date;
  final double temperature;
  final double wind;
  final int humidity;
  final String conditionText;
  final String iconUrl;

  const WeatherCard({
    required this.city,
    required this.date,
    required this.temperature,
    required this.wind,
    required this.humidity,
    required this.conditionText,
    required this.iconUrl,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xff4c72e1),
        borderRadius: BorderRadius.circular(4),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                city,
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Temperature: $temperature°C',
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 4),
              Text(
                'Wind: ${wind.toStringAsFixed(2)} M/S',
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 4),
              Text(
                'Humidity: $humidity%',
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
          Column(
            children: [
              Image.network(iconUrl, width: 64, height: 64),
              Text(conditionText, style: const TextStyle(color: Colors.white)),
            ],
          ),
        ],
      ),
    );
  }
}

class ForecastItem extends StatelessWidget {
  final String date;
  final String iconUrl;
  final double temperature;
  final double wind;
  final int humidity;

  const ForecastItem({
    required this.date,
    required this.iconUrl,
    required this.temperature,
    required this.wind,
    required this.humidity,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        width: 150,
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: Colors.grey.shade700,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '($date)',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Image.network(iconUrl, width: 48, height: 48),
            const SizedBox(height: 8),
            Text(
              'Temp: $temperature°C',
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 4),
            Text(
              'Wind: ${wind.toStringAsFixed(2)} M/S',
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 4),
            Text(
              'Humidity: $humidity%',
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

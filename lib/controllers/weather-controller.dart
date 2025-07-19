import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:web/web.dart' as web;
import 'package:get/get.dart';
import '../models/weather-model.dart';
import '../services/weather-service.dart';

class WeatherController extends GetxController {
  var weatherData = Weather().obs;
  var forecastData = <Weather>[].obs;
  var forecastMoreData = <Weather>[].obs;
  var isLoading = false.obs;
  final WeatherService _weatherService = WeatherService();
  final TextEditingController searchController = TextEditingController();
  var errorMessageTextField = ''.obs;
  var errorMessage = ''.obs;

  var todayHistory = <String>[].obs;
  @override
  void onInit() {
    getTodayHistory();
    super.onInit();
  }

  fetchWeather(String city) async {
    try {
      isLoading(true);

      var data = await _weatherService.getWeather(city, false);

      weatherData.value = data['current'];
      forecastData.value = data['forecast'];

      errorMessage.value = ''; // Clear any previous error messages
    } catch (e) {
      errorMessage.value = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading(false);
    }
  }

  fetchWeatherByCurrentLocation() async {
    try {
      isLoading(true);
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      var data = await _weatherService.getWeatherByCoords(
        position.latitude,
        position.longitude,
      );
      weatherData.value = data['current'];
      forecastData.value = data['forecast'];
      errorMessage.value = '';
    } catch (e) {
      errorMessage.value = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading(false);
    }
  }

  fetchMoreForecast(String city) async {
    try {
      var data = await _weatherService.getWeather(city, true);

      forecastMoreData.value = (data['forecast'] as List<Weather>).sublist(5);
    } catch (e) {
      errorMessage.value = e.toString().replaceFirst('Exception: ', '');
    }
  }

  validateSearchInput() {
    if (searchController.text.trim().isEmpty) {
      errorMessageTextField.value = 'Please enter a city name';
      return false;
    }
    errorMessageTextField.value = '';
    return true;
  }

  handleSearch() async {
    forecastMoreData.clear();
    if (validateSearchInput()) {
      await fetchWeather(searchController.text.trim());

      saveSearchToHistory(weatherData.value.city ?? '');
      getTodayHistory();
    }
  }

  checkLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      errorMessage.value = 'Location services are disabled.';
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        errorMessage.value = 'Location permissions are denied';
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      errorMessage.value = 'Location permissions are permanently denied';
      return false;
    }
    errorMessageTextField.value = '';
    return true;
  }

  handleFetchCurrentLocation() async {
    errorMessageTextField.value = '';
    searchController.clear();
    forecastMoreData.clear();
    if (await checkLocationPermission()) {
      fetchWeatherByCurrentLocation();
    }
  }

  handleLoadMore() {
    if (weatherData.value.city == null || weatherData.value.city!.isEmpty) {
      return;
    }
    fetchMoreForecast(weatherData.value.city ?? '');
  }

  void saveSearchToHistory(String city) {
    final key = 'weather_history';
    final now = DateTime.now().toIso8601String().split('T')[0];

    final storage = web.window.localStorage;
    final jsonStr = storage.getItem(key);
    List<Map<String, dynamic>> history = [];
    print('vao saveSearchToHistory');
    if (jsonStr != null) {
      final List<dynamic> decoded = jsonDecode(jsonStr);
      history =
          decoded
              .where((item) => item['date'] == now)
              .cast<Map<String, dynamic>>()
              .toList();
    }

    // Thêm mới
    history.add({'city': city, 'date': now});
    storage.setItem(key, jsonEncode(history));
  }

  getTodayHistory() {
    final key = 'weather_history';
    final now = DateTime.now().toIso8601String().split('T')[0];
    final storage = web.window.localStorage;
    final jsonStr = storage.getItem(key);

    if (jsonStr == null) return [];

    final List<dynamic> decoded = jsonDecode(jsonStr);
    todayHistory.value =
        decoded
            .where((item) => item['date'] == now)
            .map((item) => item['city'] as String)
            .toSet()
            .toList();
  }

  handleSelectHistoryCity(String city) {
    searchController.text = city;
    errorMessageTextField.value = '';
    forecastMoreData.clear();
    fetchWeather(city);
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}

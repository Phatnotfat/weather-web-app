import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather_web/controllers/weather-controller.dart';
import 'package:weather_web/widgets/content/left-bottom.dart';
import 'package:weather_web/widgets/content/left-top.dart';

class LeftContent extends GetView<WeatherController> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [LeftTop(), LeftBottom()],
      ),
    );
  }
}

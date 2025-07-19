import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather_web/controllers/weather-controller.dart';

class ErrorSection extends GetView<WeatherController> {
  @override
  Widget build(BuildContext context) {
    return Obx(
      () =>
          controller.errorMessage.value.isNotEmpty
              ? Container(
                color: const Color.fromARGB(255, 222, 33, 16),
                padding: const EdgeInsets.symmetric(vertical: 10),
                width: double.infinity,
                child: Center(
                  child: Text(
                    controller.errorMessage.value,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              )
              : const SizedBox.shrink(),
    );
  }
}

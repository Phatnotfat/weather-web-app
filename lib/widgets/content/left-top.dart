import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather_web/controllers/weather-controller.dart';

class LeftTop extends GetView<WeatherController> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Enter a City Name',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller.searchController,
          decoration: InputDecoration(
            hintText: 'E.g., New York, London, Tokyo',
            border: OutlineInputBorder(),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
        const SizedBox(height: 10),
        Obx(
          () =>
              controller.errorMessageTextField.value.isNotEmpty
                  ? Text(
                    controller.errorMessageTextField.value,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                  : const SizedBox.shrink(),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          height: 40,
          child: ElevatedButton(
            onPressed: () {
              controller.handleSearch();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff4c72e1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            child: const Text('Search', style: TextStyle(color: Colors.white)),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              Expanded(child: Divider()),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text('or'),
              ),
              Expanded(child: Divider()),
            ],
          ),
        ),

        SizedBox(
          width: double.infinity,
          height: 40,
          child: ElevatedButton(
            onPressed: () {
              controller.handleFetchCurrentLocation();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey.shade700,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            child: const Text(
              'Use Current Location',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        const SizedBox(height: 12),
        const Divider(),
      ],
    );
  }
}

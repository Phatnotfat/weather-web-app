import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather_web/controllers/weather-controller.dart';
import 'package:weather_web/widgets/email/email_subscribe_widget.dart';

class LeftBottom extends GetView<WeatherController> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        EmailSubscribeWidget(),
        const SizedBox(height: 12),
        const Divider(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Today's History",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
            ),
            const SizedBox(height: 8),
            Obx(
              () =>
                  controller.todayHistory.isEmpty
                      ? Text('No search history for today')
                      : Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children:
                            controller.todayHistory.map((city) {
                              return ActionChip(
                                label: Text(
                                  city,
                                  style: TextStyle(color: Colors.white),
                                ),
                                backgroundColor: const Color.fromARGB(
                                  255,
                                  113,
                                  145,
                                  242,
                                ),
                                onPressed: () {
                                  controller.handleSelectHistoryCity(city);
                                },
                              );
                            }).toList(),
                      ),
            ),
            // ),
          ],
        ),
      ],
    );
  }
}

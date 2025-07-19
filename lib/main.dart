import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather_web/controllers/weather-controller.dart';
import 'package:weather_web/firebase_options.dart';
import 'package:weather_web/widgets/content/left-bottom.dart';
import 'package:weather_web/widgets/content/left-top.dart';
import 'package:weather_web/widgets/content/right-content.dart';
import 'package:weather_web/widgets/error/error.dart';
import 'package:weather_web/widgets/header/header.dart';
import 'package:weather_web/widgets/content/left-content.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const WeatherWebApp());
}

class WeatherWebApp extends StatelessWidget {
  const WeatherWebApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: BindingsBuilder(() {
        Get.lazyPut(() => WeatherController());
      }),
      title: 'Weather Dashboard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: Theme.of(context).textTheme.apply(fontFamily: 'Rubik'),
      ),
      home: const WeatherDashboard(),
    );
  }
}

class WeatherDashboard extends GetView<WeatherController> {
  const WeatherDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffeaf6ff),
      body: SafeArea(
        child: Column(
          children: [
            Header(),
            ErrorSection(),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth < 600) {
                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          LeftTop(),
                          const SizedBox(height: 20),
                          RightContent(),
                          const SizedBox(height: 20),
                          LeftBottom(),
                        ],
                      ),
                    );
                  }

                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 2, child: LeftContent()),
                      Expanded(flex: 5, child: RightContent()),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

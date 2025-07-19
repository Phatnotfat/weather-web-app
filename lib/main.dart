import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:weather_web/controllers/weather-controller.dart';
import 'package:weather_web/firebase_options.dart';
import 'package:weather_web/widgets/content/right-content.dart';
import 'package:weather_web/widgets/error/error.dart';
import 'package:weather_web/widgets/header/header.dart';
import 'package:weather_web/widgets/content/left-content.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await dotenv.load();
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
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left input
                  Expanded(flex: 2, child: LeftContent()),
                  // Right content
                  Expanded(flex: 5, child: RightContent()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../services/email-service.dart';

class EmailController extends GetxController {
  final emailController = TextEditingController();
  final isLoading = false.obs;
  final message = ''.obs;

  final EmailService _emailService = EmailService();

  Future<Map<String, dynamic>> getLocationFromIP() async {
    final response = await http.get(Uri.parse('https://ipinfo.io/json'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final locParts = data['loc'].split(','); // "10.7626,106.6602"
      return {
        'latitude': double.parse(locParts[0]),
        'longitude': double.parse(locParts[1]),
        'city': data['city'],
      };
    } else {
      throw Exception('Unable to get location from IP');
    }
  }

  void subscribe(String email) async {
    if (!GetUtils.isEmail(email)) {
      message.value = 'Invalid email address.';
      return;
    }

    isLoading.value = true;
    try {
      final location = await getLocationFromIP();
      final lat = location['latitude'];
      final lng = location['longitude'];
      final city = location['city'];

      final response = await _emailService.subscribe(email, lat, lng, city);
      if (response.statusCode == 200) {
        message.value = 'Please check your email to confirm your subscription.';
      } else {
        message.value = 'Subscription failed: ${response.body}';
      }
    } catch (e) {
      message.value = 'Error: $e';
    } finally {
      isLoading.value = false;
    }
  }

  void unsubscribe(String email) async {
    if (!GetUtils.isEmail(email)) {
      message.value = 'Invalid email address.';
      return;
    }

    isLoading.value = true;
    try {
      final response = await _emailService.unsubscribe(email);
      if (response.statusCode == 200) {
        message.value = 'Please check your email to confirm unsubscription.';
      } else {
        message.value = 'Unsubscription failed: ${response.body}';
      }
    } catch (e) {
      message.value = 'Error: $e';
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}

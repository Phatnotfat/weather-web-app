import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/email-controller.dart';

class EmailSubscribeWidget extends StatelessWidget {
  EmailSubscribeWidget({super.key});
  final controller = Get.put(EmailController());

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 16),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              ' Subscribe for daily weather forecast:',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller.emailController,
              decoration: const InputDecoration(
                hintText: 'Enter your email address',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 10),
            Obx(
              () => Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  ElevatedButton(
                    onPressed:
                        controller.isLoading.value
                            ? null
                            : () => controller.subscribe(
                              controller.emailController.text,
                            ),
                    child:
                        controller.isLoading.value
                            ? const SizedBox(
                              height: 16,
                              width: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                            : const Text('Subscribe'),
                  ),
                  TextButton(
                    onPressed:
                        controller.isLoading.value
                            ? null
                            : () => controller.unsubscribe(
                              controller.emailController.text,
                            ),
                    child: const Text('Unsubscribe'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Obx(
              () => Text(
                controller.message.value,
                style: const TextStyle(color: Colors.blue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

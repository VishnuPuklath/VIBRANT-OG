import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

void showOTP(
    {required BuildContext context,
    required TextEditingController controller,
    required VoidCallback onPressed}) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return SizedBox(
          height: 200,
          width: 300,
          child: AlertDialog(
            title: const Text('Enter OTP'),
            content: PinCodeTextField(
              controller: controller,
              onChanged: (value) {},
              appContext: context,
              length: 6,
            ),
            actions: [
              ElevatedButton(
                onPressed: onPressed,
                child: const Text('Done'),
              )
            ],
          ),
        );
      });
}

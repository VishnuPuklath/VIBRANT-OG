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
        return Container(
          child: AlertDialog(
            title: const Align(
                alignment: Alignment.center, child: Text('Enter OTP')),
            content: Container(
              height: 100,
              width: 250,
              child: PinCodeTextField(
                controller: controller,
                onChanged: (value) {},
                appContext: context,
                length: 6,
              ),
            ),
            actions: [
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.black),
                  onPressed: onPressed,
                  child: const Text('Verify'),
                ),
              )
            ],
          ),
        );
      });
}

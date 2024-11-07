import 'package:crzy_crypto/authentication/otp_screen.dart';
import 'package:crzy_crypto/controller/assets_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class PhoneAuthentication extends StatefulWidget {
  const PhoneAuthentication({super.key});
  @override
  State<PhoneAuthentication> createState() {
    return _PhoneAuthentication();
  }
}

class _PhoneAuthentication extends State<PhoneAuthentication> {
  TextEditingController phoneController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Phone Auth"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                  hintText: "Enter your Phone Number",
                  suffixIcon: const Icon(Icons.phone),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24))),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          ElevatedButton(
              onPressed: () async {
                await FirebaseAuth.instance.verifyPhoneNumber(
                    verificationCompleted: (PhoneAuthCredential credential) {},
                    verificationFailed: (FirebaseAuthException ex) {},
                    codeSent: (String verificationid, int? resendToken) {
                      Get.to(OtpScreen(
                        verificationid: verificationid,
                      ));
                    },
                    codeAutoRetrievalTimeout: (String verificationid) {},
                    phoneNumber: phoneController.text.toString());
              },
              child: const Text("Verify Phone Noumber"))
        ],
      ),
    );
  }
}

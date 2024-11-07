import 'dart:developer';

import 'package:crzy_crypto/pages/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class OtpScreen extends StatefulWidget {
  final String verificationid;
  const OtpScreen({required this.verificationid, super.key});

  @override
  State<OtpScreen> createState() {
    return _OtpScreen();
  }
}

class _OtpScreen extends State<OtpScreen> {
  TextEditingController otpController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OTP Verification'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: TextField(
              controller: otpController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  hintText: "Enter OTP",
                  suffixIcon: Icon(Icons.phone),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25))),
            ),
          ),
          SizedBox(height: 30),
          ElevatedButton(
              onPressed: () async {
                try {
                  PhoneAuthCredential credential =
                      await PhoneAuthProvider.credential(
                          verificationId: widget.verificationid,
                          smsCode: otpController.text.toString());
                  FirebaseAuth.instance
                      .signInWithCredential(credential)
                      .then((value) {
                    Get.to(HomePage());
                  });
                } catch (e) {
                  log(e.toString());
                }
              },
              child: const Text("Verify"))
        ],
      ),
    );
  }
}

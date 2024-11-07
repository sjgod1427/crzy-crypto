import 'package:crzy_crypto/authentication/phone_authentication.dart';
import 'package:crzy_crypto/authentication/services.dart';
import 'package:crzy_crypto/component/button.dart';
import 'package:crzy_crypto/pages/home_page.dart';
import 'package:crzy_crypto/pages/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:rive/rive.dart' hide Image;

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreen();
}

class _LoginScreen extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void loginUser() async {
    setState(() {
      isLoading = true;
    });
    String res = await AuthServices().loginUser(
      email: emailController.text,
      password: passwordController.text,
    );
    setState(() {
      isLoading = false;
    });

    if (res == 'sucess') {
      Future.delayed(Duration(seconds: 1), () {
        Get.to(HomePage());
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res)));
    }
  }

  var animationLink = 'images/animated_login_screen.riv';
  late SMITrigger failTrigger, successTrigger;
  late SMIBool isChecking, isHandsUp;
  late SMINumber lookNum;
  Artboard? artboard;
  late StateMachineController? statemachineController;

  @override
  void initState() {
    super.initState();
    initArtBoard();
  }

  initArtBoard() {
    rootBundle.load(animationLink).then((value) async {
      await RiveFile.initialize();
      final file = RiveFile.import(value);
      final art = file.mainArtboard;
      statemachineController =
          StateMachineController.fromArtboard(art, "Login Machine")!;

      if (statemachineController != null) {
        art.addController(statemachineController!);
        for (var element in statemachineController!.inputs) {
          if (element.name == "isChecking") {
            isChecking = element as SMIBool;
          } else if (element.name == "isHandsUp") {
            isHandsUp = element as SMIBool;
          } else if (element.name == "trigSuccess") {
            successTrigger = element as SMITrigger;
          } else if (element.name == "trigFail") {
            failTrigger = element as SMITrigger;
          } else if (element.name == "numLook") {
            lookNum = element as SMINumber;
          }
        }
        setState(() {
          artboard = art;
        });
      }
    });
  }

  checking() {
    isHandsUp.change(false);
    isChecking.change(true);
    lookNum.change(0);
  }

  moveEyes(value) {
    lookNum.change(value.length.toDouble());
  }

  handsUp() {
    isHandsUp.change(true);
    isChecking.change(false);
  }

  login() {
    isHandsUp.change(false);
    isChecking.change(false);
    if (emailController.text == "admin" && passwordController.text == "admin") {
      successTrigger.fire();
    } else {
      failTrigger.fire();
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: height,
              ),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (artboard != null)
                      SizedBox(
                        width: 400,
                        height: 350,
                        child: Rive(artboard: artboard!),
                      ),
                    const SizedBox(height: 20),
                    TextField(
                      onTap: checking,
                      onChanged: ((value) => moveEyes(value)),
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      onTap: handsUp,
                      controller: passwordController,
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          "Forgot Password",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    MyButton(
                      onTab: loginUser,
                      text: isLoading ? "Logging in..." : "Login",
                    ),
                    if (isLoading) Center(child: CircularProgressIndicator()),
                    SizedBox(height: height / 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Use Phone Number Instead?",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.to(const PhoneAuthentication());
                          },
                          child: const Text(
                            " Sign Up",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Don't Have an Account?",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignUpScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            " Sign Up",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

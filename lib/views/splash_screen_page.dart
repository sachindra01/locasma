import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:locasma/bottom_navbar.dart';
import 'auth/sign_up_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    navigatetohome();
  }

  navigatetohome() async {
    await Future.delayed(const Duration(milliseconds: 2500)).then(
      (value) => Get.off(
        // () => const BottomNav(index: 0,),
        () => const SignUp(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("Locasma"),
      ),
    );
  }
}

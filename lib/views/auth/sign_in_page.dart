import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:locasma/bottom_navbar.dart';
import 'package:locasma/common/styles.dart';
import 'package:locasma/widgets/custom_button.dart';
import 'package:locasma/widgets/custom_text_field.dart';

import 'forgot_password.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
  Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        showDialog(
          context: context,
          builder: (conext) {
            return AlertDialog(
              title: Text(
                "doYouWantToExit".tr,
                style: black18,
              ),
              actions: <Widget>[
                TextButton(
                  child: Text(
                    'yes'.tr,
                    style: darkBlue16,
                  ),
                  onPressed: () {
                    SystemNavigator.pop();
                  },
                ),
                TextButton(
                  child: Text(
                    'no'.tr,
                    style: darkBlue16,
                  ),
                  onPressed: () {
                    Get.back();
                  },
                ),
              ],
            );
          },
        );

        return true;
      },
      child:  Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            height: size.height - kToolbarHeight,
            child: Stack(
              children: [
                Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: size.height * 0.09,
                      ),
                      Row(
                        children: [
                          Text(
                            'logIn'.tr,
                            style: darkBlue24,
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: (() {
                              Get.to(() => const ForgotPasswords());
                            }),
                            child: Text(
                              'forgotPasswordClick'.tr,
                              style: darkBlue14w400,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: size.height * 0.03,
                      ),
                      const Divider(
                        endIndent: 0.0,
                        indent: 0.0,
                        thickness: 2.0,
                        color: Color(0xffF0F0F0),
                      ),
                      SizedBox(
                        height: size.height * 0.03,
                      ),
                      Text(
                        'email'.tr,
                        style: grey12,
                      ),
                      SizedBox(
                        height: size.height * 0.01,
                      ),
                      const CustomTextField(
                          obscureText: false,
                          textCapitalization: TextCapitalization.none,
                          textInputAction: TextInputAction.next),
                      SizedBox(
                          height: size.height * 0.024,
                      ),
                      Text(
                        'password'.tr,
                        style: grey12,
                      ),
                      SizedBox(
                          height: size.height * 0.01,
                      ),
                      const CustomTextField(
                          obscureText: false,
                          textCapitalization: TextCapitalization.none,
                          textInputAction: TextInputAction.next),
                      SizedBox(
                          height: size.height * 0.375,
                      ),
                    ],
                  ),
                ),
          
                //login Button
                Container(
                    alignment: Alignment.bottomCenter,
                    padding: EdgeInsets.only(bottom: size.height * 0.078),
                    child: CustomButton(
                        btnColor: pink,
                        elevation: 4.0,
                        label: Text(
                         'logIn'.tr,
                          style: white24,
                        ),
                        height: 64.0,
                        width: 335.0,
                        onPress: () {
                          Get.to(const BottomNav(index: 0));
                    }
                    ),
                ),
              ],
            )
    )))));
  }
}

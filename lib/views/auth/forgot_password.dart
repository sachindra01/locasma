import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:locasma/common/styles.dart';
import 'package:locasma/main.dart';
import 'package:locasma/views/auth/sign_in_page.dart';
import 'package:locasma/widgets/custom_button.dart';
import 'package:locasma/widgets/custom_text_field.dart';

class ForgotPasswords extends StatefulWidget {
  const ForgotPasswords({Key? key}) : super(key: key);

  @override
  State<ForgotPasswords> createState() => _ForgotPasswordsState();
}

class _ForgotPasswordsState extends State<ForgotPasswords> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size; 
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal : 16.0),
            height: MediaQuery.of(context).size.height - kToolbarHeight,
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
                      Text(
                        'forgotPassword?'.tr,
                        style: darkBlue24,
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
                    ],
                  ),
                ),

                //backbbutton
                GestureDetector(
                  onTap: (){
                     Get.back();
                  },
                  child: Container(
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.only(top: size.height * 0.03,),
                    child: const Icon(
                      Icons.arrow_back_ios_new, 
                            size: 30, 
                            color: darkBlue,
                    )
                  ),
                ),

                //forgetpassword button
                Container(
                    alignment: Alignment.bottomCenter,
                    padding: EdgeInsets.only(bottom: size.height * 0.078),
                    child: CustomButton(
                          elevation: 4.0,
                          btnColor: pink,
                          label: Text(
                            'transmission'.tr,
                            style: white24,
                          ),
                          height: 64.0,
                          width: 335.0,
                          onPress: () {
                            Get.to(() => const SignIn());
                          }
                    ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

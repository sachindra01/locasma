import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:locasma/common/styles.dart';
import 'package:locasma/views/auth/sign_in_page.dart';
import 'package:locasma/widgets/custom_button.dart';
import 'package:locasma/widgets/step_indicator_button.dart';

import '../../widgets/custom_text_field.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  var activeStep = 0;
  String? headerText = "signUp";
  String? buttonText = "emailAuthentication";

  final emailVerificationController = TextEditingController();

  signUpSteps() {
    signUp() {
      headerText = "signUp";
      buttonText = "emailAuthentication";
    }

    emailVerification() {
      headerText = "emailAuthentication";
      buttonText = "complitionOfRegistration";
    }

    onVerificationSuccess() {
      headerText = "emailAuthentication";
      buttonText = "complitionOfRegistration";
    }

    switch (activeStep) {
      case 0:
        return signUp();

      case 1:
        return emailVerification();

      case 2:
        return onVerificationSuccess();

      default:
        return const SignUp();
    }
  }

  showAlertOnSuccess() {
    Future.delayed(
      const Duration(seconds: 2),
      () => Get.off(
        () => const SignIn(),
      ),
    );
    return showDialog(
     context: context,
     builder: (_) => Dialog(
     backgroundColor: Colors.transparent,
     insetPadding: EdgeInsets.zero,
     child:SizedBox(
     height: MediaQuery.of(context).size.height,
     width: double.infinity,
     child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                 borderRadius: BorderRadius.circular(100),
                 child: Container(
                  height: 120.0,
                  width: 120.0,
                  color: const Color(0xff5ED45B),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.check_rounded,
                    color: white,
                    size: 70,
                  ),
                ),
              ),
              const SizedBox(
                height: 32.0,
              ),
              Text(
                'thankYouForRegistering'.tr,
                style: const TextStyle(fontSize: 20.0, color: white),
              ),
            ],
          ),
      )
    )
    ); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height - kToolbarHeight,
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.09,
                      ),
                      Text(
                        headerText.toString().tr,
                        style: darkBlue24,
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      StepButton(
                        onTapRegistration: () {
                          setState(() {
                            activeStep = 0;
                          });
                          signUpSteps();
                        },
                        registerBgCol: darkBlue,
                        registerTxtCol: white12,
                        emailAuuthBgCol: activeStep == 1 || activeStep == 2
                            ? darkBlue
                            : lightBlue,
                        emailAuthTxtCol: activeStep == 1 || activeStep == 2
                            ? white12
                            : darkBlue12,
                        completeBgCol: activeStep == 2 ? darkBlue : lightBlue,
                        completeTxtCol: activeStep == 2 ? white12 : darkBlue12,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.021,
                      ),
                      const Divider(
                        endIndent: 0,
                        indent: 0,
                        thickness: 2,
                        color: Color(0xffF0F0F0),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      //Form
                      activeStep == 0
                          ? signUpForm()
                          : activeStep == 1 || activeStep == 2
                              ? emailAuthForm()
                              : const SizedBox(),
                    ],
                  ),
                ),

                //Sign Up Button
                Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).size.height * 0.078),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: CustomButton(
                      btnColor: pink,
                      elevation: 4.0,
                      label: Text(
                        buttonText!.tr,
                        style: white24,
                      ),
                      height: 64.0,
                      width: 335.0,
                      onPress: () {
                        setState(
                          () {
                            if (activeStep <= 1) {
                              activeStep++;
                            }
                          },
                        );
                        signUpSteps();
                        if (activeStep == 2) {
                          showAlertOnSuccess();
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget signUpForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'email'.tr,
          style: grey12,
        ),
        const SizedBox(
          height: 8.0,
        ),
        const CustomTextField(
            obscureText: false,
            textCapitalization: TextCapitalization.none,
            textInputAction: TextInputAction.next),
        const SizedBox(
          height: 20.0,
        ),
        Text(
          'password'.tr,
          style: grey12,
        ),
        const SizedBox(
          height: 8.0,
        ),
        const CustomTextField(
            obscureText: false,
            textCapitalization: TextCapitalization.none,
            textInputAction: TextInputAction.next),
        const SizedBox(
          height: 20.0,
        ),
        Text(
          'confirmPassword'.tr,
          style: grey12,
        ),
        const SizedBox(
          height: 8.0,
        ),
        const CustomTextField(
          obscureText: false,
          textCapitalization: TextCapitalization.none,
          textInputAction: TextInputAction.done,
        ),
      ],
    );
  }

  Widget emailAuthForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'authenticationCode(6digit)'.tr,
          style: grey12,
        ),
        const SizedBox(
          height: 8.0,
        ),
        CustomTextField(
            controller: emailVerificationController,
            obscureText: false,
            textCapitalization: TextCapitalization.none,
            textInputAction: TextInputAction.done),
      ],
    );
  }
}

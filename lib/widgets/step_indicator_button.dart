// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StepButton extends StatefulWidget {
  final registerBgCol,
      registerTxtCol,
      emailAuuthBgCol,
      emailAuthTxtCol,
      completeBgCol,
      completeTxtCol,
      onTapRegistration;
  const StepButton(
      {Key? key,
      this.registerBgCol,
      this.registerTxtCol,
      this.emailAuuthBgCol,
      this.emailAuthTxtCol,
      this.completeBgCol,
      this.completeTxtCol,
      this.onTapRegistration})
      : super(key: key);

  @override
  State<StepButton> createState() => _StepButtonState();
}

class _StepButtonState extends State<StepButton> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const SizedBox(
          height: 26,
          child: Center(
            child: Divider(
              endIndent: 20,
              indent: 20,
              thickness: 2.5,
              color: Color(0xffF0F0F0),
            ),
          ),
        ),
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.28,
                height: 26.0,
                child: ElevatedButton(
                  onPressed: widget.onTapRegistration,
                  child: Text(
                    "1newRegistration".tr,
                    style: widget.registerTxtCol,
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    elevation: 0.0,
                    primary: widget.registerBgCol,
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.28,
                height: 26.0,
                child: ElevatedButton(
                  onPressed: () {},
                  child: Text(
                    "2emailVerification".tr,
                    style: widget.emailAuthTxtCol,
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    elevation: 0.0,
                    primary: widget.emailAuuthBgCol,
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.28,
                height: 26.0,
                child: ElevatedButton(
                  onPressed: () {},
                  child: Text(
                    "3registrationCompleted".tr,
                    style: widget.completeTxtCol,
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    elevation: 0.0,
                    primary: widget.completeBgCol,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

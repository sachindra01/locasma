import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:locasma/common/styles.dart';

class CustomToast extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final toastText;
  const CustomToast({Key? key, this.toastText}) : super(key: key);

  @override
  State<CustomToast> createState() => _CustomToastState();
}

class _CustomToastState extends State<CustomToast> {
  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
  }

  //Toast
  late FToast fToast;

  showCustomToast(var toastText) {
    fToast.showToast(
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 12.0,
            ),
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              margin: const EdgeInsets.symmetric(
                horizontal: 6.0,
              ),
              decoration: BoxDecoration(
                color: const Color(0xffF1F9FF),
                borderRadius: BorderRadius.circular(4.0),
                border: const Border(
                  top: BorderSide(width: 1, color: darkBlue),
                  left: BorderSide(width: 1, color: darkBlue),
                  right: BorderSide(width: 1, color: darkBlue),
                  bottom: BorderSide(width: 1, color: darkBlue),
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                toastText,
                style: darkBlue16,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              fToast.removeCustomToast();
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Align(
                alignment: Alignment.topRight,
                child: Container(
                  height: 20.0,
                  width: 20.0,
                  decoration: BoxDecoration(
                    color: const Color(0xffF1F9FF),
                    borderRadius: BorderRadius.circular(100.0),
                    border: const Border(
                      top: BorderSide(width: 1, color: darkBlue),
                      left: BorderSide(width: 1, color: darkBlue),
                      right: BorderSide(width: 1, color: darkBlue),
                      bottom: BorderSide(width: 1, color: darkBlue),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: FittedBox(
                    child: Text(
                      "X",
                      style: darkBlue16,
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
      toastDuration: const Duration(seconds: 2),
      positionedToastBuilder: (context, child) {
        return Positioned(
          child: child,
          top: 40.0,
          left: 16.0,
          right: 16.0,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return showCustomToast(widget.toastText);
  }
}

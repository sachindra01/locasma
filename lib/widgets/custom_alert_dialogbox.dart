import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:locasma/common/styles.dart';

class CustomAlertDialogueBox {
  customDialogue(
    var context,
    Widget header,
    Widget body,
  ) {
    showDialog(
      context: context,
      builder: (context) => Stack(
        children: [
          StatefulBuilder(builder: (context, setState) {
            return Dialog(
              insetPadding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.04,
                  vertical: MediaQuery.of(context).size.height * 0.1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Header
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(4.0),
                      topRight: Radius.circular(4.0),
                    ),
                    child: Container(
                      width: double.infinity,
                      color: const Color(0xffFDFDFD),
                      child: Column(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: header,
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.022,
                          ),
                          Container(
                            height: 40.0,
                            margin:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            decoration: BoxDecoration(
                                color: white,
                                borderRadius: BorderRadius.circular(20.0),
                                border: const Border(
                                  top: BorderSide(
                                      width: 1.0, color: textFieldBorder),
                                  left: BorderSide(
                                      width: 1.0, color: textFieldBorder),
                                  right: BorderSide(
                                      width: 1.0, color: textFieldBorder),
                                  bottom: BorderSide(
                                      width: 1.0, color: textFieldBorder),
                                )),
                            child: TextField(
                              cursorColor: black,
                              cursorHeight: 20.0,
                              cursorRadius: const Radius.circular(5.0),
                              textInputAction: TextInputAction.search,
                              decoration: InputDecoration(
                                  prefixIcon: SizedBox(
                                    width: 1.0,
                                    child: Row(
                                      children: const [
                                        SizedBox(
                                          width: 10.0,
                                        ),
                                        Icon(
                                          Icons.search,
                                          color: darkBlue,
                                          size: 22.0,
                                        ),
                                        VerticalDivider(
                                          thickness: 1.0,
                                          endIndent: 10.0,
                                          indent: 10.0,
                                          color: lightGrey,
                                        )
                                      ],
                                    ),
                                  ),
                                  suffixIcon: Container(
                                    margin: const EdgeInsets.all(4.0),
                                    padding: const EdgeInsets.only(bottom: 2.0),
                                    width: 64.0,
                                    decoration: BoxDecoration(
                                      color: darkBlue,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'search'.tr,
                                        style: const TextStyle(
                                            color: white, fontSize: 16),
                                      ),
                                    ),
                                  ),
                                  hintText: 'searchByStoreName'.tr,
                                  hintStyle: const TextStyle(
                                      color: lightGrey,
                                      fontSize: 16.0,
                                      height: 1.16),
                                  border: InputBorder.none),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.014,
                          ),
                          Container(
                            width: double.infinity,
                            height: 1.0,
                            color: const Color(0xffF0f0f0),
                          ),
                        ],
                      ),
                    ),
                  ),
                  //Body
                  body,
                ],
              ),
            );
          }),
          GestureDetector(
            onTap: () => Get.back(),
            child: Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.09,
                  right: MediaQuery.of(context).size.width * 0.018),
              child: Align(
                alignment: Alignment.topRight,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100.0),
                  child: Container(
                    alignment: Alignment.center,
                    height: 30.0,
                    width: 30.0,
                    color: const Color(0xff555555),
                    child: const Icon(
                      Icons.close,
                      color: white,
                      size: 12.0,
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:locasma/common/styles.dart';
import 'package:locasma/widgets/custom_button.dart';

class MapShopListTile extends StatelessWidget {
  final VoidCallback? onAddBtnTap, onSeeMoreBtnTap;
  final image, name, distance, rank, location;
  const MapShopListTile({
    Key? key,
    this.image,
    this.name,
    this.distance,
    this.rank,
    this.location,
    this.onAddBtnTap,
    this.onSeeMoreBtnTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(
          left: 16.0, right: 16.0, top: 26.0, bottom: 24.0),
      decoration: containerShadow(),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(100.0),
                child: CachedNetworkImage(
                  imageUrl: image,
                  height: 28,
                  width: 28,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(
                width: 8.0,
              ),
              Text(
                name,
                style: black20,
              ),
              const Spacer(),
              CustomButton(
                btnColor: pink,
                onPress: onAddBtnTap,
                height: 30.0,
                width: 95.0,
                elevation: 0.0,
                label: Row(
                  children: [
                    const Icon(
                      Icons.directions,
                      color: white,
                      size: 20.0,
                    ),
                    const SizedBox(
                      width: 6.0,
                    ),
                    Text(
                      "addition".tr,
                      style: white16,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 8.0,
          ),
          const Divider(
            thickness: 1.0,
            color: Color(0xffF0F0F0),
          ),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "address".tr,
                    style: const TextStyle(
                        fontSize: 12.0,
                        color: lightGrey,
                        fontWeight: FontWeight.w400),
                  ),
                  Text(
                    location,
                    style: const TextStyle(
                        fontSize: 16.0,
                        color: grey,
                        fontWeight: FontWeight.w400),
                  ),
                ],
              ),
              const Spacer(),
              Column(
                children: [
                  Text("rank".tr, style: darkGrey12),
                  const SizedBox(
                    height: 2.0,
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100.0),
                    child: Container(
                      height: 25.0,
                      width: 25.0,
                      alignment: Alignment.center,
                      color: const Color(0xffB4A87D),
                      child: Text(
                        rank,
                        style: white16,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 10.0,
          ),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "distanceFromCurrentLocation".tr,
                    style: const TextStyle(
                        fontSize: 12.0,
                        color: lightGrey,
                        fontWeight: FontWeight.w400),
                  ),
                  Text(
                    distance,
                    style: const TextStyle(
                        fontSize: 16.0,
                        color: grey,
                        fontWeight: FontWeight.w400),
                  ),
                ],
              ),
              const Spacer(),
              GestureDetector(
                onTap: onSeeMoreBtnTap,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Text(
                    "seeMore".tr,
                    style: const TextStyle(
                        decoration: TextDecoration.underline,
                        color: darkBlue,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w400),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

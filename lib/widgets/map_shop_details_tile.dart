// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:locasma/common/styles.dart';
import 'package:locasma/widgets/custom_button.dart';

class MapShopDetailTile extends StatelessWidget {
  final VoidCallback? onAddBtnTap;
  final image,
      name,
      memo,
      distance,
      rank,
      location,
      views,
      businessHour,
      purchasedDate;
  const MapShopDetailTile(
      {Key? key,
      this.image,
      this.name,
      this.memo,
      this.distance,
      this.rank,
      this.location,
      this.onAddBtnTap,
      this.views,
      this.businessHour,
      this.purchasedDate})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 26.0, bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
          const SizedBox(
            height: 10.0,
          ),
          //Views and Ratings & PurchasedDate
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "noOfViews".tr,
                    style: greyLight14,
                  ),
                  RichText(
                    text: TextSpan(
                      text: views,
                      style: darkGrey28Deco,
                      children: <TextSpan>[
                        TextSpan(text: "PV", style: darkGrey20Deco),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 18.0,
                  ),
                  Text(
                    'purchaseDate'.tr,
                    style: greyLight14,
                  ),
                  const SizedBox(
                    height: 2.0,
                  ),
                  Text(
                    purchasedDate,
                    style: grey16,
                  )
                ],
              ),
              const Spacer(),
              Column(
                children: [
                  Text("rank".tr, style: greyLight14),
                  const SizedBox(
                    height: 10.0,
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100.0),
                    child: Container(
                      height: 73.0,
                      width: 73.0,
                      alignment: Alignment.center,
                      color: const Color(0xffB4A87D),
                      child: Text(
                        rank,
                        style: white40,
                      ),
                    ),
                  ),
                ],
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
          const SizedBox(
            height: 13.0,
          ),
          //Address
          Text(
            "address".tr,
            style: const TextStyle(
                fontSize: 12.0, color: lightGrey, fontWeight: FontWeight.w400),
          ),
          Text(
            location,
            style: grey16,
          ),
          const SizedBox(
            height: 20.0,
          ),
          //Distance
          Text(
            "distance".tr,
            style: const TextStyle(
                fontSize: 12.0, color: lightGrey, fontWeight: FontWeight.w400),
          ),
          Text(
            distance,
            style: grey16,
          ),
          const SizedBox(
            height: 20.0,
          ),
          //Purchased Date
          Text(
            "purchaseDate".tr,
            style: const TextStyle(
                fontSize: 12.0, color: lightGrey, fontWeight: FontWeight.w400),
          ),
          Text(
            purchasedDate,
            style: grey16,
          ),
          const SizedBox(
            height: 20.0,
          ),
          //Memo
          Text(
            "memo".tr,
            style: const TextStyle(
                fontSize: 12.0, color: lightGrey, fontWeight: FontWeight.w400),
          ),
          Text(
            memo,
            style: grey16,
          ),
        ],
      ),
    );
  }
}

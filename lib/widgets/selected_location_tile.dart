import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:locasma/common/styles.dart';

class SelectedLocationTile extends StatefulWidget {
  final String? locationName;
  // ignore: prefer_typing_uninitialized_variables
  final locationLogo;
  final VoidCallback? onTap;
  const SelectedLocationTile(
      {Key? key,
      this.locationName,
      this.locationLogo,
      this.onTap,})
      : super(key: key);

  @override
  State<SelectedLocationTile> createState() => _SelectedLocationTileState();
}

class _SelectedLocationTileState extends State<SelectedLocationTile> {
  bool value = false;
  @override
  Widget build(BuildContext context) {
    return  Container(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0),
        height: 50,
        color: listSubTileCol,
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: CachedNetworkImage(
                imageUrl: widget.locationLogo,
                height: 35.0,
                width: 35.0,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(
              width: 25.0,
            ),
            Text(
              widget.locationName!.tr,
              style: darkGrey16w700
            ),
            const Spacer(),
            GestureDetector(
              onTap: widget.onTap,
              child: const Icon(Icons.delete, color: pink, size: 20,))
          ],
        ),
      );
  }
}

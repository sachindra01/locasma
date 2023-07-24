import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:locasma/common/styles.dart';

class RankingCategoryTile extends StatefulWidget {
  final String? categoryName;
  // ignore: prefer_typing_uninitialized_variables
  final image;
  final VoidCallback? onTap;
  const RankingCategoryTile(
      {Key? key,
      this.categoryName,
      this.image,
      this.onTap,})
      : super(key: key);

  @override
  State<RankingCategoryTile> createState() => _RankingCategoryTileState();
}

class _RankingCategoryTileState extends State<RankingCategoryTile> {
  bool value = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
          height: 50,
          color: listSubTileCol,
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: CachedNetworkImage(
                  imageUrl: widget.image,
                  height: 18.0,
                  width: 18.0,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(
                width: 8.0,
              ),
              Text(
                widget.categoryName!.tr,
                style: darkGrey16w700
              ),
              const Spacer(),
              const Icon(Icons.arrow_forward_ios_rounded, color: pink, size: 20,)
            ],
          ),
        ),
      ),
    );
  }
}

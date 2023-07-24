import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:locasma/common/styles.dart';

class ShopCategoryTile extends StatefulWidget {
  final String? categoryName;
  // ignore: prefer_typing_uninitialized_variables
  final image, checkBoxColor, checkBoxBorderCol, textColor;
  final Widget? checkbox;
  final VoidCallback? onTap;
  const ShopCategoryTile(
      {Key? key,
      this.categoryName,
      this.image,
      this.onTap,
      this.checkBoxColor,
      this.textColor,
      this.checkBoxBorderCol, this.checkbox})
      : super(key: key);

  @override
  State<ShopCategoryTile> createState() => _ShopCategoryTileState();
}

class _ShopCategoryTileState extends State<ShopCategoryTile> {
  bool value = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          padding: const EdgeInsets.only(left: 32.0),
          height: 50,
          color: listSubTileCol,
          child: Row(
            children: [
              SizedBox(
                width: 16.0,
                child: Stack(
                  children: [
                    const Center(
                      child: VerticalDivider(
                        endIndent: 0,
                        indent: 0,
                        thickness: 2,
                        color: Color(0xffF0F0F0),
                      ),
                    ),
                    Center(
                      child: Container(
                        height: 16.0,
                        width: 16.0,
                        decoration: BoxDecoration(
                            color: widget.checkBoxColor,
                            borderRadius: BorderRadius.circular(5.0),
                            border: Border(
                              top: BorderSide(
                                  width: 1, color: widget.checkBoxBorderCol),
                              left: BorderSide(
                                  width: 1, color: widget.checkBoxBorderCol),
                              right: BorderSide(
                                  width: 1, color: widget.checkBoxBorderCol),
                              bottom: BorderSide(
                                  width: 1, color: widget.checkBoxBorderCol),
                            )),
                        child: const Center(
                            child: Icon(
                          Icons.check,
                          size: 15.0,
                          color: white,
                        )),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                width: 18.0,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: CachedNetworkImage(
                  imageUrl: widget.image,
                  height: 16.0,
                  width: 16.0,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(
                width: 12.0,
              ),
              Text(
                widget.categoryName!.tr,
                style: TextStyle(
                    fontSize: 16.0,
                    color: widget.textColor,
                    fontWeight: FontWeight.w700),
              ),
              const SizedBox(
                width: 12.0,
              ),
              Center(child: widget.checkbox)
            ],
          ),
        ),
      ),
    );
  }
}

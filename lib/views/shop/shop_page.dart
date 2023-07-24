import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:locasma/common/styles.dart';
import 'package:locasma/controller/map_controller.dart';
import 'package:locasma/controller/shop_controller.dart';
import 'package:locasma/widgets/custom_button.dart';
import 'package:locasma/widgets/shop_category_tile.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class Shop extends StatefulWidget {
  const Shop({Key? key}) : super(key: key);

  @override
  State<Shop> createState() => _ShopState();
}

class _ShopState extends State<Shop> {
  final ShopController _con = Get.put(ShopController());
    // ignore: unused_field
  final MapController mpcon = Get.put(MapController());
  
  //list for  adding selected list
  List selected = [];

  Map<String, dynamic>? changeColor;

  //change page countwise
  var count = 0; 

  @override
  void initState() {
    initialiseData();
    super.initState();
  }

  initialiseData() async {
    await _con.readJson();
    _con.isChecked= List<bool>.filled(_con.items.length, false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: GetBuilder(
            init: ShopController(),
            builder: (_) {
              return Obx(
                () => _con.isLoading.value == true
                ? SizedBox(
                  height: MediaQuery.of(context).size.height - kToolbarHeight,
                  child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                )
                : _con.items.isEmpty ?
                SizedBox(
                  height: MediaQuery.of(context).size.height - kToolbarHeight,
                  child: const Center(
                    child: Text("No Data at the moment"),
                  ),
                ) : StickyHeader(
                    header:
                        Container(
                            padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0,),
                            decoration:  BoxDecoration(
                                color: navbarColor,
                                boxShadow: [
                                  BoxShadow(
                                      color: count == 0 ? 
                                      const Color.fromARGB(255, 212, 212, 212) : 
                                      const Color.fromARGB(223, 96, 96, 97) ,
                                      offset: count == 0 ?  const Offset(0, 5) : const Offset(0, 3),
                                      blurRadius: count == 0 ? 8 : 5
                                  )
                                ]
                            ),
                            child: 
                              //Header
                              count == 0 ? searchBar() : choiceNumber()
                        ),
                    content:
                        //ListView
                        count == 0 ? allList() : chosenList()
                ),
              );
            }
          ),
        ),
      )
    );
  }


//Hearder first view searchbar
  Widget searchBar() {
    return Container(
      height: 40.0,
      decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.circular(20.0),
          border: const Border(
            top: BorderSide(width: 1.0, color: textFieldBorder),
            left: BorderSide(width: 1.0, color: textFieldBorder),
            right: BorderSide(width: 1.0, color: textFieldBorder),
            bottom: BorderSide(width: 1.0, color: textFieldBorder),
          )
      ),
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
                  style: const TextStyle(color: white, fontSize: 16),
                ),
              ),
            ),
            hintText: 'searchByStoreName'.tr,
            hintStyle:
                const TextStyle(color: lightGrey, fontSize: 16.0, height: 1.16),
            border: InputBorder.none
        ),
      ),
    );
  }


//ListView first view all list from json list
  Widget allList() {
    return SizedBox(
      height: MediaQuery.of(context).size.height - 207,
      child: Stack(
        children: [
          //list of all choices
          SingleChildScrollView(
            child: Column(
              children: [
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _con.items.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: const BoxDecoration(
                                color: navbarColor,
                                boxShadow: [
                                  BoxShadow(
                                      color:
                                      Color.fromARGB(255, 228, 228, 228),
                                      blurRadius: 1.0
                                  )
                                ]
                      ),
                      child: ExpansionTile(
                          backgroundColor: listTileColor,
                          collapsedBackgroundColor: listTileColor,
                          collapsedIconColor: darkGrey,
                          tilePadding: const EdgeInsets.only(right: 16.0, left: 8.0),
                          title: Row(
                            children: [
                              Text(
                                _con.items[index]["name"],
                                style: TextStyle(
                                  color: _con.isChecked![index] ? pink : darkGrey, 
                                  fontSize: 18.0, 
                                  fontWeight: FontWeight.w700
                                ),
                              ),
                              const Spacer(),
                              Container(
                                  padding: const EdgeInsets.all(5.0),
                                  width: 26.0,
                                  height: 26.0,
                                  decoration: const BoxDecoration(
                                              color: darkBlue,
                                              borderRadius: BorderRadius.all(Radius.circular(100))
                                  ),
                                  child: Text(
                                          _con.items[index]["items"].length.toString(),
                                          style: white11,
                                          textAlign: TextAlign.center,
                                  ),
                              ),
                            ],
                          ),
                          leading: Checkbox(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                            checkColor: white,
                            activeColor: pink,
                            side: const BorderSide(color: grey, width: 2.0),
                            value: _con.isChecked![index],
                            onChanged: (val) {
                              setState(() {
                               _con.isChecked![index] = val!;
                                if (val == true) {
                                  selected.add(_con.items[index]);
                                } else {
                                  selected.remove(_con.items[index]);
                                }
                              });
                            },
                          ),
                          children: List.generate(
                            _con.items[index]["items"].length,
                            ((idx) => SizedBox(
                                  height: 50,
                                  child: ShopCategoryTile(
                                    image: _con.items[index]["image"],
                                    categoryName: _con.items[index]["items"][idx]["name"],
                                    onTap: () {
                                      setState(() {
                                        changeColor = _con.items[index]["items"][idx];
                                      });
                                    },
                                    checkBoxColor:
                                        changeColor == _con.items[index]["items"][idx]
                                            ? pink
                                            : white,
                                    textColor:
                                        changeColor == _con.items[index]["items"][idx]
                                            ? pink
                                            : darkGrey,
                                    checkBoxBorderCol:
                                        changeColor == _con.items[index]["items"][idx]
                                            ? pink
                                            : const Color(0xffDDDDDD),
                          // checkbox:Checkbox(
                          //   shape: RoundedRectangleBorder(
                          //     borderRadius: BorderRadius.circular(6.0),
                          //   ),
                          //   checkColor: white,
                          //   activeColor: pink,
                          //   side: const BorderSide(color: grey, width: 2.0),
                          //   value: _isChecked2![index],
                          //   onChanged: (val) {
                          //     setState(() {
                          //       _isChecked2![index] = val!;
                          //       if (val == true) {
                          //         selected.add(_items[index]);
                          //       } else {
                          //         selected.remove(_items[index]);
                          //       }
                          //     });
                          //   },
                          // ),         
                                  ),
                            )),
                          )
                      ),
                    );
                  },
                ),
                const SizedBox(height: 90.0,)
              ],
            ),
          ),

          //button
          Container(
            alignment: Alignment.bottomRight,
            padding: EdgeInsets.only(
              right: MediaQuery.of(context).size.width * 0.03, 
              bottom: MediaQuery.of(context).size.height * 0.022
            ),
            child: Stack(
              alignment: AlignmentDirectional.topEnd,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: CustomButton(
                     btnColor: pink,
                      height: 56.0,
                      width: 231.46,
                      label: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.menu_outlined,
                            size: 28.0,
                          ),
                          const SizedBox(
                            width: 4.0,
                          ),
                          Text(
                            'selectedList'.tr,
                            style: const TextStyle(
                                color: white,
                                fontSize: 22.0,
                                fontWeight: FontWeight.w700,
                                height: 1.5),
                          )
                        ],
                      ),
                      onPress: () {
                        setState(() {
                          if(count == 0){
                            count ++;
                          }
                        });
                      }
                  ),
                ),
                Container(
                    padding: const EdgeInsets.all(6.0),
                    width: 30.0,
                    height: 30.0,
                    decoration: const BoxDecoration(
                        color: darkBlue,
                        borderRadius: BorderRadius.all(Radius.circular(100))
                    ),
                    child: Text(
                        selected.length.toString(),
                        style: const TextStyle(color: white, fontSize: 15.0, fontWeight: FontWeight.w700),
                        textAlign: TextAlign.center,
                    ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


//Header second view number of chosen items from json list
  Widget choiceNumber() {
    return Row(
      children: [
        const SizedBox(width: 12.0,),
        GestureDetector(
          onTap: () {
                  setState(() {
                    if(count == 1){
                      count --;
                    }
                  });
          },
          child: const Icon(
            Icons.arrow_back_ios,
            size: 25.0,
            color: darkBlue,
          ),
        ),
        const SizedBox(
          width: 85,
        ),
        RichText(
            text: TextSpan(
                text: 'noOfChoices'.tr,
                style: const TextStyle(
                    color: darkBlue, fontSize: 20.0, fontWeight: FontWeight.w700),
                children: [
                  TextSpan(
                    text: selected.length.toString(), // list.length
                    style: const TextStyle(
                      color: darkBlue,
                      fontSize: 40.0,
                      fontWeight: FontWeight.w700,
                      decoration: TextDecoration.underline),
                  )
                ]
            )
        )
      ],
    );
  }


//ListView second view chosen items from json list
  Widget chosenList() {
    return SizedBox(
      height: MediaQuery.of(context).size.height - 207,
      child: ListView.builder(
        itemCount: selected.length,
        itemBuilder: ((context, index) =>
          Column(
            children: [
            Container(
                height: 30.0,
                width: double.infinity,
                color: darkBlue,
                padding: const EdgeInsets.only(left: 20.0, bottom: 3.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(selected[index]['name'], 
                  style: white14,)
                ),
            ),
            ListView.builder(
                itemCount: selected.length,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: ((context, idx) =>
                    Slidable(
                      key: const ValueKey(0),
                      endActionPane:  ActionPane(
                        dismissible: DismissiblePane(onDismissed: () {}),
                        motion: const ScrollMotion(),
                        children: [
                          SlidableAction(
                            onPressed: (context) { },
                            backgroundColor: const Color(0xFFF4726A),
                            foregroundColor: Colors.white,
                            label: 'delete'.tr,
                          ),
                        ],
                      ),
                      child: Container(
                        height: 56.0,
                        margin: const EdgeInsets.only(bottom: 1.0),
                        padding: const EdgeInsets.only(left: 20.0),
                        decoration: const BoxDecoration(
                        color: listTileColor,
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromARGB(255, 243, 243, 243) ,
                            spreadRadius: 2.0
                          )
                        ]
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: CachedNetworkImage(
                                imageUrl: selected[index]['image'],
                                height: 16,
                                width: 16,
                                fit: BoxFit.cover,
                                 ),
                              ),
                              const SizedBox(width: 12.0,),
                              Text(
                                selected[index]['name'], 
                                style: darkGrey18,
                              ),
                            ],
                          )
                        ),
                      )
                    )
                )
            ),
            ],
          )
        )
      ),
    );
  }
}

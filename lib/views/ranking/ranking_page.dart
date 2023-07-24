
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:locasma/common/styles.dart';
import 'package:locasma/controller/ranking_controller.dart';
import 'package:locasma/controller/shop_controller.dart';
import 'package:locasma/widgets/custom_alert_dialogbox.dart';
import 'package:locasma/widgets/ranking_category_tile.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

class RankingPage extends StatefulWidget {
  const RankingPage({Key? key}) : super(key: key);

  @override
  State<RankingPage> createState() => _RankingPageState();
}

class _RankingPageState extends State<RankingPage> {
  final RankingController _con = Get.put(RankingController());
  final ShopController shoplist =Get.put(ShopController());

  //to change page with condition
  bool nameNotSpecified = false;
  bool provinceNotSpecified = false;

  //to chnage color of time week month button
  String? dateAndTime;

  //list of bool value in index for checkbox
  List<bool>? _isChecked; 
  List<bool>? _isChecked2; 

  Map<String, dynamic>? changeColor;

  @override
  void initState() {
    dateAndTime = "time";
    initialiseData();
    super.initState();
  }


  initialiseData() async {
    await _con.readJson();
    await shoplist.readJson();
    _isChecked = List<bool>.filled(_con.rankList.length, false);
    _isChecked2 = List<bool>.filled(shoplist.items.length, false);
  }

  
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return  Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: GetBuilder(
            init: RankingController(),
            builder: (_) {
              return Obx(
            () => _con.isLoading.value == true
                ? SizedBox(
                  height: size.height - kToolbarHeight,
                  child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                )
                : _con.rankList.isEmpty ?
                SizedBox(
                  height: size.height - kToolbarHeight,
                  child: const Center(
                    child: Text("No Data at the moment"),
                  ),
                ) :
                 StickyHeader(
                  header: Column(
                    children: [
                       //header
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12.0),
                        color: navbarColor,
                        child: Column(
                          children: [
                            const Icon(FontAwesomeIcons.crown,color: darkBlue, size: 34.0,),
                            const SizedBox(height: 4.0,),
              
                            nameNotSpecified == true && provinceNotSpecified == true ? 
                                GestureDetector(
                                  onTap: (){
                                    CustomAlertDialogueBox().customDialogue(
                                      context, 
                                      Text("perfectualRanking".tr, style: darkBlue18,), 
                                      bothSeletedDialogBox(),
                                    );
                                  },
                                  child: Text("Starbuck / Tokyo", style: darkBlue24,)
                                )
                                :
                            nameNotSpecified == true ? 
                                GestureDetector(
                                  onTap: (){
                                    leftSelectedDialogBox();
                                  },
                                  child: Text("starbucks".tr , style: darkBlue24,)
                                )
              
                            : provinceNotSpecified == true ? 
                                GestureDetector(
                                  onTap: (){
                                    CustomAlertDialogueBox().customDialogue(
                                      context, 
                                      Text("perfectualRanking".tr, style: darkBlue18,), 
                                      rightSelectedDialogBox(),
                                    );
                                  },
                                  child: Text("tokyo".tr, style: darkBlue24,)
                                )
              
              
                            : GestureDetector(
                                onTap: (){
                                  nothingSelectedDialogBox();
                                },
                                child: Text("overallRanking".tr,  style: darkBlue24,)
                              ),
              
                            const SizedBox(height: 6.0,),
                            const Divider(
                              color: Color(0xffDDDDDD),
                              endIndent: 0.0,
                              indent: 0.0,
                              thickness: 1.0,
                            ),
                            const SizedBox(height: 4.0,),
                            Text("2022年1月4日", style: darkBlue16w500,),
                            const SizedBox(height: 10.0,),
                            Container(
                              height: 28.0,
                              width: 159.0,
                              decoration: const BoxDecoration(
                                      color: Color(0xffFCF4F5),
                                      borderRadius: BorderRadius.all(Radius.circular(20)),
                                      border:  Border(
                                          top: BorderSide(width: 1, color: Color(0xffF8DFE2)),
                                          left: BorderSide(width: 1, color: Color(0xffF8DFE2)),
                                          right: BorderSide(width: 1, color: Color(0xffF8DFE2)),
                                          bottom: BorderSide(width: 1, color: Color(0xffF8DFE2)),
                                      )
                              ),


                              //time and date buttons
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  GestureDetector(
                                    onTap: (){
                                      setState(() {
                                        dateAndTime = "time";
                                      });
                                    },
                                    child: Container(
                                        height: 28.0,
                                        width: 52.0,
                                        decoration:  BoxDecoration(
                                        color: dateAndTime == "time" ? pink : const Color(0xffFCF4F5),
                                        borderRadius: const BorderRadius.all(Radius.circular(20))
                                        ),
                                        child: Center(
                                                child: Text("time".tr, 
                                                      style: dateAndTime == "time" ? white14w400 : pink14w400,
                                                )
                                        )
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: (){
                                      setState(() {
                                        dateAndTime = "week";
                                      });
                                    },
                                    child: Container(
                                        height: 28.0,
                                        width: 52.0,
                                        decoration: BoxDecoration(
                                        color: dateAndTime == "week" ? pink : const Color(0xffFCF4F5),
                                        borderRadius: const BorderRadius.all(Radius.circular(20))
                                        ),
                                        child: Center(
                                                child: Text("week".tr, 
                                                      style: dateAndTime == "week" ? white14w400 : pink14w400,
                                                )
                                        )
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: (){
                                      setState(() {
                                        dateAndTime = "month";
                                      });
                                    },
                                    child: Container(
                                        height: 28.0,
                                        width: 52.8,
                                        decoration: BoxDecoration(
                                        color: dateAndTime == "month" ? pink : const Color(0xffFCF4F5),
                                        borderRadius: const BorderRadius.all(Radius.circular(20))
                                        ),
                                        child: Center(
                                                child: Text("month".tr, 
                                                      style: dateAndTime == "month" ? white14w400 : pink14w400,
                                                )
                                        )
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
              
              
                      //tab buttons
                      Row(
                        children: [
                          //tab button1
                          GestureDetector(
                            onTap: (){
                              setState(() {
                                nameNotSpecified = !nameNotSpecified;
                              });
                            },
                            child: Container(
                              height: 40.0,
                              width: size.width / 2.004,
                              decoration:  BoxDecoration(
                                color:  nameNotSpecified == true ? pink : listTileColor,
                                boxShadow: const[
                                        BoxShadow(
                                            color:
                                            Color.fromARGB(255, 228, 228, 228),
                                            offset: Offset(0, 5.0),
                                            blurRadius: 15.0
                                        )
                                      ]
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(FontAwesomeIcons.slidersH, color: nameNotSpecified == true ? white : pink, size: 15,),
                                  const SizedBox(width: 8,),
                                  SizedBox(
                                    width:size.width / 3.4 ,
                                    child: FittedBox(
                                      child: Text('storeNameNotSpecified'.tr, 
                                        style: nameNotSpecified == true ? white14w400 : pink14w400,
                                      ),
                                    ),
                                  )
                                ],
                              )
                            ),
                          ),                 
                          
                          Container(width: 0.5, height: 40.0, color: white,),               
                          
                          //tab button 2
                          GestureDetector(
                            onTap: (){
                              setState(() {
                                provinceNotSpecified = !provinceNotSpecified;
                              });
                            },
                            child: Container(
                              height: 40.0,
                              width: size.width / 2.004,
                              decoration:  BoxDecoration(
                                color:  provinceNotSpecified == true ? pink : listTileColor,
                                boxShadow: const [
                                        BoxShadow(
                                            color:
                                            Color.fromARGB(255, 228, 228, 228),
                                            offset: Offset(7.0, 5.0),
                                            blurRadius: 15.0
                                        )
                                      ]
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(FontAwesomeIcons.slidersH, color: provinceNotSpecified == true ? white : pink, size: 15,),
                                  const SizedBox(width: 8,),
                                  SizedBox(
                                    width: size.width / 3.0 ,
                                    child: FittedBox(
                                      child: Text('storeProviceNotSpecified'.tr, 
                                            style:  provinceNotSpecified == true ? white14w400 : pink14w400,
                                      ),
                                    ),
                                  )
                                ],
                              )
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
              
              
                  content: Column(
                    children: [
                      //Ranking List top3 
                        Container(
                            padding: const EdgeInsets.only( top: 9.0, bottom: 12.0),
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: 1,
                              itemBuilder: ((context, index) =>
                              _con.rankList.isEmpty ? const SizedBox() :
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                  SizedBox(
                                    width: size.width / 3,
                                    child: Column(
                                        children: [
                                            const Icon(FontAwesomeIcons.crown, 
                                            color: Color(0xffB5C2C8), 
                                            size: 18,),
                                            const SizedBox(height: 2,),
                                            CircleAvatar(
                                              radius: 43.0,
                                              backgroundColor: const Color(0xffB5C2C8),
                                              child: ClipRRect(
                                                      borderRadius: BorderRadius.circular(100),
                                                      child:  CachedNetworkImage(
                                                      imageUrl: _con.rankList[1]['image'],
                                                      height: 80.0,
                                                      width: 80.0,
                                                      fit: BoxFit.cover,
                                                      ),
                                              )
                                            ),
                                            const SizedBox(height: 8.0),
                                            ClipRRect(
                                              borderRadius: BorderRadius.circular(100.0),
                                              child: Container(
                                                height: 28.0,
                                                width: 28.0,
                                                alignment: Alignment.center,
                                                color: const Color(0xffB5C2C8),
                                                child: const Text("2",
                                                  style: TextStyle(fontSize: 20, color: white, 
                                                                   fontWeight: FontWeight.w700
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 8.0,),
                                            Text(_con.rankList[1]['name'], style: black14, textAlign: TextAlign.center),
                                            Text(_con.rankList[1]['location'], 
                                                        style: black14,
                                                        textAlign: TextAlign.center),
                                            const SizedBox(height: 4.0,),
                                            RichText(
                                              text: TextSpan(
                                                text: _con.rankList[1]['views'],
                                                style: darkGrey20w700,
                                                children: <TextSpan>[
                                                  TextSpan(text: " PV", style: darkGrey16w700),
                                                ],
                                              ),
                                            ),
                                        ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: size.width / 3,
                                    child: Column(
                                        children: [
                                            const Icon(FontAwesomeIcons.crown, 
                                            color: Color(0xffCCB647), 
                                            size: 22,),
                                            const SizedBox(height: 2,),
                                            CircleAvatar(
                                              radius: 51.0,
                                              backgroundColor: const Color(0xffCCB647),
                                              child: ClipRRect(
                                                      borderRadius: BorderRadius.circular(100),
                                                      child:  CachedNetworkImage(
                                                      imageUrl: _con.rankList[0]['image'],
                                                      height: 95.0,
                                                      width: 95.0,
                                                      fit: BoxFit.cover,
                                                      ),
                                              )
                                            ),
                                            const SizedBox(height: 8.0,),
                                            ClipRRect(
                                              borderRadius: BorderRadius.circular(100.0),
                                              child: Container(
                                                height: 28.0,
                                                width: 28.0,
                                                alignment: Alignment.center,
                                                color: const Color(0xffCCB647),
                                                child: const Text("1",
                                                  style: TextStyle(fontSize: 20, color: white, 
                                                                   fontWeight: FontWeight.w700
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 8.0,),
                                            Text(_con.rankList[0]['name'], style: black14, textAlign: TextAlign.center),
                                            Text(_con.rankList[0]['location'], style: black14, textAlign: TextAlign.center),
                                            const SizedBox(height: 4.0,),
                                            RichText(
                                              text: TextSpan(
                                                text: _con.rankList[0]['views'],
                                                style: darkGrey20w700,
                                                children: <TextSpan>[
                                                  TextSpan(text: " PV", style: darkGrey16w700),
                                                ],
                                              ),
                                            ),
                                        ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: size.width / 3,
                                    child: Column(
                                        children: [
                                            const Icon(FontAwesomeIcons.crown, 
                                            color: Color(0xffAC785A), 
                                            size: 18,),
                                            const SizedBox(height: 2,),
                                            CircleAvatar(
                                              radius: 43.0,
                                              backgroundColor: const Color(0xffAC785A),
                                              child: ClipRRect(
                                                      borderRadius: BorderRadius.circular(100),
                                                      child:  CachedNetworkImage(
                                                      imageUrl: _con.rankList[2]['image'],
                                                      height: 80.0,
                                                      width: 80.0,
                                                      fit: BoxFit.cover,
                                                      ),
                                              )
                                            ),
                                            const SizedBox(height: 8.0,),
                                            ClipRRect(
                                              borderRadius: BorderRadius.circular(100.0),
                                              child: Container(
                                                height: 28.0,
                                                width: 28.0,
                                                alignment: Alignment.center,
                                                color: const Color(0xffAC785A),
                                                child: const Text("3",
                                                  style: TextStyle(fontSize: 20, color: white, 
                                                                   fontWeight: FontWeight.w700
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 8.0,),
                                            Text(_con.rankList[2]['name'], style: black14, textAlign: TextAlign.center),
                                            Text(_con.rankList[2]['location'], style: black14, textAlign: TextAlign.center),
                                            const SizedBox(height: 4.0,),
                                            RichText(
                                              text: TextSpan(
                                                text: _con.rankList[2]['views'],
                                                style: darkGrey20w700,
                                                children: <TextSpan>[
                                                  TextSpan(text: " PV", style: darkGrey16w700),
                                                ],
                                              ),
                                            ),
                                        ],
                                    ),
                                  ),
                                  ],
                                )
                              )
                            ),
                        ),
                    
                         //Ranking List below 3
                         SizedBox(
                            child: ListView.builder(
                                      itemCount: _con.rankList.length - 3,
                                      physics: const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemBuilder: ((context, idx) =>
                                          Container(
                                              height: 56.0,
                                              margin: const EdgeInsets.only(bottom: 1.0),
                                              padding: const EdgeInsets.only(left: 12.0, right: 10.0),
                                              decoration: const BoxDecoration(
                                              color: listTileColor,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Color.fromARGB(255, 243, 243, 243) ,
                                                  spreadRadius: 2.0
                                                )
                                              ]
                                              ),
                                              child: Row(
                                                children: [
                                                  SizedBox(
                                                    width: 22,
                                                    child: Text((idx + 4).toString(), style: black18,)),
                                                  const SizedBox(width: 15,),                                              ClipRRect(
                                                    borderRadius: BorderRadius.circular(100),
                                                    child: CachedNetworkImage(
                                                    imageUrl: _con.rankList[idx + 3]['image'],
                                                    height: 22,
                                                    width: 22,
                                                    fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 12.0,),
                                                  Text(
                                                    _con.rankList[idx + 3]['name'], 
                                                    style: black16,
                                                  ),
                                                  const SizedBox(width: 10,),
                                                  SizedBox(
                                                    width: size.height * 0.1,
                                                    child: Text(_con.rankList[idx + 3]['location'], 
                                                    style: black14,
                                                    overflow: TextOverflow.ellipsis, 
                                                    ),
                                                  ),
                                                  const Spacer(),
                                                  RichText(
                                                    text: TextSpan(
                                                      text: _con.rankList[idx + 3]['views'],
                                                      style: darkGrey16w700,
                                                      children: <TextSpan>[
                                                        TextSpan(text: " PV", style: darkGrey12w700),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                      )
                                  ),
                        )
                    ],
                  ),
                ),
              );
            }
          ),
        )
      )
    );
  }

  nothingSelectedDialogBox() {
    return showDialog(
      context: context,
      builder: (context) => Stack(
        children: [
          StatefulBuilder(
            builder: (context, setState) {
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
                            child: Text("storeRanking".tr, style: darkBlue18,), 
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
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.60,
                    child: ListView.builder(
                          itemCount: _con.rankList.length,
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
                                        _con.rankList[index]["name"],
                                        style: TextStyle(
                                          color: _isChecked![index] ? pink : darkGrey, 
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
                                                  _con.rankList[index]["items"].length.toString(),
                                                  style: white11,
                                                  textAlign: TextAlign.center,
                                          ),
                                      ),
                                    ],
                                  ),
                                  leading:  Checkbox(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6.0),
                                    ),
                                    checkColor: white,
                                    activeColor: pink,
                                    side: const BorderSide(color: grey, width: 2.0),
                                    value: _isChecked![index],
                                    onChanged: (val) {
                                      setState(() {
                                      _isChecked![index] = val!;
                                      });
                                    },
                                  ),
                                  children: List.generate(
                                    _con.rankList[index]["items"].length,
                                    ((idx) => SizedBox(
                                          height: 50,
                                          child: RankingCategoryTile(
                                            image: _con.rankList[index]["image"],
                                            categoryName: _con.rankList[index]["items"][idx]["name"],
                                            onTap: () {
                                            },        
                                          ),
                                    )),
                                  )
                              ),
                            );
                          },
                        ),
                  ),
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

  leftSelectedDialogBox() {
    return showDialog(
      context: context,
      builder: (context) => Stack(
        children: [
          StatefulBuilder(
            builder: (context, setState) {
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
                            child: Text("storeRanking".tr, style: darkBlue18,),
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
                  Container(
                    height: MediaQuery.of(context).size.height * 0.065,
                    color: pink,
                    padding: const EdgeInsets.only(right: 16.0, left: 16.0),
                    child: Row(
                      children: [
                        Text("starbucks".tr, style: white16,),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            shoplist.items.clear();
                          },
                          child: const Icon(Icons.clear, color: white,)
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.535,
                    child: ListView.builder(
                    itemCount: shoplist.items.length,
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
                                  shoplist.items[index]["name"],
                                  style: TextStyle(
                                    color: _isChecked2![index] ? pink : darkGrey, 
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
                                            shoplist.items[index]["items"].length.toString(),
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
                              value: _isChecked2![index],
                              onChanged: (val) {
                                setState(() {
                                _isChecked2![index] = val!;
                                });
                              },
                            ),
                            children: List.generate(
                              shoplist.items[index]["items"].length,
                              ((idx) => SizedBox(
                                    height: 50,
                                    child: RankingCategoryTile(
                                      image: shoplist.items[index]["image"],
                                      categoryName:shoplist.items[index]["items"][idx]["name"],
                                      onTap: () {
                                      },        
                                    ),
                              )),
                            )
                        ),
                      );
                    },
                    ),
                  ),
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

  Widget rightSelectedDialogBox() {
    return Column(
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.065,
          color: pink,
          padding: const EdgeInsets.only(right: 16.0, left: 16.0),
          child: Row(
            children: [
              Text("tokyo".tr, style: white16,),
              const Spacer(),
              const Icon(Icons.clear, color: white,)
            ],
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.535,
          child: ListView.builder(
              itemCount: _con.rankList.length,
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
                        child: Text(_con.rankList[index]['name'], 
                        style: white14,)
                      ),
                  ),
                  ListView.builder(
                      itemCount: _con.rankList.length,
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
                                  backgroundColor: const Color(0xFFFE4A49),
                                  foregroundColor: Colors.white,
                                  icon: Icons.delete,
                                  label: 'Delete',
                                ),
                              ],
                            ),
                            child: Container(
                              height: 56.0,
                              margin: const EdgeInsets.only(bottom: 1.0),
                              padding: const EdgeInsets.only(left: 16.0, right: 17.0),
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
                                      imageUrl: _con.rankList[index]['image'],
                                      height: 16,
                                      width: 16,
                                      fit: BoxFit.cover,
                                       ),
                                    ),
                                    const SizedBox(width: 12.0,),
                                    Text(
                                      _con.rankList[index]['name'], 
                                      style: darkGrey18,
                                    ),
                                    const Spacer(),
                                    const Icon(Icons.arrow_forward_ios_rounded, color: pink, size: 20,)
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
        ),
      ],
    );
  }

  Widget bothSeletedDialogBox() {
    return SizedBox(
      height: MediaQuery.of(context).size.height *0.60,
      child: ListView.builder(
          itemCount: _con.rankList.length,
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
                    child: Text(_con.rankList[index]['name'], 
                    style: white14,)
                  ),
              ),
              ListView.builder(
                  itemCount: _con.rankList.length,
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
                              backgroundColor: const Color(0xFFFE4A49),
                              foregroundColor: Colors.white,
                              icon: Icons.delete,
                              label: 'Delete',
                            ),
                          ],
                        ),
                        child: Container(
                          height: 56.0,
                          margin: const EdgeInsets.only(bottom: 1.0),
                          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
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
                                  imageUrl: _con.rankList[index]['image'],
                                  height: 16,
                                  width: 16,
                                  fit: BoxFit.cover,
                                   ),
                                ),
                                const SizedBox(width: 12.0,),
                                Text(
                                  _con.rankList[index]['name'], 
                                  style: darkGrey18,
                                ),
                                const Spacer(),
                                const Icon(Icons.arrow_forward_ios_rounded, color: pink, size: 20,)
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

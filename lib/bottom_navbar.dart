import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:locasma/common/styles.dart';
import 'package:locasma/views/account/account_page.dart';
import 'package:locasma/views/maps/maps_page.dart';
import 'package:locasma/views/ranking/ranking_page.dart';
import 'package:locasma/views/shop/shop_page.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({
    Key? key,
    
    required this.index,
  }) : super(key: key);
  final int index;
  

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _selectedIndex = 0;


  List pages = [
    // shop
    const Shop(),

    // map
    const MapPage(),

    //ranking
    const RankingPage(),

    //account
    const Account(),
  ];

  @override
  void initState() {
    _selectedIndex = widget.index;
    super.initState();
  }

  _handleTap(index) {
    setState(() {
      _selectedIndex = index;
      
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text("doYouWantToExit".tr, style: black18),
                  actions: [
                    TextButton(
                        onPressed: () => SystemNavigator.pop(),
                        child: Text("yes".tr, style: darkBlue16)),
                    TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: Text("no".tr, style: darkBlue16)),
                  ],
                ));
        return true;
      },
      child: Scaffold(
        body: pages[_selectedIndex],
        //BottomNavigation Bar
        bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(
            canvasColor: navbarColor,
          ),
          child: Container(
              decoration: const BoxDecoration(
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Color.fromARGB(255, 207, 207, 207),
                    offset: Offset(0, 0),
                    blurRadius: 10,
                  ),
                ],
              ),
            child: BottomNavigationBar(
              onTap: _handleTap,
              currentIndex: _selectedIndex,
              unselectedItemColor: darkBlue,
              selectedItemColor: darkBlue,
              elevation: 20.0,
              iconSize: 24.0,
              items: <BottomNavigationBarItem>[
                //shop
                BottomNavigationBarItem(
                  icon: Column(
                    children: [
                      const SizedBox(
                        height: 12,
                      ),
                      const Icon(Icons.circle),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        'shops'.tr,
                        style: darkBlue10,
                      ),
                    ],
                  ),
                  label: "",
                ),
                //maps
                BottomNavigationBarItem(
                  icon: Column(
                    children: [
                      const SizedBox(
                        height: 12,
                      ),
                      const Icon(Icons.circle),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        'map'.tr,
                        style: darkBlue10,
                      ),
                    ],
                  ),
                  label: "",
                ),
                //rank
                BottomNavigationBarItem(
                  icon: Column(
                    children: [
                      const SizedBox(
                        height: 12,
                      ),
                      const Icon(Icons.circle),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        'ranking'.tr,
                        style: darkBlue10,
                      ),
                    ],
                  ),
                  label: "",
                ),
                //account
                BottomNavigationBarItem(
                  icon: Column(
                    children: [
                      const SizedBox(
                        height: 12,
                      ),
                      const Icon(Icons.circle),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        'account'.tr,
                        style: darkBlue10,
                      ),
                    ],
                  ),
                  label: "",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

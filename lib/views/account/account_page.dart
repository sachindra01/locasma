// import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
// import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:locasma/common/settings.dart';
// import 'package:locasma/main.dart';
import 'package:locasma/views/auth/sign_in_page.dart';
import 'package:locasma/views/maps/maps_page.dart';
// import 'package:share_plus/share_plus.dart';

class Account extends StatefulWidget {
  const Account({Key? key}) : super(key: key);

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  // var dynamicLinkUrl;

  @override
  void initState() {
    super.initState();
    // initDynamicLinks();
  }

//   void initDynamicLinks() async{
//     FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData) {
//       final Uri? deepLink = dynamicLinkData.link;
//       if(deepLink != null){
//         //The link is handeled here
//         _handleDeepLink(deepLink);
//       }
//      }).onError((error){
//       debugPrint ("Error:" + error);
//      });
//   }

//    void _handleDeepLink(data) {
//    final Uri deepLink = data.link;
//    if (deepLink != null) {
//      print('_handleDeepLink | deeplink: $deepLink');

//      var navigationRoute = deepLink.queryParameters['route'];

//      var params = deepLink.queryParameters['params'];
//      if (params != null) {
//        navigatorKey.currentState!.pushNamed(navigationRoute.toString());
//      }
//    }
//  }

//   buildDynamicLinks(String title,String image,String docId) async {
//     String url = "locasma.page.link";
//     final DynamicLinkParameters parameters = DynamicLinkParameters(
//       uriPrefix: "http://",
//       link: Uri.parse('$url/$docId'),
//       androidParameters: const AndroidParameters(
//         packageName: "com.yig.mi.locasma",
//       ),
//       // iosParameters: IosParameters(
//       //   bundleId: "Bundle-ID",
//       //   minimumVersion: '0',
//       // ),
//       socialMetaTagParameters: SocialMetaTagParameters(
//           description: '',
//           imageUrl:Uri.parse("$image"),
//           title: title),
//     );
//     final shortDymanicLink = await FirebaseDynamicLinks.instance.buildLink(parameters);
//     await Share.share("www.youtube.com");
//   }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                child: const Text('Change language'),
                onPressed: () => changeLocale()
            ),
            ElevatedButton(
                child: const Text('Log Out'),
                onPressed: (){
                  Get.to(()=>const SignIn());
                }
            ),
            ElevatedButton(
                child: const Text('Maps'),
                onPressed: (){
                  Get.to(()=>const MapPage());
                }
            ),
            //  ElevatedButton(
            //     child: const Text('Share'),
            //     onPressed: (){
            //       buildDynamicLinks("Test", "https://climatecommunication.yale.edu/wp-content/uploads/2017/04/001-stone-circle-jpeg-768x350.jpg", "1");
            //     }
            // ),
          ],
        ),
      ),
    );
  }
}


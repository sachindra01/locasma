// import 'dart:html';

// import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

// class DynamicLinkService{
//   Future getDynamicLink() async{
//     //Get initial dynamic link
//     final PendingDynamicLinkData? data = await FirebaseDynamicLinks.instance.getInitialLink();

//     handelDynamicLink(data);

//     FirebaseDynamicLinks.instance.onLink(
//       onSuccess:(PendingDynamicLinkData dynamicLinkData) async{
//         handelDynamicLink(dynamicLinkData);
//       },
//       onError : (Exception e) async{
//         print(e);
//       }
//     );
//   }
// }

// void handelDynamicLink(PendingDynamicLinkData? data) {
//   final Uri deepLink = data!.link;
//   if(deepLink != null)
// }


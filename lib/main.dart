import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:locasma/app_translations.dart';
import 'package:locasma/bottom_navbar.dart';
import 'package:locasma/services/local_notification_service.dart';
import 'package:locasma/views/splash_screen_page.dart';


//get data to app when on background
Future<void> backgroundHandler(RemoteMessage message)async{
  debugPrint(message.data.toString());
  debugPrint(message.notification!.title.toString());
}
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]); 
  runApp(const MyApp());
}

//key for textFieldForm
final formKey = GlobalKey<FormState>();

// This widget is the root of your application.
final navigatorKey = GlobalKey<NavigatorState>();

//object
LocalNotificationService iosNotificationHandler = LocalNotificationService();

class MyApp extends StatefulWidget {
const MyApp({ Key? key }) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    FirebaseMessaging.instance.getInitialMessage().then((message){
      if(message != null){
      final routeFromNotification = message.data["route"];
      // navigatorKey.currentState!.pushNamed(routeFromNotification);
      Navigator.pushNamed(context, routeFromNotification);
      }
    });

    FirebaseMessaging.onMessage.listen((message) {
      debugPrint(message.notification!.title);
      debugPrint(message.notification!.body);
      LocalNotificationService.display(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      final routeFromNotification = message.data["route"];
      navigatorKey.currentState!.pushNamed(routeFromNotification);
      // //To launch link from notification
      // final urlLink = message.data['link'];
      //  launchUrlString(message.data['link']);
    });

    iosNotificationHandler.notificationInitialization();
  }
  
  @override
  Widget build(BuildContext context) {

    //initialize local notification
    LocalNotificationService.initialize(context);
    
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      title: 'Locasma',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(),
      locale: Get.deviceLocale,
      initialRoute: '/',
      routes: {
        "shop": (_)=> const BottomNav(index: 0),
        "maps":(_)=> const BottomNav(index: 1),
        "ranking":(_)=> const BottomNav(index: 2),
        "account":(_)=> const BottomNav(index: 3),
      },
      translations: AppTranslations(),
      fallbackLocale: const Locale('ja'),
    );
  }
}

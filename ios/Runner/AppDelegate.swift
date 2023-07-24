import UIKit
import Flutter
import GoogleMaps
import FirebaseMessagings

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Add your Google Maps API Key here
    GMSServices.provideAPIKey("AIzaSyADwj_v08UkMh6iM5zW7iWT2Ltaoc_XeRE")
    GeneratedPluginRegistrant.register(with: self)
    Messaging.messaging().apnsToken = deviceToken
    return super.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken, didFinishLaunchingWithOptions: launchOptions:[
         if (@available(iOS 10.0, *)) {
            [UNUserNotificationCenter currentNotificationCenter].delegate = (id<UNUserNotificationCenterDelegate>) self;
         if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
            }
    ])
  }
}
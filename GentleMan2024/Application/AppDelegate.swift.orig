//
//  AppDelegate.swift
//  CodeBase
//
//  Created by MohamedSawy on 4/5/24.
//

import UIKit
import GoogleMaps
import Firebase
import FirebaseMessaging
import UserNotifications
import FirebaseRemoteConfig
import netfox
import MFSDK

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    let gcmMessageIDKey = "gcm.message_id"
    var remoteConfig: RemoteConfig!
    override init() {
        super.init()
        UIFont.overrideInitialize()
    }
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        setUpGoogleMap()
        setUpSettings()
        addRootViewController()
        setUpFirebase(application)
        setUpMyFatoorah()
        if UserDefaults.standard.object(forKey: "OnlinePaymentHideStartDate") == nil {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "d/M/yyyy"
            if let specificDate = dateFormatter.date(from: "7/5/2025") {
                UserDefaults.standard.set(specificDate, forKey: "OnlinePaymentHideStartDate")
            }
        }
       
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
<<<<<<< HEAD
        // Fix Me
=======
>>>>>>> 183211bd6ddb422a17b464bff7934d16c7b2d81e
//       setupRemoteConfig()
//       ForceUpdateChecker(listener: self).check()
       NotificationCenter.default.post(name: Notification.Name(rawValue: ""),
                                       object: nil,
                                       userInfo: nil)
   }
}

extension AppDelegate {
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
    }

    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable: Any]) -> UIBackgroundFetchResult {
        return UIBackgroundFetchResult.newData
    }

    func application(_ application: UIApplication,
                      didFailToRegisterForRemoteNotificationsWithError error: Error) {
         print("Unable to register for remote notifications: \(error.localizedDescription)")
     }

     func application(_ application: UIApplication,
                      didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
         Messaging.messaging().apnsToken = deviceToken
     }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        let userInfo = notification.request.content.userInfo
        print(userInfo)
        return [[.banner, .sound]]
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse) async {
        let userInfo = response.notification.request.content.userInfo
        print(userInfo)
    }
}

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        UserDefaultsManager.shared.fcmToken = fcmToken
        let dataDict: [String: String] = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(
            name: Notification.Name("FCMToken"),
            object: nil,
            userInfo: dataDict
        )
    }
}

extension AppDelegate {
    private func setUpFirebase(_ application: UIApplication) {
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        Messaging.messaging().isAutoInitEnabled = true
        
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self

            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: { granted, error in
                    if let error = error {
                        print("Error requesting authorization: \(error.localizedDescription)")
                    } else {
                        DispatchQueue.main.async {
                            application.registerForRemoteNotifications()
                        }
                    }
                }
            )
        } else {
            let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
            application.registerForRemoteNotifications()
        }
    }
    
    private func addRootViewController() {
        window = UIWindow(frame: UIScreen.main.bounds)
        var navigationController = UINavigationController()
        navigationController = MainNavigationController(rootViewController: SplashVC())
        navigationController.navigationBar.isHidden = true
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    private func setUpSettings() {
        UserDefaults.standard.set(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
        NFX.sharedInstance().start()
        AppAppearance.setAppLanguage()
        AppAppearance.setupAppearance()
        AppAppearance.setupKeyboardAppearance()
    }
    
    private func setUpGoogleMap() {
        GMSServices.provideAPIKey(GoogleMapsConstants.apiKey)
    }
    
    private func setUpMyFatoorah() {
        let token = MyFatoorahToken.production.rawValue
        MFSettings.shared.configure(token: token, country: .saudiArabia, environment: .live)
        // you can change color and title of navigation bar
        let them = MFTheme(navigationTintColor: .blue, navigationBarTintColor: .white, navigationTitle: "Payment", cancelButtonTitle: "Cancel")
        MFSettings.shared.setTheme(theme: them)
    }
}

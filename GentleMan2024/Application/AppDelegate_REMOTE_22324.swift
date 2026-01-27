//
//  AppDelegate.swift
//  CodeBase
//
//  Created by MohamedSawy on 4/5/24.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    let appDIContainer = AppDIContainer()
    var appFlowCoordinator: AppFlowCoordinator?
    var window: UIWindow?
    
    override init() {
        super.init()
        UIFont.overrideInitialize()
        
    }
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        AppAppearance.setupAppearance()
        Localizer.DoTheExhange()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = MainNavigationController.init(rootViewController: MainTabbar.setupTabbar())
        window?.makeKeyAndVisible()
        
        
        return true
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }
}

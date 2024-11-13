//
//  AppDelegate.swift
//  GameCenter
//
//  Created by Steven Lie on 16/08/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        func setupRootViewController() {
            window = UIWindow(frame: UIScreen.main.bounds)
            window?.makeKeyAndVisible()
            window?.rootViewController = TabbarController.instance
        }
        
        setupRootViewController()
        
        if UserDefault.name.load() as? String == nil {
            UserDefault.name.save(value: "Steven Lie")
        }
        
        if UserDefault.email.load() as? String == nil {
            UserDefault.email.save(value: "stevenliee1206@gmail.com")
        }

        return true
    }
}

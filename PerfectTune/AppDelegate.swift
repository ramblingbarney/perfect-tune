//
//  AppDelegate.swift
//  PerfectTune
//
//  Copyright © 2020 Conor O'Dwyer. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let controller = BaseViewController()
        let navController = UINavigationController(rootViewController: controller)

        navController.navigationBar.barTintColor = UIColor.black
        navController.navigationBar.isTranslucent = false
        navController.navigationBar.barStyle = .black
        navController.navigationBar.tintColor = .white

        window = UIWindow(frame: UIScreen.main.bounds)

        window?.rootViewController = navController
        window?.makeKeyAndVisible()

        return true
    }
}

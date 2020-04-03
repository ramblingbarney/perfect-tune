//
//  AppDelegate.swift
//  PerfectTune
//
//  Created by The App Experts on 19/02/2020.
//  Copyright © 2020 Conor O'Dwyer. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let controller = BaseViewController()
        controller.view.backgroundColor = .white

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

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "PerfectTune")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {

                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {

                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

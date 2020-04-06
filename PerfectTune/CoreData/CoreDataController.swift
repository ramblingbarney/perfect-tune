//
//  CoreDataController.swift
//  PerfectTune
//
//  Copyright © 2020 Conor O'Dwyer. All rights reserved.
//

import Foundation
import CoreData

class CoreDataController {

    private init() {}

    static let shared = CoreDataController()

    var mainContext: NSManagedObjectContext {

        return persistentContainer.viewContext
    }

    lazy var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "PerfectTune")
        container.loadPersistentStores(completionHandler: { (_, error ) in

            if let error = error as NSError? {

                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving Support
    func saveContext() -> Bool {

        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {

                try context.save()
                return true
            } catch {

                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }

        }

        return false
    }
}

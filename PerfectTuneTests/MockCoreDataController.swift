//
//  MockCoreDataController.swift
//  PerfectTuneTests
//
//  Created by The App Experts on 04/04/2020.
//  Copyright © 2020 Conor O'Dwyer. All rights reserved.
//

import Foundation
import CoreData

class MockCoreDataController {

    private init() {}

    static let shared = MockCoreDataController()

    var mainContext: NSManagedObjectContext {

        return mockPersistantContainer.viewContext
    }

    lazy var mockPersistantContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "PerfectTune")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        description.shouldAddStoreAsynchronously = false // Make it simpler in test env

        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores(completionHandler: { (_, error ) in

            if let error = error as NSError? {

                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving Support
    func saveContext() -> Bool {

        let context = mockPersistantContainer.viewContext
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

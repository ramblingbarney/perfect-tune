//
//  SearchesModel.swift
//  PerfectTune
//
//  Created by The App Experts on 24/02/2020.
//  Copyright © 2020 Conor O'Dwyer. All rights reserved.
//

import Foundation
import CoreData

class SearchesModel {
    
    let coreDataController: CoreDataController
    var currentSearch: Searches?
    var existingSearch: Searches?
    
    private var items:[NSManagedObject] = []
    
    init(_ coreDataController: CoreDataController) {
        self.coreDataController = coreDataController
        self.coreDataController.mainContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
    
    func createSearches(named searchQuery: String) throws {
        
        // Create the team
        let newSearch = Searches(context: coreDataController.mainContext)
        
        // Update
        newSearch.searchQuery = searchQuery
    
        // Save context
        coreDataController.saveContext()
    }
    
    func fetchSearchTerm(named searchQuery: String) -> [NSManagedObject] {
        
        currentSearch = Searches(context: coreDataController.mainContext)
        
        currentSearch?.searchQuery = searchQuery
        
        // Create the FetchRequest for all searches
        let allSearches: NSFetchRequest = Searches.fetchRequest()
        
        // Predicate where the unique url of the account is equal to selected account unique url
        guard let searchTerm = currentSearch?.searchQuery else { return items }
        let onlyInSelectedSearch = NSPredicate(format: "searchQuery == %@", searchTerm)
        
        allSearches.predicate = onlyInSelectedSearch
        
        do {
            items = try coreDataController.mainContext.fetch(allSearches)
        } catch {
            print(error)
        }
        
        return items
    }
}

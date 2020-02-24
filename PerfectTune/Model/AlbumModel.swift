//
//  AlbumsModel.swift
//  PerfectTune
//
//  Created by The App Experts on 24/02/2020.
//  Copyright © 2020 Conor O'Dwyer. All rights reserved.
//

import Foundation
import CoreData

class AlbumsModel {
    
    let coreDataController: CoreDataController
    var currentAlbum: Albums?
    
    private var items:[NSManagedObject] = []
    
    init(_ coreDataController: CoreDataController) {
        self.coreDataController = coreDataController
        self.coreDataController.mainContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
    
    func createAlbum(artist: String, name: String, imageUrl: String, currentSearch: [NSManagedObject]) throws {
        
        // Create the CodeRepository
        let newAlbum = Albums(context: coreDataController.mainContext)
        
        // Update
        newAlbum.searchGUID = String(currentSearch.hashValue)
        newAlbum.artist = artist
        newAlbum.name = name
        newAlbum.imageUrl = imageUrl
    
        // Save context
        coreDataController.saveContext()
    }

}

extension AlbumsModel {
    
    var numberOfSections: Int {
        return 1
    }
    
    func numberOfRows(inSection section: Int) -> Int {
        
        guard section >= 0 && section < numberOfSections else {
            return 0
        }
        
        return items.count
    }
    
    func item(at indexPath: IndexPath) -> NSManagedObject? {
        
        guard indexPath.row >= 0 && indexPath.row < numberOfRows(inSection: indexPath.section) else {
            return nil
        }
        
        return items[indexPath.row]
        
    }
}

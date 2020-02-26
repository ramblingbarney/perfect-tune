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
    
    var items:[NSManagedObject] = []
    
    weak var delegate: DataReloadTableViewDelegate?
    
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
    
    func fetchAlbums(named albumNameToFind: String) -> [NSManagedObject] {
        
        let albumName = Albums(context: coreDataController.mainContext)
        
        albumName.name = albumNameToFind
        
        // Create the FetchRequest for all searches
        let allAlbums: NSFetchRequest = Albums.fetchRequest()
        
        // Predicate where the unique url of the account is equal to selected account unique url
        guard let searchTerm = albumName.name else { return items }
        let onlyInSelectedAlbums = NSPredicate(format: "name == %@", searchTerm)
        
        allAlbums.predicate = onlyInSelectedAlbums
        
        do {
            items = try coreDataController.mainContext.fetch(allAlbums)
        } catch {
            print(error)
        }
        
        return items
    }
    
    internal func fetchAllAlbums() -> Void {
        
        // Create the FetchRequest for all searches
        let allAlbums: NSFetchRequest = Albums.fetchRequest()
        
        do {
            self.items = try coreDataController.mainContext.fetch(allAlbums)
            self.delegate?.reloadAlbumsTable()
        } catch {
            print(error)
        }
    }
    
}

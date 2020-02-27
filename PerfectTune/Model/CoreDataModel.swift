//
//  CoreDataModel.swift
//  PerfectTune
//
//  Created by The App Experts on 29/02/2020.
//  Copyright © 2020 Conor O'Dwyer. All rights reserved.
//

import Foundation
import CoreData

class CoreDataModel {
    
    weak var delegate: DataReloadTableViewDelegate?
    let coreDataController: CoreDataController
    var items:[Albums] = []
    
    init(_ coreDataController: CoreDataController) {
        self.coreDataController = coreDataController
        self.coreDataController.mainContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
    
    internal func saveSearchAlbums(responseData: Root) throws {
        
        let newSearch = Searches(context: coreDataController.mainContext)
        
        newSearch.searchQuery = responseData.attr.forField
        
        for (_, element) in responseData.albumMatches.album.enumerated() {
            
            let newAlbum = Albums(context: coreDataController.mainContext)
            
            let artistName = element.artist
            let albumName = element.name
            let imageUrlTwo = element.image[2].text
            let imageUrlZero = element.image[0].text
            let imageUrlOne = element.image[1].text
            
            var imageUrl: String = ""
            
            if !JustLetters.blank(text: imageUrlTwo) {
                imageUrl = imageUrlTwo
            }
            
            if !JustLetters.blank(text: imageUrlZero) {
                imageUrl = imageUrlZero
            }
            
            if !JustLetters.blank(text: imageUrlOne) {
                imageUrl = imageUrlOne
            }
            
            if !JustLetters.blank(text: artistName) && !JustLetters.blank(text: albumName) && !JustLetters.blank(text: imageUrl) {
                
                newAlbum.searches = newSearch
                newAlbum.artist = artistName
                newAlbum.name = albumName
                newAlbum.imageUrl = imageUrl
                
                newSearch.addToAlbums(newAlbum)
            }
            
        }
        // Save context
        coreDataController.saveContext()
        fetchAlbumsByKeyword(searchTerm: responseData.attr.forField)
    }
    
    internal func fetchAlbumsByKeyword(searchTerm: String) {
        
        // Create Fetch Request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Albums")
        
        // Add Sort Descriptor
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Add Predicate
        let predicate = NSPredicate(format: "name CONTAINS[c] %@", searchTerm)
        fetchRequest.predicate = predicate
        
        do {
            items = try  coreDataController.mainContext.fetch(fetchRequest) as! [Albums]
        } catch {
            print(error)
        }
        delegate!.reloadAlbumsTable()
    }
    
    internal func fetchAllAlbums() {
        
        // Create the FetchRequest for all searches
        let allAlbums: NSFetchRequest = Albums.fetchRequest()
        
        do {
            items = try coreDataController.mainContext.fetch(allAlbums)
        } catch {
            print(error)
        }
    }
}

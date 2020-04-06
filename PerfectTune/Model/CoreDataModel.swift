//
//  CoreDataModel.swift
//  PerfectTune
//
//  Copyright © 2020 Conor O'Dwyer. All rights reserved.
//

import Foundation
import CoreData

class CoreDataModel {

    weak var delegate: DataReloadTableViewDelegate?
    let coreDataController: CoreDataController
    var populatedAlbums: [Album] = []
    var items: [Albums] = []

    init(_ coreDataController: CoreDataController) {
        self.coreDataController = coreDataController
        self.coreDataController.mainContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }

    internal func saveSearchAlbums(responseData: Root) throws {

        let newSearch = Searches(context: coreDataController.mainContext)

        newSearch.searchQuery = responseData.attr.forField

        for element in responseData.albumMatches.albums {

            let artistName = element.artist
            let albumName = element.name
            let imageURLChosenToSave = getLargestAvailableImage(from: element.image)

            guard let imageUrlToSave = imageURLChosenToSave else {
                print("\(element.name) has no image \(element.image)")
                continue
            }

            if !artistName.isBlank && !albumName.isBlank && !imageUrlToSave.isBlank {

                populatedAlbums.append(element)
            }
        }

        for element in populatedAlbums {

            let newAlbum = Albums(context: coreDataController.mainContext)

            let artistName = element.artist
            let albumName = element.name

            let imageURLChosenSaving = getLargestAvailableImage(from: element.image)
            guard let imageUrlSaving = imageURLChosenSaving else { return }

            newAlbum.searches = newSearch
            newAlbum.artist = artistName
            newAlbum.name = albumName
            newAlbum.imageUrl = imageUrlSaving

            newSearch.addToAlbums(newAlbum)
        }
        // Save context
        _ = coreDataController.saveContext()
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

    func deleteAllData(_ entity: String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try coreDataController.mainContext.fetch(fetchRequest)
            for object in results {
                guard let objectData = object as? NSManagedObject else {continue}
                coreDataController.mainContext.delete(objectData)
            }
        } catch let error {
            print("Detele all data in \(entity) error :", error)
        }
    }
}

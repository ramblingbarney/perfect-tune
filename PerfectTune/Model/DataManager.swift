//
//  DataManager.swift
//  PerfectTune
//
//  Created by The App Experts on 24/02/2020.
//  Copyright © 2020 Conor O'Dwyer. All rights reserved.
//

import Foundation

class DataManager {
    
    let data: Root
    let modelSearches = SearchesModel(CoreDataController.shared)
    let modelAlbums = AlbumsModel(CoreDataController.shared)
    
    init(data: Root) {
        
        self.data = data
    }
    
    internal func saveData() {
        
        // save the search query
        
        guard let searchString = data.attr.forField else { return }
        
        do {
            try modelSearches.createSearches(named: searchString)
        } catch {
            print(error)
        }
        
        let currentSearchTerm = modelSearches.fetchSearchTerm(named: searchString)
        
        for (_, element) in data.albumMatches.album.enumerated() {
            
            guard let artistName = element.artist else { return }
            guard let albumName = element.name else { return }
            guard let imageUrlTwo = element.image?[2].text else {return }
            guard let imageUrlZero = element.image?[0].text else {return }
            guard let imageUrlOne = element.image?[1].text else {return }
            
            var imageUrl: String = ""
            
            if !imageUrlTwo.isEmpty {
                imageUrl = imageUrlTwo
            }
            
            if !imageUrlZero.isEmpty {
                imageUrl = imageUrlZero
            }
            
            if !imageUrlOne.isEmpty {
                imageUrl = imageUrlOne
            }
            
            do {
                try modelAlbums.createAlbum(artist: artistName, name: albumName, imageUrl: imageUrl, currentSearch: currentSearchTerm)
                
            } catch {
                print(error)
            }
        }
    }
}

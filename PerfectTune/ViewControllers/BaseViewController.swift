//
//  ViewController.swift
//  PerfectTune
//
//  Created by The App Experts on 19/02/2020.
//  Copyright © 2020 Conor O'Dwyer. All rights reserved.
//

import UIKit
import CoreData

protocol MasterModel {
    var client: LastFMClient { get }
    func searchFeed(with userSearchTerm: String?, completion: @escaping (Bool) -> Void) throws
}

protocol DataReloadTableViewDelegate: class {
    func reloadAlbumsTable()
}

class BaseViewController: UITableViewController, MasterModel {
    
    let cellId = "sdlfjowieurewfn3489844224947824dslaksjfs;ad"
    let logoContainer = UIView(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
    let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
    let image = UIImage(named: "lastFMRedBlack")
    let searchBar = UISearchBar()
    let client = LastFMClient()
    var model: CoreDataModel = CoreDataModel(CoreDataController.shared)
    private var searchResults: Root?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchController()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.register(SubtitleTableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.separatorColor = UIColor(red: 72.5/255, green: 0/255, blue: 0/255, alpha: 1)
        
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        logoContainer.addSubview(imageView)
        navigationItem.titleView = logoContainer
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        model.delegate = self
        model.fetchAllAlbums()
    }
    
    // MARK - SearchBar
    private func setupSearchController() {
        
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for Album"
        searchBar.delegate = self
        showSearchBarButton(shouldShow: true)
    }
    
    func showSearchBarButton (shouldShow: Bool) {
        
        if shouldShow {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(handleShowSearchBar))
            
        } else {
            searchBar.showsCancelButton = true
            navigationItem.rightBarButtonItem = nil
        }
    }
    
    func search(shouldShow: Bool) {
        showSearchBarButton(shouldShow: !shouldShow)
        navigationItem.titleView = shouldShow  ? searchBar : logoContainer
    }
    
    
    @objc func handleShowSearchBar(){
        
        search(shouldShow: true)
        searchBar.becomeFirstResponder()
    }
    
    
    // MARK - API Request
    func searchFeed(with userSearchTerm: String?, completion: @escaping (Bool) -> Void) {
        
        // Use the API to get data
        client.getFeed(from: LastFMRequest.albumSearch(userSearchTerm: userSearchTerm) ) { result in
            
            switch result {
            case .success(let data):
                
                do {
                    let data = try DataParser.parse(data, type: RootNode.self)
                    
                    self.searchResults = data.results
                    completion(true)
                    
                } catch {
                    print(error.localizedDescription)
                    completion(false)
                }
                
            case .failure(let error):
                guard let searchTerm = userSearchTerm else { return }
                self.model.fetchAlbumsByKeyword(searchTerm: searchTerm.replacingOccurrences(of: "+", with: " "))
                print(error.localizedDescription)
                completion(false)
            }
        }
    }
}


extension BaseViewController: UISearchBarDelegate {
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.text = nil
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        search(shouldShow:  false)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        guard let searchTextString = searchBar.text else { return }
        
        searchFeed(with: searchTextString.replacingOccurrences(of: " ", with: "+").lowercased(), completion: {_ in
            
            var albumCount: Int?
            
            if self.searchResults == nil {
                albumCount = 0
            } else {
                albumCount = self.searchResults!.albumMatches.album.count
            }
            
            if albumCount! == 0 && self.model.items.count == 0{
                self.noAlbumsFoundAlert()
            }
            
            if albumCount! > 0 {
                do {
                    try self.model.saveSearchAlbums(responseData: self.searchResults!)
                } catch {
                    print(error)
                }
            }
        })
        search(shouldShow:  false)
        searchBar.resignFirstResponder()
    }
    
    private func noAlbumsFoundAlert() {
        
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "No Albums Found", message: "Try Another Keyword(s)", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default) { action in
                print("Pressed OK")
            }
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
}

class SubtitleTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension BaseViewController {
    
    var numberOrSections: Int { return 1 }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard section >= 0 && section < numberOrSections else { return 0 }
        
        return model.items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        let albumItem = model.items[indexPath.row]
        cell.textLabel?.text = albumItem.value(forKeyPath: "name") as? String
        cell.detailTextLabel?.text = albumItem.value(forKeyPath: "artist") as? String
        
        cell.accessoryType = .disclosureIndicator
        // Populate the cell from the object
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = DetailViewController()
        vc.albumItem = model.items[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}

extension BaseViewController: DataReloadTableViewDelegate {
    
    func reloadAlbumsTable(){
        DispatchQueue.main.async {
            print(self.model.items.count)
            self.tableView.reloadData()
        }
    }
    
}

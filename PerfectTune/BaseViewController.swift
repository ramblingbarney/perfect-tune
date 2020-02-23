//
//  ViewController.swift
//  PerfectTune
//
//  Created by The App Experts on 19/02/2020.
//  Copyright © 2020 Conor O'Dwyer. All rights reserved.
//

import UIKit

protocol ListModel {
    var numberOrSections: Int { get }
    func numberOfRows(in section: Int) -> Int
    func object(at indexPath: IndexPath) -> Any?
}

protocol MasterModel {
    
    var client: LastFMClient { get }
    func searchFeed(with searchTerm: String?, completion: @escaping (Bool) -> Void)
}

class BaseViewController: UITableViewController, UITextFieldDelegate, MasterModel {
    
    let cellId = "sdlfjowieurewfn3489844224947824dslaksjfs;ad"
    let logoContainer = UIView(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
    let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
    let image = UIImage(named: "lastFMRedBlack")
    let searchBar = UISearchBar()
    
    var client = LastFMClient()
    
    private var searchResults: Root?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        setupSearchController()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.register(SubtitleTableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.separatorColor = UIColor(red: 72.5/255, green: 0/255, blue: 0/255, alpha: 1)
        
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        logoContainer.addSubview(imageView)
        navigationItem.titleView = logoContainer
    
        //print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }
    
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
    
    func searchFeed(with searchTerms: String? = nil, completion: @escaping (Bool) -> Void) {
        
        // Use the API to get data
        client.getFeed(from: LastFMRequest.albumSearch(searchTerms: searchTerms) ) { result in
        
            switch result {
                case .success(let data):
                    do{
                        let data = try DataParser.parse(data, type: RootClass.self)
                        self.searchResults = data.results
                        completion(true)
                    } catch {
                        print(error.localizedDescription)
                        completion(false)
                }
                
                case .failure(let error):
                    print(error.localizedDescription)
                    completion(false)
            }
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

extension BaseViewController: UISearchBarDelegate {
    
    //    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    //
    //    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.text = nil
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        search(shouldShow:  false)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let searchTextString = searchBar.text!
        
        searchFeed(with: searchTextString.replacingOccurrences(of: " ", with: "+").lowercased(), completion: {_ in print(self.searchResults!)
            
        })
        search(shouldShow:  false)
        searchBar.resignFirstResponder()
        
    }
    
    //    func searchBar(_ searchBar1: UISearchBar, textDidChange searchText: String) {
    //
    //    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        let model: Model
        //        if searchController.isActive && searchController.searchBar.text != "" {
        //            model = filteredModels[indexPath.row]
        //        } else {
        //            model = models[indexPath.row]
        ////        }
        //        cell.textLabel!.text = model.movie
        //        cell.detailTextLabel!.text = model.genre
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        if searchController.isActive && searchController.searchBar.text != "" {
        //            return filteredModels.count
        //        }
        
        return 1 //models.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    
}


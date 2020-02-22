//
//  ViewController.swift
//  PerfectTune
//
//  Created by The App Experts on 19/02/2020.
//  Copyright © 2020 Conor O'Dwyer. All rights reserved.
//

import UIKit

class BaseViewController: UITableViewController, UITextFieldDelegate {
    
    let cellId = "sdlfjowieurewfn3489844224947824dslaksjfs;ad"
    var models = [Model]()
    var filteredModels = [Model]()
    
    let logoContainer = UIView(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
    let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
    let image = UIImage(named: "lastFMRedBlack")
    let searchBar = UISearchBar()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        setupSearchController()
        
        models = [
            Model(movie:"The Dark Night", genre:"Action"),
            Model(movie:"The Avengers", genre:"Action"),
            Model(movie:"Logan", genre:"Action"),
            Model(movie:"Shutter Island", genre:"Thriller"),
            Model(movie:"Inception", genre:"Thriller"),
            Model(movie:"Titanic", genre:"Romance"),
            Model(movie:"La la Land", genre:"Romance"),
            Model(movie:"Gone with the Wind", genre:"Romance"),
            Model(movie:"Godfather", genre:"Drama"),
            Model(movie:"Moonlight", genre:"Drama")
        ]
        
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
        //        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
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
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        let model: Model
//        if searchController.isActive && searchController.searchBar.text != "" {
//            model = filteredModels[indexPath.row]
//        } else {
            model = models[indexPath.row]
//        }
        cell.textLabel!.text = model.movie
        cell.detailTextLabel!.text = model.genre
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if searchController.isActive && searchController.searchBar.text != "" {
//            return filteredModels.count
//        }
        
        return models.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
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
        
        print(searchTextString.replacingOccurrences(of: " ", with: "+").lowercased())
        search(shouldShow:  false)
        searchBar.resignFirstResponder()
        
    }
    
    //    func searchBar(_ searchBar1: UISearchBar, textDidChange searchText: String) {
    //
    //    }
}


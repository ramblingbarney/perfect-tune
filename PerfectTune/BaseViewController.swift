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
    var titleText = ""
    var models = [Model]()
    var filteredModels = [Model]()
    let searchController = UISearchController(searchResultsController: nil)
    var textFieldInsideSearchBar: UITextField!
    let numberFormatter = NumberFormatter()
    
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
        
        textFieldInsideSearchBar.delegate = self
        textFieldInsideSearchBar.returnKeyType = .search
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.register(SubtitleTableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.separatorColor = UIColor.red
//        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }
    
    private func setupSearchController() {
        definesPresentationContext = true
        searchController.searchBar.barTintColor = UIColor.black
        textFieldInsideSearchBar = searchController.searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar.backgroundColor = UIColor.white
        searchController.searchBar.placeholder = "Search For Album"
        searchController.hidesNavigationBarDuringPresentation = false
        tableView.tableHeaderView = searchController.searchBar
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        let model: Model
        if searchController.isActive && searchController.searchBar.text != "" {
            model = filteredModels[indexPath.row]
        } else {
            model = models[indexPath.row]
        }
        cell.textLabel!.text = model.movie
        cell.detailTextLabel!.text = model.genre
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredModels.count
        }
        
        return models.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    internal func textFieldShouldReturn(_ textFieldInsideSearchBar: UITextField) -> Bool {
        
        guard let searchText = textFieldInsideSearchBar.text else { return true }
        
        self.titleText = searchText
        
        DispatchQueue.main.async {
            self.navigationItem.title = nil
        }
        
        let plusSearchText = searchText.replacingOccurrences(of: " ", with: "+").lowercased()
        
        textFieldInsideSearchBar.resignFirstResponder()
        textFieldInsideSearchBar.text = nil
        return true
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

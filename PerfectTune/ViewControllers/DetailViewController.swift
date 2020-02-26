//
//  DetailViewController.swift
//  PerfectTune
//
//  Created by The App Experts on 26/02/2020.
//  Copyright © 2020 Conor O'Dwyer. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var iamgeURL: String!
    var albumName: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = albumName
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

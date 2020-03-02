//
//  DetailViewController.swift
//  PerfectTune
//
//  Created by The App Experts on 26/02/2020.
//  Copyright © 2020 Conor O'Dwyer. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var albumItem: Albums!
    var imageView: UIImageView!
    var placeholderImage = UIImage(named: "record")
    var artistLabel: UILabel!
    var albumLabel: UILabel!
    let client = LastFMClient()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = albumItem.value(forKeyPath: "name") as? String
        setupUI()
        setupImage()
        constraints()
    }
    
    private func setupUI() {
                
        imageView = UIImageView(image: placeholderImage)
        imageView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        imageView.contentMode = .scaleAspectFit
        self.view.addSubview(imageView)
        
        artistLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 230, height: 21))
        artistLabel.text = albumItem.value(forKeyPath: "artist") as? String
        artistLabel.myLabel()//Call this function from extension to all your labels
        view.addSubview(artistLabel)
        
        albumLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 230, height: 21))
        albumLabel.text = albumItem.value(forKeyPath: "name") as? String
        albumLabel.myLabel()//Call this function from extension to all your labels
        view.addSubview(albumLabel)
        
    }
    
    private func setupImage() {
        
        // Use the client to the image
        client.fetchImage(for: albumItem, completion: { result in
            
            switch result {
                
            case .success(let image):
                DispatchQueue.main.async { [unowned self] in
                    self.imageView.image = image
                }
            case .failure(let error):
                return print(error.localizedDescription)
            }
            
        })
    }
    
    private func constraints() {
        let margins = view.layoutMarginsGuide
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 10.0).isActive = true
        imageView.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -10.0).isActive = true
        imageView.topAnchor.constraint(equalTo: margins.topAnchor, constant: 5.0).isActive = true
        imageView.bottomAnchor.constraint(equalTo: margins.centerYAnchor, constant: 0.0).isActive = true
        view.addSubview(imageView)
        
        artistLabel.translatesAutoresizingMaskIntoConstraints = false
        artistLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 10.0).isActive = true
        artistLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -10.0).isActive = true
        artistLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10.0).isActive = true
        view.addSubview(artistLabel)
        
        albumLabel.translatesAutoresizingMaskIntoConstraints = false
        albumLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 10.0).isActive = true
        albumLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -10.0).isActive = true
        albumLabel.topAnchor.constraint(equalTo: artistLabel.bottomAnchor, constant: 20.0).isActive = true
        view.addSubview(albumLabel)
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

extension UILabel {
    func myLabel() {
        textAlignment = .center
        textColor = UIColor(red: 72.5/255, green: 0/255, blue: 0/255, alpha: 1)
        font = UIFont.systemFont(ofSize: 17)
        numberOfLines = 0
        lineBreakMode = .byCharWrapping
        sizeToFit()
    }
}

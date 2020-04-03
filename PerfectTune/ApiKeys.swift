//
//  ApiKeys.swift
//  PerfectTune
//
//  Created by The App Experts on 20/02/2020.
//  Copyright © 2020 Conor O'Dwyer. All rights reserved.
//
import Foundation

func valueForAPIKey(named keyname: String) -> String {
    let filePath = Bundle.main.path(forResource: "ApiKeys", ofType: "plist")
    let plist = NSDictionary(contentsOfFile: filePath!)
    let value = plist?.object(forKey: keyname) as! String
    return value
}

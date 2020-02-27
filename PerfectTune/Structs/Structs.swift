//
//  Structs.swift
//  PerfectTune
//
//  Created by The App Experts on 19/02/2020.
//  Copyright © 2020 Conor O'Dwyer. All rights reserved.
//

import Foundation

struct Model {
    let movie : String
    let genre : String
}

struct JustLetters {
  static func blank(text: String) -> Bool {
    let trimmed = text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    return trimmed.isEmpty
  }
}

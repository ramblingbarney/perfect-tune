//
//  Extensions.swift
//  PerfectTune
//
//  Copyright © 2020 Conor O'Dwyer. All rights reserved.
//

import Foundation

extension String {

    var isBlank: Bool {
        let trimmed = self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        return trimmed.isEmpty
    }
}

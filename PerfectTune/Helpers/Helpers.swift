//
//  Helpers.swift
//  PerfectTune
//
//  Copyright © 2020 Conor O'Dwyer. All rights reserved.
//

import Foundation

internal func getLargestAvailableImage(from images: [Image]) -> String? {
    return images.compactMap({ $0.text.isEmpty ? nil : $0.text }).last
}

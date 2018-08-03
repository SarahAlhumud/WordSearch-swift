//
//  Puzzle.swift
//  WordSearch
//
//  Created by Matthew Crenshaw on 11/7/15.
//  Copyright © 2015 Matthew Crenshaw. All rights reserved.
//

import Foundation

/// ASSUMPTION: `character_grid` will always be a square 2d array

struct Puzzle {
    let sourceLanguage: String
    let targetLanguage: String
    let word: String
    let characterGrid: [[String]]
    //let wordLocations: [WordLocation]
    let rows: Int
    let columns: Int
    
}

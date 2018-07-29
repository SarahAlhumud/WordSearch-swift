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
    let wordLocations: [WordLocation]
    let rows: Int
    let columns: Int
    
    /// Decodes `Puzzle` from json.
    static func decodeJson(_ json: AnyObject) -> Puzzle? {
        guard let dict = json as? [String:AnyObject] else {
            assertionFailure("json is not a dictionary")
            return nil
        }

        guard let sourceLanguage_field: AnyObject = dict["source_language"] else {
            assertionFailure("field 'source_language' is mising")
            return nil
        }
        guard let sourceLanguage: String = String.decodeJson(sourceLanguage_field) else {
            assertionFailure("field 'source_language' is not a String")
            return nil
        }

        guard let targetLanguage_field: AnyObject = dict["target_language"] else {
            assertionFailure("field 'target_language' is mising")
            return nil
        }
        guard let targetLanguage: String = String.decodeJson(targetLanguage_field) else {
            assertionFailure("field 'target_language' is not a String")
            return nil
        }

        guard let word_field: AnyObject = dict["word"] else {
            assertionFailure("field 'word_field' is mising")
            return nil
        }
        guard let word: String = String.decodeJson(word_field) else {
            assertionFailure("field 'word_field' is not a String")
            return nil
        }

//        guard let characterGrid_field: AnyObject = dict["character_grid"] else {
//            assertionFailure("field 'character_grid' is missing")
//            return nil
//        }
//
//        guard let characterGrid: [[String]] = Array.decodeJson({ Array.decodeJson({ String.decodeJson($0) }, $0) }, characterGrid_field) else {
//            assertionFailure("field 'character_grid' is not a [[String]]")
//            return nil
//        }

        let characterGrid: [[String]] = [["f", "t", "v", "s", "a", "r", "a", "h","e","f","g","h"], ["h", "j", "e", "t", "e", "t", "s", "z","e","f","g","h"], ["x", "e", "o", "i", "e", "l", "a", "h","e","f","g","h"], ["q", "t", "i", "u", "q", "s", "r", "s","e","f","g","h"], ["c", "u", "m", "y", "v", "l", "a", "x","e","f","g","h"], ["n", "l", "m", "m", "o", "t", "h", "k","e","f","g","h"], ["a", "g", "r", "n", "n", "x", "s", "m","e","f","g","h"],["a","b","c","d","e","f","g","h","e","f","g","h"],["a","b","c","d","e","f","g","h","e","f","g","h"],["a","b","c","d","e","f","g","h","e","f","g","h"],["a","b","c","d","e","f","g","h","e","f","g","h"],["a","b","c","d","e","f","g","h","e","f","g","h"]]
        
//        guard let wordLocations_field: AnyObject = dict["word_locations"] else {
//            assertionFailure("field 'word_locations' is missing")
//            return nil
//        }
        let wordLocations_field: AnyObject = ["6,1,6,2,6,3,6,4,6,5" : "sarah"] as AnyObject
        
        guard let wordLocations: [WordLocation] = WordLocation.decodeJson(wordLocations_field) else {
            assertionFailure("field word_locations is not word locations")
            return nil
        }

        
        let rows = characterGrid.count
        let columns = characterGrid.first!.count
        
        return Puzzle(sourceLanguage: sourceLanguage, targetLanguage: targetLanguage, word: word, characterGrid: characterGrid, wordLocations: wordLocations, rows: rows, columns: columns)
    }
}

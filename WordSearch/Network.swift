//
//  Request.swift
//  WordSearch
//
//  Created by Matthew Crenshaw on 11/8/15.
//  Copyright © 2015 Matthew Crenshaw. All rights reserved.
//

import Foundation

class Network {

    static let PuzzleURLString = "https://s3.amazonaws.com/duolingo-data/s3/js2/find_challenges.txt"

    /// Request puzzles
    class func requestPuzzles(_ completionHandler: @escaping (_ puzzles: [Puzzle]?, _ error: NSError?) -> Void) {
        let session = URLSession.shared
        let url = URL(string:PuzzleURLString)!
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request, completionHandler: { data, response, error in
            var puzzles: [Puzzle]?
            defer {
                if let puzzles = puzzles {
                    completionHandler(puzzles, nil)
                } else if let error = error {
                    completionHandler(nil, error as NSError?)
                } else {
                    let error = NSError(
                        domain: "com.matthewcrenshaw.WordSearch.network",
                        code: 100,
                        userInfo: [NSLocalizedDescriptionKey: "Unable to load puzzles"])
                    completionHandler(nil, error)
                }
            }
            guard error == nil else {
                assertionFailure("http request returned error")
                return
            }
            // Decode lsj (line separated json)
            if let data = data, let text = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
                let lines = text.components(separatedBy: CharacterSet.newlines)
                puzzles = []
                for line in lines {
                    if let json = decodeJsonString(line), let puzzle = Puzzle.decodeJson(json) {
                        puzzles!.append(puzzle)
                    }
                }
            }
        }) 
        task.resume()
    }

    /// Decodes `AnyObject` from json string.
    fileprivate class func decodeJsonString(_ json: String) -> AnyObject? {
        let data = json.data(using: String.Encoding.utf8)!
        
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            return json as AnyObject?
        } catch {
            return nil
        }
    }
}

//
//  CharacterLabel.swift
//  WordSearch
//
//  Created by Matthew Crenshaw on 11/11/15.
//  Copyright © 2015 Matthew Crenshaw. All rights reserved.
//

import UIKit

class CharacterLabel: UILabel {

    let coordinate: Coordinate

    required init?(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }
    
    init(character: String, coordinate: Coordinate) {
        self.coordinate = coordinate
        super.init(frame: CGRect.zero)
        self.initialize()
        self.text = character
    }

    fileprivate func initialize() {
        font = UIFont.systemFont(ofSize: 24)
        textAlignment = .center
        translatesAutoresizingMaskIntoConstraints = false
    }
}

//
//  CollectionType+Extensions.swift
//  WordSearch
//
//  Created by Matthew Crenshaw on 11/11/15.
//  Copyright © 2015 Matthew Crenshaw. All rights reserved.
//

import Foundation

extension Collection {
    /// Similar to `filter`, but immediately returns the first result.
    func find(_ predicate: (Self.Iterator.Element) throws -> Bool) rethrows -> Self.Iterator.Element? {
        return try index(where: predicate).map({ self[$0] })
    }
}



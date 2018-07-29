//
//  NavigationController.swift
//  WordSearch
//
//  Created by Matthew Crenshaw on 11/13/15.
//  Copyright © 2015 Matthew Crenshaw. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {

    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .portrait
        } else {
            return .all
        }
    }
}

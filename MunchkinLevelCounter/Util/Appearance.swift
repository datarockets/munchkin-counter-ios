//
//  Appearance.swift
//  MunchkinLevelCounter
//
//  Created by Dzmitry Chyrta on 01.03.17.
//  Copyright © 2017 datarockets. All rights reserved.
//

import Foundation
import UIKit

class Appearance {
    
    static func setupUIAppearance() {
        UINavigationBar.appearance().barTintColor = Colors.cardLight
        UINavigationBar.appearance().tintColor = Colors.cardCorner
        
        UISwitch.appearance().onTintColor = Colors.cardCorner.withAlphaComponent(0.2)
        UISwitch.appearance().thumbTintColor = Colors.cardCorner
        
        UIToolbar.appearance().backgroundColor = Colors.cardLight
        UIToolbar.appearance().tintColor = Colors.cardCorner
    }
    
}

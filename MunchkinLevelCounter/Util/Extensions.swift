//
//  ColorExtension.swift
//  MunchkinLevelCounter
//
//  Created by Dzmitry Chyrta on 27.02.17.
//  Copyright © 2017 datarockets. All rights reserved.
//

import UIKit
import Foundation

extension UIColor {
    
    open class func colorHash(hexString: String?) -> UIColor {
        if let n = hexString {
            var nameValue = 0
            
            for c in n.characters {
                let characterString = String(c)
                let scalars = characterString.unicodeScalars
                nameValue +=  Int(scalars[scalars.startIndex].value)
            }
            
            var r = Float((nameValue * 123) % 51) / 51.0
            var g = Float((nameValue * 321) % 73) / 73.0
            var b = Float((nameValue * 213) % 91) / 91.0
            
            r = min(max(r, 0.1), 0.84)
            g = min(max(g, 0.1), 0.84)
            b = min(max(b, 0.1), 0.84)
            
            return UIColor.init(red: CGFloat(r), green: CGFloat(g), blue: CGFloat(b), alpha: 1.0)
        } else {
            return UIColor.red
        }
    }
    
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Infalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(hex: Int) {
        self.init(red: (hex >> 16) & 0xFF, green: (hex >> 8) & 0xFF, blue: hex & 0xFF)
    }
    
}

extension String {
    
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
    
}

extension UIBarButtonItem {
    
    public var localizedText: String? {
        set {
            if newValue != nil {
                self.title = newValue?.localized
            } else {
                self.title = nil
            }
        }
        get {
            return self.title
        }
    }
    
}

extension UINavigationItem {
    
    public var localizedText: String? {
        set {
            if newValue != nil {
                self.title = newValue?.localized
            } else {
                self.title = nil
            }
        }
        get {
            return self.title
        }
    }
    
}

extension UISegmentedControl {
    
    @IBInspectable var localized: Bool {
        get { return true }
        set {
            for index in 0..<numberOfSegments {
                let title = NSLocalizedString(titleForSegment(at: index)!, comment: "")
                setTitle(title, forSegmentAt: index)
            }
        }
    }
    
}

extension UIButton {
    
    @IBInspectable public var localizedTitle: String? {
        set { setLocalizedTitle(newValue, state: UIControlState()) }
        get { return getTitleForState(UIControlState()) }
    }
    
    fileprivate func setLocalizedTitle(_ title: String?, state: UIControlState) {
        if title != nil {
            self.setTitle(title!.localized, for: state)
        } else {
            self.setTitle(nil, for: state)
        }
    }
    
    fileprivate func getTitleForState(_ state: UIControlState) -> String? {
        if let title = self.titleLabel {
            return title.text
        }
        return nil
    }
    
}

extension UILabel {
    
    @IBInspectable public var localizedText: String? {
        set {
            if newValue != nil {
                self.text = newValue?.localized
            } else {
                self.text = nil
            }
        }
        
        get {
            return self.text
        }
    }
    
}

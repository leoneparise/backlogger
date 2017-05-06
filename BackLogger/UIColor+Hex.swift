//
//  UIColor_Hex.swift
//  StumpExample
//
//  Created by Leone Parise Vieira da Silva on 06/05/17.
//  Copyright © 2017 com.leoneparise. All rights reserved.
//

import UIKit

/// MARK: - Hex extensions
public extension UIColor {
    public convenience init(hexRed: Int, hexGreen: Int, hexBlue: Int, alpha: CGFloat) {
        assert(hexRed >= 0 && hexRed <= 255, "Invalid red component")
        assert(hexGreen >= 0 && hexGreen <= 255, "Invalid green component")
        assert(hexBlue >= 0 && hexBlue <= 255, "Invalid blue component")
        assert(alpha >= 0 && alpha <= 1, "Invalid alpha component")
        
        self.init(red: CGFloat(hexRed) / 255.0, green: CGFloat(hexGreen) / 255.0, blue: CGFloat(hexBlue) / 255.0, alpha: alpha)
    }
    
    public convenience init(hex:Int) {
        self.init(hex:hex, alpha: 1.0)
    }
    
    public convenience init(hex:Int, alpha: CGFloat) {
        self.init(hexRed:(hex >> 16) & 0xff, hexGreen:(hex >> 8) & 0xff, hexBlue:hex & 0xff, alpha: alpha)
    }
}

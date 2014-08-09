//
//  DarkOrangeAppearance.swift
//  2047
//
//  Created by Bruce Ricketts on 8/8/14.
//  Copyright (c) 2014 fireypotato. All rights reserved.
//

import UIKit

class CyanAppearance: TileAppearance {
    func topColorRGB() -> [CGFloat] {
        return [122, 252, 220]
    }
    
    func bottomColorRGB() -> [CGFloat] {
        return [5, 186, 181]
    }
    
    func labelColor() -> UIColor {
        return UIColor.whiteColor()
    }
    
    func availableForValue(value: Int) -> Bool {
        return value == 15
    }
}
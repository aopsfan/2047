//
//  SkyBlueAppearance.swift
//  2047
//
//  Created by Bruce Ricketts on 8/12/14.
//  Copyright (c) 2014 fireypotato. All rights reserved.
//

import UIKit

class SkyBlueAppearance: TileAppearance {
    func topColorRGB() -> [CGFloat] {
        return [152, 192, 203]
    }
    
    func bottomColorRGB() -> [CGFloat] {
        return [0, 140, 183]
    }
    
    func labelColor() -> UIColor {
        return UIColor.whiteColor()
    }
    
    func availableFor(value: Int) -> Bool {
        return value == 31
    }
}
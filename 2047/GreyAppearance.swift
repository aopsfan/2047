//
//  GreyAppearance.swift
//  2047
//
//  Created by Bruce Ricketts on 8/9/14.
//  Copyright (c) 2014 fireypotato. All rights reserved.
//

import UIKit

class GreyAppearance: TileAppearance {
    func topColorRGB() -> [CGFloat] {
        return [220, 220, 235]
    }
    
    func bottomColorRGB() -> [CGFloat] {
        return [180, 180, 205]
    }
    
    func labelColor() -> UIColor {
        return UIColor.black
    }
    
    func availableFor(_ value: Int) -> Bool {
        return value == 16
    }
}

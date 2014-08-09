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
        return [203, 203, 203]
    }
    
    func bottomColorRGB() -> [CGFloat] {
        return [121, 121, 121]
    }
    
    func labelColor() -> UIColor {
        return UIColor.whiteColor()
    }
    
    func availableForValue(value: Int) -> Bool {
        return value == 31
    }
}
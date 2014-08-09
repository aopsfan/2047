//
//  RedAppearance.swift
//  2047
//
//  Created by Bruce Ricketts on 8/9/14.
//  Copyright (c) 2014 fireypotato. All rights reserved.
//

import UIKit

class RedAppearance: TileAppearance {
    func topColorRGB() -> [CGFloat] {
        return [254, 94, 139]
    }
    
    func bottomColorRGB() -> [CGFloat] {
        return [255, 38, 0]
    }
    
    func labelColor() -> UIColor {
        return UIColor.whiteColor()
    }
    
    func availableForValue(value: Int) -> Bool {
        return value == 127
    }
}
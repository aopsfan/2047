//
//  BlackAppearance.swift
//  2047
//
//  Created by Bruce Ricketts on 8/8/14.
//  Copyright (c) 2014 fireypotato. All rights reserved.
//

import UIKit

class BlackAppearance: TileAppearance {
    func topColorRGB() -> [CGFloat] {
        return [50.0, 50.0, 50.0]
    }
    
    func bottomColorRGB() -> [CGFloat] {
        return [0.0, 0.0, 0.0]
    }
    
    func labelColor() -> UIColor {
        return UIColor.whiteColor()
    }
    
    func availableForValue(value: Int) -> Bool {
        return true
    }
}
//
//  PurpleAppearance.swift
//  2047
//
//  Created by Bruce Ricketts on 8/15/14.
//  Copyright (c) 2014 fireypotato. All rights reserved.
//

import UIKit

class PurpleAppearance: TileAppearance {
    func topColorRGB() -> [CGFloat] {
        return [0, 168, 208]
    }
    
    func bottomColorRGB() -> [CGFloat] {
        return [132, 48, 214]
    }
    
    func labelColor() -> UIColor {
        return UIColor.white
    }
    
    func availableFor(_ value: Int) -> Bool {
        return value == 1024
    }
}

//
//  GreenAppearance.swift
//  2047
//
//  Created by Bruce Ricketts on 8/12/14.
//  Copyright (c) 2014 fireypotato. All rights reserved.
//

import UIKit

class GreenAppearance: TileAppearance {
    func topColorRGB() -> [CGFloat] {
        return [141, 202, 133]
    }
    
    func bottomColorRGB() -> [CGFloat] {
        return [0, 139, 68]
    }
    
    func labelColor() -> UIColor {
        return UIColor.white
    }
    
    func availableFor(_ value: Int) -> Bool {
        return value == 256
    }
}

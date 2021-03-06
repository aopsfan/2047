//
//  AmberTile.swift
//  2047
//
//  Created by Bruce Ricketts on 8/8/14.
//  Copyright (c) 2014 fireypotato. All rights reserved.
//

import UIKit

class OrangeAppearance: TileAppearance {
    func topColorRGB() -> [CGFloat] {
        return [253, 220, 91]
    }
    
    func bottomColorRGB() -> [CGFloat] {
        return [255, 175, 64]
    }
    
    func labelColor() -> UIColor {
        return UIColor.black
    }
    
    func availableFor(_ value: Int) -> Bool {
        return [2, 4, 8].contains(value)
    }
}

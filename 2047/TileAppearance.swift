//
//  TileViewAppearance.swift
//  2047
//
//  Created by Bruce Ricketts on 8/8/14.
//  Copyright (c) 2014 fireypotato. All rights reserved.
//

import UIKit

protocol TileAppearance {
    func topColorRGB() -> [CGFloat]
    func bottomColorRGB() -> [CGFloat]
    func labelColor() -> UIColor
    func availableFor(value: Int) -> Bool
}
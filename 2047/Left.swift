//
//  Left.swift
//  2047
//
//  Created by Bruce Ricketts on 7/20/14.
//  Copyright (c) 2014 fireypotato. All rights reserved.
//

import Foundation

class Left: Move {
    func vector() -> Vector {
        return Vector(-1, 0)
    }
    
    func locationBeforeLocation(location1: Location, _ location2: Location) -> Bool {
        return location1.x < location2.x // move left tiles first
    }
}
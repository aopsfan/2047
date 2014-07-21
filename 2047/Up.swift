//
//  Up.swift
//  2047
//
//  Created by Bruce Ricketts on 7/20/14.
//  Copyright (c) 2014 fireypotato. All rights reserved.
//

import Foundation

class Up: Move {
    func vector() -> Vector {
        return Vector(0, -1)
    }
    
    func locationBeforeLocation(location1: Location, _ location2: Location) -> Bool {
        return location1.y < location2.y // move top tiles first
    }
}
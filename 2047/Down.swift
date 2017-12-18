//
//  Down.swift
//  2047
//
//  Created by Bruce Ricketts on 7/20/14.
//  Copyright (c) 2014 fireypotato. All rights reserved.
//

import Foundation

class Down: Direction {
    func vector() -> Vector {
        return Vector(0, 1)
    }
    
    func locationBeforeLocation(_ location1: Location, _ location2: Location) -> Bool {
        return location1.y > location2.y // move bottom tiles first
    }
}

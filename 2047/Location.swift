//
//  Location.swift
//  2047
//
//  Created by Bruce Ricketts on 7/17/14.
//  Copyright (c) 2014 fireypotato. All rights reserved.
//

import Foundation

struct Location: Equatable, Hashable {
    var x = 0
    var y = 0
    
    init(_ x: Int, _ y: Int) {
        self.x = x
        self.y = y
    }
    
    func stringValue() -> String {
        return "(\(x), \(y))"
    }
    
    var hashValue: Int {
        return self.stringValue().hash
    }
}

func ==(lhs: Location, rhs: Location) -> Bool {
    return lhs.x == rhs.x && lhs.y == rhs.y
}

func +(lhs: Location, rhs: Vector) -> Location {
    return Location(lhs.x + rhs.xDistance, lhs.y + rhs.yDistance)
}
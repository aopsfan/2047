//
//  Vector.swift
//  2047
//
//  Created by Bruce Ricketts on 7/17/14.
//  Copyright (c) 2014 fireypotato. All rights reserved.
//

import Foundation

struct Vector {
    var xDistance = 0
    var yDistance = 0
    
    init(_ xDistance: Int, _ yDistance: Int) {
        self.xDistance = xDistance
        self.yDistance = yDistance
    }
}
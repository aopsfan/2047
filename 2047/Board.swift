//
//  Board.swift
//  2047
//
//  Created by Bruce Ricketts on 7/17/14.
//  Copyright (c) 2014 fireypotato. All rights reserved.
//

import Foundation

struct Board {
    let width: Int
    let height: Int
    
    init(_ width: Int, _ height: Int) {
        self.width = width
        self.height = height
    }
    
    func allLocations() -> [Location] {
        var locations = [Location]()
        
        for x: Int in 0..<width {
            for y: Int in 0..<height {
                locations.append(Location(x, y))
            }
        }
        
        return locations
    }
}
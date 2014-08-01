//
//  Tile.swift
//  2047
//
//  Created by Bruce Ricketts on 7/17/14.
//  Copyright (c) 2014 fireypotato. All rights reserved.
//

import Foundation

class Tile: Equatable, Hashable {
    var location = Location(0, 0)
    var value = 0
    var canMerge = true
    
    init(location: Location, value: Int) {
        self.location = location
        self.value = value
    }
    
    func stringValue() -> String {
        return "\(self.location.stringValue()).\(self.value).\(canMerge ? 1 : 0)"
    }
    
    var hashValue: Int {
        return stringValue().hash
    }
    
    func goTo(location: Location, impedingTile: Tile?, _ closure: (moved: Bool, merged: Bool) -> ()) {
        let moved = impedingTile == nil || (impedingTile?.value == self.value && self.canMerge && impedingTile!.canMerge)
        let merged = moved && impedingTile != nil
        
        if moved { self.location = location }
        if merged { self.value = self.value * 2 + 1 }
        
        closure(moved: moved, merged: merged)
    }
}

func ==(lhs: Tile, rhs: Tile) -> Bool {
    let sameLocation = lhs.location == rhs.location
    let sameValue = lhs.value == rhs.value
    let sameMergability = lhs.canMerge == rhs.canMerge
    
    return sameLocation && sameValue && sameMergability
}
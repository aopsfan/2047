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
    var _canMerge = true
    
    init(location: Location, value: Int) {
        self.location = location
        self.value = value
    }
    
    func stringValue() -> String {
        return "\(self.location.stringValue()).\(self.value).\(_canMerge ? 1 : 0)"
    }
    
    var hashValue: Int {
        return stringValue().hash
    }
    
    func moveBy(_ vector: Vector, blockingTile: Tile?, mergeRule: TileMergeRule) -> Bool {
        let destinationValue = { mergeRule.valueByMergingTiles([self, blockingTile!]) }
        let moved = blockingTile == nil || destinationValue() != nil && _canMerge && blockingTile!._canMerge
        let merged = moved && blockingTile != nil
        
        if moved { location = location + vector }
        if merged {
            value = destinationValue()!
            _canMerge = false
        }
        
        return moved
    }
    
    func enableMerging() {
        _canMerge = true
    }
}

func ==(lhs: Tile, rhs: Tile) -> Bool {
    let sameLocation = lhs.location == rhs.location
    let sameValue = lhs.value == rhs.value
    let sameMergability = lhs._canMerge == rhs._canMerge
    
    return sameLocation && sameValue && sameMergability
}

//
//  TileTests.swift
//  2047
//
//  Created by Bruce Ricketts on 7/19/14.
//  Copyright (c) 2014 fireypotato. All rights reserved.
//

import UIKit
import XCTest

class TileTests: XCTestCase {
    let tile = Tile(location: Location(2, 2), value: 3)
    
    func testEquatable() {
        let identicalTile = Tile(location: Location(2, 2), value: 3)
        XCTAssertEqual(tile, identicalTile)
        identicalTile.canMerge = false
        XCTAssertNotEqual(tile, identicalTile)
        
        XCTAssertNotEqual(tile, Tile(location: Location(2, 3), value: 3))
        XCTAssertNotEqual(tile, Tile(location: Location(2, 2), value: 7))
    }
    
    func testGoToEmptyLocation() {
        var moved = false
        var merged = false
        tile.goTo(Location(2, 1), impedingTile: nil, {(_moved: Bool, _merged: Bool) in
            moved = _moved
            merged = _merged
            })
        
        XCTAssert(moved)
        XCTAssertFalse(merged)
        XCTAssertEqual(tile.location, Location(2, 1))
        XCTAssertEqual(tile.value, 3)
    }
    
    func testGoToEmptyLocationWithoutMerge() {
        self.tile.canMerge = false
        
        var moved = false
        var merged = false
        tile.goTo(Location(2, 1), impedingTile: nil, {(_moved: Bool, _merged: Bool) in
            moved = _moved
            merged = _merged
            })
        
        XCTAssert(moved)
        XCTAssertFalse(merged)
        XCTAssertEqual(tile.location, Location(2, 1))
        XCTAssertEqual(tile.value, 3)
    }
    
    func testGoToTileOfSameValue() {
        var moved = false
        var merged = false
        let impedingTile = Tile(location: Location(2, 1), value: 3)
        tile.goTo(Location(2, 1), impedingTile: impedingTile, {(_moved: Bool, _merged: Bool) in
            moved = _moved
            merged = _merged
            })
        
        XCTAssert(moved)
        XCTAssert(merged)
        XCTAssertEqual(tile.location, Location(2, 1))
        XCTAssertEqual(tile.value, 7)
    }
    
    func testGoToTileOfSameValueWithoutMerge() {
        self.tile.canMerge = false
        
        var moved = false
        var merged = false
        let impedingTile = Tile(location: Location(2, 1), value: 3)
        tile.goTo(Location(2, 1), impedingTile: impedingTile, {(_moved: Bool, _merged: Bool) in
            moved = _moved
            merged = _merged
            })
        
        XCTAssertFalse(moved)
        XCTAssertFalse(merged)
        XCTAssertEqual(tile.location, Location(2, 2))
        XCTAssertEqual(tile.value, 3)
    }
    
    func testGoToTileOfDifferentValue() {
        var moved = false
        var merged = false
        let impedingTile = Tile(location: Location(2, 1), value: 7)
        tile.goTo(Location(2, 1), impedingTile: impedingTile, {(_moved: Bool, _merged: Bool) in
            moved = _moved
            merged = _merged
            })
        
        XCTAssertFalse(moved)
        XCTAssertFalse(merged)
        XCTAssertEqual(tile.location, Location(2, 2))
        XCTAssertEqual(tile.value, 3)
    }
    
    func testGoToTileOfDifferentValueWithoutMerge() {
        self.tile.canMerge = false
        
        var moved = false
        var merged = false
        let impedingTile = Tile(location: Location(2, 1), value: 7)
        tile.goTo(Location(2, 1), impedingTile: impedingTile, {(_moved: Bool, _merged: Bool) in
            moved = _moved
            merged = _merged
            })
        
        XCTAssertFalse(moved)
        XCTAssertFalse(merged)
        XCTAssertEqual(tile.location, Location(2, 2))
        XCTAssertEqual(tile.value, 3)
    }
}

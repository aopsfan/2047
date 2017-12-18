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
    let mergeRule = DoublePlusOneMergeRule()
    
    func testEquatable() {
        let identicalTile = Tile(location: Location(2, 2), value: 3)
        XCTAssertEqual(tile, identicalTile)
        XCTAssertNotEqual(tile, Tile(location: Location(2, 3), value: 3))
        XCTAssertNotEqual(tile, Tile(location: Location(2, 2), value: 7))
    }
    
    func testMoveByWithEmptyLocation() {
        XCTAssert(tile.moveBy(Vector(0, -1), blockingTile: nil, mergeRule: mergeRule))
        XCTAssertEqual(tile.location, Location(2, 1))
        XCTAssertEqual(tile.value, 3)
    }
    
    func testMoveByWithTileOfSameValue() {
        let blockingTile = Tile(location: Location(2, 1), value: 3)
        XCTAssert(tile.moveBy(Vector(0, -1), blockingTile: blockingTile, mergeRule: mergeRule))
        XCTAssertEqual(tile.location, Location(2, 1))
        XCTAssertEqual(tile.value, 7)
    }
    
    func testMoveByWithTileOfDifferentValue() {
        let blockingTile = Tile(location: Location(2, 1), value: 3)
        XCTAssertFalse(tile.moveBy(Vector(0, -1), blockingTile: blockingTile, mergeRule: mergeRule))
        XCTAssertEqual(tile.location, Location(2, 2))
        XCTAssertEqual(tile.value, 3)
    }
    
    func testMoveByTwice() {
        let firstTile = Tile(location: Location(2, 1), value: 3)
        let secondTile = Tile(location: Location(2, 0), value: 7)
        let upVector = Vector(0, -1)
        
        XCTAssert(tile.moveBy(upVector, blockingTile: firstTile, mergeRule: mergeRule))
        XCTAssertFalse(tile.moveBy(upVector, blockingTile: secondTile, mergeRule: mergeRule))
        
        XCTAssertEqual(tile.location, Location(2, 1))
        XCTAssertEqual(tile.value, 7)
    }
}

//
//  GameTests.swift
//  2047
//
//  Created by Bruce Ricketts on 7/20/14.
//  Copyright (c) 2014 fireypotato. All rights reserved.
//

import UIKit
import XCTest

class PresetTileGenerator : TileGenerationStrategy {
    var nextTiles = [Tile]()
    
    func newTile(availableSpaces: [Location]) -> Tile {
        let nextTile = self.nextTiles[0]
        self.nextTiles.removeAtIndex(0)
        return nextTile
    }
}

class GameTests: XCTestCase {
    var game = Game()
    let tileGenerator = PresetTileGenerator()
    
    func resetGame() {
        game = Game()
        game.tileGenerationStrategy = self.tileGenerator
    }
    
    override func setUp() {
        super.setUp()
        
        game.tileGenerationStrategy = self.tileGenerator
    }
    
    func testAddTiles() {
        let tile00 = Tile(location: Location(0, 0), value: 1)
        let tile01 = Tile(location: Location(0, 1), value: 3)
        
        self.tileGenerator.nextTiles = [tile00, tile01]
        
        XCTAssertEqual(self.game.tiles.count, 0)
        XCTAssertEqual(self.game.score, 0)
        
        self.game.addTiles(2)
        
        XCTAssertEqual(self.game.tiles.count, 2)
        XCTAssertEqual(self.game.tiles[Location(0, 0)]!, tile00)
        XCTAssertEqual(self.game.tiles[Location(0, 1)]!, tile01)
        XCTAssertEqual(self.game.score, 0)
    }
    
    func testMoveOneTile() {
        var firstTile: Tile!
        var queuedTile: Tile!
        
        func before(identifier: String) {
            resetGame()
            firstTile = Tile(location: Location(2, 0), value: 1)
            queuedTile = Tile(location: Location(2, 1), value: 1)
            self.tileGenerator.nextTiles = [firstTile, queuedTile]
            self.game.addTiles(1)
        }
        
        func after(identifier: String) {
            XCTAssertEqual(self.game.score, 0, "after \(identifier)")
        }
        
        func whenMovingRight() {
            self.game.move(Right())
            XCTAssertEqual(self.game.tiles[Location(3, 0)]!, firstTile)
            XCTAssertEqual(self.game.tiles.count, 2)
            XCTAssertEqual(self.game.tiles[Location(2, 1)]!, queuedTile)
        }
        
        func whenMovingLeft() {
            self.game.move(Left())
            XCTAssertEqual(self.game.tiles[Location(0, 0)]!, firstTile)
            XCTAssertEqual(self.game.tiles.count, 2)
            XCTAssertEqual(self.game.tiles[Location(2, 1)]!, queuedTile)
        }
        
        func whenMovingUp() {
            self.game.move(Up())
            XCTAssertEqual(self.game.tiles[Location(2, 0)]!, firstTile)
            XCTAssertEqual(self.game.tiles.count, 1)
        }
        
        func whenMovingDown() {
            self.game.move(Down())
            XCTAssertEqual(self.game.tiles[Location(2, 3)]!, firstTile)
            XCTAssertEqual(self.game.tiles.count, 2)
            XCTAssertEqual(self.game.tiles[Location(2, 1)]!, queuedTile)
        }
        
        let tests = [
            "whenMovingRight": whenMovingRight,
            "whenMovingLeft": whenMovingLeft,
            "whenMovingUp": whenMovingUp,
            "whenMovingDown": whenMovingDown
        ]
        
        for (identifier, closure) in tests {
            println("SPEC BEGAN: \(identifier)")
            before(identifier)
            closure()
            after(identifier)
            println("SPEC ENDED: \(identifier)")
        }
    }
}

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
    
    func describe(identifier: String, beforeEach: () -> (), _ specs: [String: () -> ()]) {
        println("\n>>>>>> SPEC BEGIN: \(identifier) <<<<<<\n\n")
        for spec in specs {
            println("\(identifier) \(spec.0)")
            beforeEach()
            spec.1()
        }
        println("\n\n>>>>>> SPEC END: \(identifier) <<<<<<\n")
    }
    
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
        
        describe("when one tile moved",
            beforeEach: {
                self.resetGame()
                firstTile = Tile(location: Location(2, 0), value: 1)
                queuedTile = Tile(location: Location(2, 1), value: 1)
                self.tileGenerator.nextTiles = [firstTile, queuedTile]
                self.game.addTiles(1)
            }, [
                "should fall right when moved right": {
                    self.game.move(Right())
                    XCTAssertEqual(self.game.tiles[Location(3, 0)]!, firstTile)
                    XCTAssertEqual(self.game.tiles.count, 2)
                    XCTAssertEqual(self.game.tiles[Location(2, 1)]!, queuedTile)
                },
                
                "should fall left when moved left": {
                    self.game.move(Left())
                    XCTAssertEqual(self.game.tiles[Location(0, 0)]!, firstTile)
                    XCTAssertEqual(self.game.tiles.count, 2)
                    XCTAssertEqual(self.game.tiles[Location(2, 1)]!, queuedTile)
                },
                
                "should do nothing when moved up": {
                    self.game.move(Up())
                    XCTAssertEqual(self.game.tiles[Location(2, 0)]!, firstTile)
                    XCTAssertEqual(self.game.tiles.count, 1)
                },
                
                "should fall down when moved down": {
                    self.game.move(Down())
                    XCTAssertEqual(self.game.tiles[Location(2, 3)]!, firstTile)
                    XCTAssertEqual(self.game.tiles.count, 2)
                    XCTAssertEqual(self.game.tiles[Location(2, 1)]!, queuedTile)
                }
            ])
    }
    
    func testMoveTwoTilesOfSameValue() {
        var (firstTile, secondTile): (Tile!, Tile!)
        var queuedTile: Tile!
        
        describe("when two tiles of same value moved",
            beforeEach: {
                self.resetGame()
                firstTile = Tile(location: Location(2, 0), value: 1)
                secondTile = Tile(location: Location(3, 0), value: 1)
                queuedTile = Tile(location: Location(2, 1), value: 1)
                self.tileGenerator.nextTiles = [firstTile, secondTile, queuedTile]
                self.game.addTiles(2)
            }, [
                "should merge tiles aligned right when moved right": {
                    self.game.move(Right())
                    XCTAssertEqual(self.game.tiles[Location(3, 0)]!, firstTile)
                    XCTAssertEqual(firstTile.value, 3)
                    XCTAssertEqual(self.game.tiles.count, 2)
                    XCTAssertEqual(self.game.tiles[Location(2, 1)]!, queuedTile)
                },
                
                "should merge tiles and fall left when moved left": {
                    self.game.move(Left())
                    XCTAssertEqual(self.game.tiles[Location(0, 0)]!, secondTile)
                    XCTAssertEqual(secondTile.value, 3)
                    XCTAssertEqual(self.game.tiles.count, 2)
                    XCTAssertEqual(self.game.tiles[Location(2, 1)]!, queuedTile)
                },
                
                "should do nothing when moved up": {
                    self.game.move(Up())
                    XCTAssertEqual(self.game.tiles[Location(2, 0)]!, firstTile)
                    XCTAssertEqual(self.game.tiles[Location(3, 0)]!, secondTile)
                    XCTAssertEqual(self.game.tiles.count, 2)
                },
                
                "should fall down when moved down": {
                    self.game.move(Down())
                    XCTAssertEqual(self.game.tiles[Location(2, 3)]!, firstTile)
                    XCTAssertEqual(self.game.tiles[Location(3, 3)]!, secondTile)
                    XCTAssertEqual(self.game.tiles.count, 3)
                    XCTAssertEqual(self.game.tiles[Location(2, 1)]!, queuedTile)
                },
            ])
    }
    
    func testMoveTwoSeparatedTilesOfSameValue() {
        var (firstTile, secondTile): (Tile!, Tile!)
        var queuedTile: Tile!
        
        describe("when two tiles of same value moved",
            beforeEach: {
                self.resetGame()
                firstTile = Tile(location: Location(0, 0), value: 1)
                secondTile = Tile(location: Location(2, 0), value: 1)
                queuedTile = Tile(location: Location(2, 1), value: 1)
                self.tileGenerator.nextTiles = [secondTile, firstTile, queuedTile]
                self.game.addTiles(2)
            }, [
                "should merge tiles and fall right when moved right": {
                    self.game.move(Right())
                    XCTAssertEqual(self.game.tiles[Location(3, 0)]!, firstTile)
                    XCTAssertEqual(firstTile.value, 3)
                    XCTAssertEqual(self.game.tiles.count, 2)
                    XCTAssertEqual(self.game.tiles[Location(2, 1)]!, queuedTile)
                },
                
                "should merge tiles aligned left when moved left": {
                    self.game.move(Left())
                    XCTAssertEqual(self.game.tiles[Location(0, 0)]!, secondTile)
                    XCTAssertEqual(secondTile.value, 3)
                    XCTAssertEqual(self.game.tiles.count, 2)
                    XCTAssertEqual(self.game.tiles[Location(2, 1)]!, queuedTile)
                },
                
                "should do nothing when moved up": {
                    self.game.move(Up())
                    XCTAssertEqual(self.game.tiles[Location(2, 0)]!, secondTile)
                    XCTAssertEqual(self.game.tiles[Location(0, 0)]!, firstTile)
                    XCTAssertEqual(self.game.tiles.count, 2)
                },
                
                "should fall down when moved down": {
                    self.game.move(Down())
                    XCTAssertEqual(self.game.tiles[Location(2, 3)]!, secondTile)
                    XCTAssertEqual(self.game.tiles[Location(0, 3)]!, firstTile)
                    XCTAssertEqual(self.game.tiles.count, 3)
                    XCTAssertEqual(self.game.tiles[Location(2, 1)]!, queuedTile)
                },
            ])
    }
    
    func testMoveTwoSeparatedTilesOfDifferentValue() {
        var (firstTile, secondTile): (Tile!, Tile!)
        var queuedTile: Tile!
        
        describe("when two tiles of same value moved",
            beforeEach: {
                self.resetGame()
                firstTile = Tile(location: Location(0, 0), value: 1)
                secondTile = Tile(location: Location(2, 0), value: 3)
                queuedTile = Tile(location: Location(2, 1), value: 1)
                self.tileGenerator.nextTiles = [secondTile, firstTile, queuedTile]
                self.game.addTiles(2)
            }, [
                "should fall right when moved right": {
                    self.game.move(Right())
                    XCTAssertEqual(self.game.tiles[Location(2, 0)]!, firstTile)
                    XCTAssertEqual(self.game.tiles[Location(3, 0)]!, secondTile)
                    XCTAssertEqual(firstTile.value, 1)
                    XCTAssertEqual(secondTile.value, 3)
                    XCTAssertEqual(self.game.tiles.count, 3)
                    XCTAssertEqual(self.game.tiles[Location(2, 1)]!, queuedTile)
                },
                
                "should fall left when moved left": {
                    self.game.move(Left())
                    XCTAssertEqual(self.game.tiles[Location(0, 0)]!, firstTile)
                    XCTAssertEqual(self.game.tiles[Location(1, 0)]!, secondTile)
                    XCTAssertEqual(firstTile.value, 1)
                    XCTAssertEqual(secondTile.value, 3)
                    XCTAssertEqual(self.game.tiles.count, 3)
                    XCTAssertEqual(self.game.tiles[Location(2, 1)]!, queuedTile)
                },
                
                "should do nothing when moved up": {
                    self.game.move(Up())
                    XCTAssertEqual(self.game.tiles[Location(2, 0)]!, secondTile)
                    XCTAssertEqual(self.game.tiles[Location(0, 0)]!, firstTile)
                    XCTAssertEqual(self.game.tiles.count, 2)
                },
                
                "should fall down when moved down": {
                    self.game.move(Down())
                    XCTAssertEqual(self.game.tiles[Location(2, 3)]!, secondTile)
                    XCTAssertEqual(self.game.tiles[Location(0, 3)]!, firstTile)
                    XCTAssertEqual(self.game.tiles.count, 3)
                    XCTAssertEqual(self.game.tiles[Location(2, 1)]!, queuedTile)
                },
            ])
    }
}

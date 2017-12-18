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
    
    func newTile(_ availableSpaces: [Location]) -> Tile {
        let nextTile = self.nextTiles[0]
        self.nextTiles.remove(at: 0)
        return nextTile
    }
}

class GameTests: XCTestCase {
    var game = Game()
    let tileGenerator = PresetTileGenerator()
    
    func describe(_ identifier: String, beforeEach: () -> (), _ specs: [String: () -> ()]) {
        print("\n>>>>>> SPEC BEGIN: \(identifier) <<<<<<\n\n")
        for spec in specs {
            print("\(identifier) \(spec.0)")
            beforeEach()
            spec.1()
        }
        print("\n\n>>>>>> SPEC END: \(identifier) <<<<<<\n")
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
        var (firstTile, secondTile): (Tile?, Tile?)
        var queuedTile: Tile!
        
        describe("when two tiles of same value moved",
            beforeEach: {
                self.resetGame()
                firstTile = Tile(location: Location(2, 0), value: 1)
                secondTile = Tile(location: Location(3, 0), value: 1)
                queuedTile = Tile(location: Location(2, 1), value: 1)
                self.tileGenerator.nextTiles = [firstTile!, secondTile!, queuedTile]
                self.game.addTiles(2)
            }, [
                "should merge tiles aligned right when moved right": {
                    self.game.move(Right())
                    XCTAssertEqual(self.game.tiles[Location(3, 0)]!, firstTile)
                    XCTAssertEqual(firstTile?.value, 3)
                    XCTAssertEqual(self.game.tiles.count, 2)
                    XCTAssertEqual(self.game.tiles[Location(2, 1)]!, queuedTile)
                },
                
                "should merge tiles and fall left when moved left": {
                    self.game.move(Left())
                    XCTAssertEqual(self.game.tiles[Location(0, 0)]!, secondTile)
                    XCTAssertEqual(secondTile?.value, 3)
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
        var (firstTile, secondTile): (Tile?, Tile?)
        var queuedTile: Tile!
        
        describe("when two separated tiles of same value moved",
            beforeEach: {
                self.resetGame()
                firstTile = Tile(location: Location(0, 0), value: 1)
                secondTile = Tile(location: Location(2, 0), value: 1)
                queuedTile = Tile(location: Location(2, 1), value: 1)
                self.tileGenerator.nextTiles = [secondTile!, firstTile!, queuedTile]
                self.game.addTiles(2)
            }, [
                "should merge tiles and fall right when moved right": {
                    self.game.move(Right())
                    XCTAssertEqual(self.game.tiles[Location(3, 0)]!, firstTile)
                    XCTAssertEqual(firstTile?.value, 3)
                    XCTAssertEqual(self.game.tiles.count, 2)
                    XCTAssertEqual(self.game.tiles[Location(2, 1)]!, queuedTile)
                },
                
                "should merge tiles aligned left when moved left": {
                    self.game.move(Left())
                    XCTAssertEqual(self.game.tiles[Location(0, 0)]!, secondTile)
                    XCTAssertEqual(secondTile?.value, 3)
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
        var (firstTile, secondTile): (Tile?, Tile?)
        var queuedTile: Tile!
        
        describe("when two separated tiles of different value moved",
            beforeEach: {
                self.resetGame()
                firstTile = Tile(location: Location(0, 0), value: 1)
                secondTile = Tile(location: Location(2, 0), value: 3)
                queuedTile = Tile(location: Location(2, 1), value: 1)
                self.tileGenerator.nextTiles = [secondTile!, firstTile!, queuedTile]
                self.game.addTiles(2)
            }, [
                "should fall right when moved right": {
                    self.game.move(Right())
                    XCTAssertEqual(self.game.tiles[Location(2, 0)]!, firstTile)
                    XCTAssertEqual(self.game.tiles[Location(3, 0)]!, secondTile)
                    XCTAssertEqual(firstTile?.value, 1)
                    XCTAssertEqual(secondTile?.value, 3)
                    XCTAssertEqual(self.game.tiles.count, 3)
                    XCTAssertEqual(self.game.tiles[Location(2, 1)]!, queuedTile)
                },
                
                "should fall left when moved left": {
                    self.game.move(Left())
                    XCTAssertEqual(self.game.tiles[Location(0, 0)]!, firstTile)
                    XCTAssertEqual(self.game.tiles[Location(1, 0)]!, secondTile)
                    XCTAssertEqual(firstTile?.value, 1)
                    XCTAssertEqual(secondTile?.value, 3)
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
    
    func testMoveThreeParallelTilesOfSameValue() {
        var (firstTile, secondTile, thirdTile): (Tile?, Tile?, Tile?)
        var queuedTile: Tile!
        
        describe("when three parallel tiles of same value moved",
            beforeEach: {
                self.resetGame()
                firstTile = Tile(location: Location(0, 0), value: 1)
                secondTile = Tile(location: Location(2, 0), value: 1)
                thirdTile = Tile(location: Location(3, 0), value: 1)
                queuedTile = Tile(location: Location(2, 1), value: 1)
                self.tileGenerator.nextTiles = [firstTile!, secondTile!, thirdTile!, queuedTile]
                self.game.addTiles(3)
            }, [
                "should fall right and merge right two tiles when moved right": {
                    self.game.move(Right())
                    XCTAssertEqual(self.game.tiles[Location(2, 0)]!, firstTile)
                    XCTAssertEqual(self.game.tiles[Location(3, 0)]!, secondTile)
                    XCTAssertEqual(firstTile?.value, 1)
                    XCTAssertEqual(secondTile?.value, 3)
                    XCTAssertEqual(self.game.tiles.count, 3)
                    XCTAssertEqual(self.game.tiles[Location(2, 1)]!, queuedTile)
                },
                
                "should fall left and merge left two tiles when moved left": {
                    self.game.move(Left())
                    XCTAssertEqual(self.game.tiles[Location(0, 0)]!, secondTile)
                    XCTAssertEqual(self.game.tiles[Location(1, 0)]!, thirdTile)
                    XCTAssertEqual(secondTile?.value, 3)
                    XCTAssertEqual(thirdTile?.value, 1)
                    XCTAssertEqual(self.game.tiles.count, 3)
                    XCTAssertEqual(self.game.tiles[Location(2, 1)]!, queuedTile)
                },
                
                "should do nothing when moved up": {
                    self.game.move(Up())
                    XCTAssertEqual(self.game.tiles[Location(0, 0)]!, firstTile)
                    XCTAssertEqual(self.game.tiles[Location(2, 0)]!, secondTile)
                    XCTAssertEqual(self.game.tiles[Location(3, 0)]!, thirdTile)
                    XCTAssertEqual(firstTile?.value, 1)
                    XCTAssertEqual(secondTile?.value, 1)
                    XCTAssertEqual(thirdTile?.value, 1)
                    XCTAssertEqual(self.game.tiles.count, 3)
                },
                
                "should fall down when moved down": {
                    self.game.move(Down())
                    XCTAssertEqual(self.game.tiles[Location(0, 3)]!, firstTile)
                    XCTAssertEqual(self.game.tiles[Location(2, 3)]!, secondTile)
                    XCTAssertEqual(self.game.tiles[Location(3, 3)]!, thirdTile)
                    XCTAssertEqual(firstTile?.value, 1)
                    XCTAssertEqual(secondTile?.value, 1)
                    XCTAssertEqual(thirdTile?.value, 1)
                    XCTAssertEqual(self.game.tiles.count, 4)
                    XCTAssertEqual(self.game.tiles[Location(2, 1)]!, queuedTile)
                }
            ])
    }
    
    func testAdvancedCase() {
        var (row1Tile1, row1Tile2, row1Tile3): (Tile?, Tile?, Tile?)
        var (row2Tile1, row2Tile2): (Tile?, Tile?)
        var row3Tile1: Tile!
        var (row4Tile1, row4Tile2): (Tile?, Tile?)
        var (queuedTile1, queuedTile2, queuedTile3, queuedTile4): (Tile?, Tile?, Tile?, Tile?)
        
        describe("advanced case",
            beforeEach: {
                row1Tile1 = Tile(location: Location(0, 0), value: 3)
                row1Tile2 = Tile(location: Location(2, 0), value: 3)
                row1Tile3 = Tile(location: Location(3, 0), value: 127)
                row2Tile1 = Tile(location: Location(2, 1), value: 7)
                row2Tile2 = Tile(location: Location(3, 1), value: 31)
                row3Tile1 = Tile(location: Location(3, 2), value: 31)
                row4Tile1 = Tile(location: Location(2, 3), value: 15)
                row4Tile2 = Tile(location: Location(3, 3), value: 63)
                queuedTile1 = Tile(location: Location(0, 0), value: 1)
                queuedTile2 = Tile(location: Location(1, 1), value: 3)
                queuedTile3 = Tile(location: Location(1, 3), value: 3)
                queuedTile4 = Tile(location: Location(0, 1), value: 1)
                
                self.tileGenerator.nextTiles = [
                    row1Tile1!, row1Tile2!, row1Tile3!, row2Tile1!, row2Tile2!, row3Tile1, row4Tile1!, row4Tile2!,
                    queuedTile1!, queuedTile2!, queuedTile3!, queuedTile4!
                ]
                self.resetGame()
                self.game.addTiles(8)
            }, [
                "should properly setup game": {
                    // 3  _  3  127
                    // _  _  7  31
                    // _  _  _  31
                    // _  _  15 63
                    
                    XCTAssertEqual(self.game.tiles[Location(0, 0)]!.value, 3)
                    XCTAssertEqual(self.game.tiles[Location(2, 0)]!.value, 3)
                    XCTAssertEqual(self.game.tiles[Location(3, 0)]!.value, 127)
                    XCTAssertEqual(self.game.tiles[Location(2, 1)]!.value, 7)
                    XCTAssertEqual(self.game.tiles[Location(3, 1)]!.value, 31)
                    XCTAssertEqual(self.game.tiles[Location(3, 2)]!.value, 31)
                    XCTAssertEqual(self.game.tiles[Location(2, 3)]!.value, 15)
                    XCTAssertEqual(self.game.tiles[Location(3, 3)]!.value, 63)
                    XCTAssertEqual(self.game.tiles.count, 8)
                    XCTAssertEqual(self.game.score, 0)
                },
                
                "should properly place tiles after first move": {
                    // ->
                    
                    // 1  _  7  127
                    // _  _  7  31
                    // _  _  _  31
                    // _  _  15 63
                    
                    self.game.move(Right())
                    XCTAssertEqual(self.game.tiles[Location(0, 0)]!.value, 1)
                    XCTAssertEqual(self.game.tiles[Location(2, 0)]!.value, 7)
                    XCTAssertEqual(self.game.tiles[Location(3, 0)]!.value, 127)
                    XCTAssertEqual(self.game.tiles[Location(2, 1)]!.value, 7)
                    XCTAssertEqual(self.game.tiles[Location(3, 1)]!.value, 31)
                    XCTAssertEqual(self.game.tiles[Location(3, 2)]!.value, 31)
                    XCTAssertEqual(self.game.tiles[Location(2, 3)]!.value, 15)
                    XCTAssertEqual(self.game.tiles[Location(3, 3)]!.value, 63)
                    XCTAssertEqual(self.game.tiles.count, 8)
                    XCTAssertEqual(self.game.score, 7)
                },
                
                "should properly place tiles after second move": {
                    // ^
                    
                    // 1  _  15 127
                    // _  3  15 63
                    // _  _  _  63
                    // _  _  _  _
                    
                    self.game.move(Right())
                    self.game.move(Up())
                    XCTAssertEqual(self.game.tiles[Location(0, 0)]!.value, 1)
                    XCTAssertEqual(self.game.tiles[Location(2, 0)]!.value, 15)
                    XCTAssertEqual(self.game.tiles[Location(3, 0)]!.value, 127)
                    XCTAssertEqual(self.game.tiles[Location(1, 1)]!.value, 3)
                    XCTAssertEqual(self.game.tiles[Location(2, 1)]!.value, 15)
                    XCTAssertEqual(self.game.tiles[Location(3, 1)]!.value, 63)
                    XCTAssertEqual(self.game.tiles[Location(3, 2)]!.value, 63)
                    XCTAssertEqual(self.game.tiles.count, 7)
                    XCTAssertEqual(self.game.score, 7 + 16 + 64)
                },
                
                "should properly place tiles after third move": {
                    // ^
                    
                    // 1  3  31 127
                    // _  _  _  127
                    // _  _  _  _
                    // _  3  _  _
                    
                    self.game.move(Right())
                    self.game.move(Up())
                    self.game.move(Up())
                    XCTAssertEqual(self.game.tiles[Location(0, 0)]!.value, 1)
                    XCTAssertEqual(self.game.tiles[Location(1, 0)]!.value, 3)
                    XCTAssertEqual(self.game.tiles[Location(2, 0)]!.value, 31)
                    XCTAssertEqual(self.game.tiles[Location(3, 0)]!.value, 127)
                    XCTAssertEqual(self.game.tiles[Location(3, 1)]!.value, 127)
                    XCTAssertEqual(self.game.tiles[Location(1, 3)]!.value, 3)
                    XCTAssertEqual(self.game.tiles.count, 6)
                    XCTAssertEqual(self.game.score, 7 + 16 + 64 + 32 + 128)
                },
                
                "should properly place tiles after fourth move": {
                    // ^
                    
                    // 1  7  31 255
                    // 1  _  _  _
                    // _  _  _  _
                    // _  _  _  _
                    
                    self.game.move(Right())
                    self.game.move(Up())
                    self.game.move(Up())
                    self.game.move(Up())
                    XCTAssertEqual(self.game.tiles[Location(0, 0)]!.value, 1)
                    XCTAssertEqual(self.game.tiles[Location(1, 0)]!.value, 7)
                    XCTAssertEqual(self.game.tiles[Location(2, 0)]!.value, 31)
                    XCTAssertEqual(self.game.tiles[Location(3, 0)]!.value, 255)
                    XCTAssertEqual(self.game.tiles[Location(0, 1)]!.value, 1)
                    XCTAssertEqual(self.game.tiles.count, 5)
                    XCTAssertEqual(self.game.score, 7 + 16 + 64 + 32 + 128 + 8 + 256)
                }
            ])
    }
    
    // end of game isn't implemented yet because it's actually pretty hard to do.
    // working theory is that the game will be passed the available moves and
    // will then create a deep copy of itself, trying each move until the two
    // games in comparison are not equal. If the games remain equal for each move
    // the game is over.
    /*
    func testEndgame() {
        let bigTile = Tile(location: Location(0, 0), value: 31)
        let biggestTile = Tile(location: Location(0, 1), value: 63)
        let smallTile1 = Tile(location: Location(1, 0), value: 3)
        let smallTile2 = Tile(location: Location(1, 1), value: 3)
        let queuedTile = Tile(location: Location(1, 1), value: 1)
        
        self.tileGenerator.nextTiles = [bigTile, biggestTile, smallTile1, smallTile2, queuedTile]
        self.game.board = Board(2, 2)
        self.game.addTiles(4)
        self.game.move(Up())
        
        XCTAssert(game.isOver(availableMoves: [Up(), Down(), Left(), Right()])
    }*/
}

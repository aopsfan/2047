//
//  Game.swift
//  2047
//
//  Created by Bruce Ricketts on 7/17/14.
//  Copyright (c) 2014 fireypotato. All rights reserved.
//

import Foundation

protocol TileGenerationStrategy {
    func newTile(availableSpaces: [Location]) -> Tile
}

class RandomTileGenerator : TileGenerationStrategy {
    func newTile(availableSpaces: [Location]) -> Tile {
        let locationIndex = arc4random() % UInt32(availableSpaces.count)
        let location = availableSpaces[Int(locationIndex)]
        
        let availableValues = [2, 4]
        let valueIndex = arc4random() % 2
        let value = availableValues[Int(valueIndex)]
        
        return Tile(location: location, value: value)
    }
}

class Game {
    var board = Board(4, 4)
    var tiles = [Location: Tile]()
    var score = 0
    var tileGenerationStrategy: TileGenerationStrategy = RandomTileGenerator()
    
    func addTiles(numberOfTiles: Int) {
        for _ in 0..<numberOfTiles {
            let tile = self.tileGenerationStrategy.newTile(_availableSpaces())
            self.tiles[tile.location] = tile
        }
    }
    
    func move(move: Move) {
        var tileMovedThisIteration = false
        
        do {
            _moveOnce(move) { anyTileMoved in
                tileMovedThisIteration = anyTileMoved
            }
        } while tileMovedThisIteration == true
        
        self.addTiles(1)
    }
    
    func _moveOnce(move: Move, _ finished: (anyTileMoved: Bool) -> ()) {
        let sortedLocations = sorted(self.board.allLocations()) {
            return move.locationBeforeLocation($0, $1)
        } // TODO: this is calculated way to often
        
        var anyTileMoved = false
        
        for fromLocation in sortedLocations {
            let tile = self.tiles[fromLocation]
            
            if tile {
                _moveSingleTileOnce(fromLocation, tile!, move) { moved in
                    if moved { anyTileMoved = true }
                }
            }
        }
        
        finished(anyTileMoved: anyTileMoved)
    }
    
    func _moveSingleTileOnce(fromLocation: Location, _ tile: Tile, _ move: Move, _ finished: (moved: Bool) -> ()) {
        let toLocation = Location(fromLocation.x + move.vector().xDistance, fromLocation.y + move.vector().yDistance)
        let toTile = self.tiles[toLocation]
        
        if !contains(self.board.allLocations(), toLocation) { // Tile is already at edge of board
            finished(moved: false)
            return
        }
        
        tile.goTo(toLocation, impedingTile: toTile) { (moved, merged) in
            self.tiles[fromLocation] = nil
            self.tiles[toLocation] = tile
            finished(moved: moved)
        }
    }
    
    func _availableSpaces() -> [Location] {
        return self.board.allLocations().filter {
            return self.tiles[$0] == nil
        }
    }
}
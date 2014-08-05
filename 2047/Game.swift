//
//  Game.swift
//  2047
//
//  Created by Bruce Ricketts on 7/17/14.
//  Copyright (c) 2014 fireypotato. All rights reserved.
//

import Foundation

protocol GameDelegate {
    func game(game: Game, didAddTile tile: Tile)
    func game(game: Game, didMoveTile tile: Tile, from fromLocation: Location)
    func game(game: Game, didUpdateScore score: Int)
}

protocol TileGenerationStrategy {
    func newTile(availableSpaces: [Location]) -> Tile
}

class RandomTileGenerator : TileGenerationStrategy {
    func newTile(availableSpaces: [Location]) -> Tile {
        let locationIndex = arc4random() % UInt32(availableSpaces.count)
        let location = availableSpaces[Int(locationIndex)]
        
        let availableValues = [1, 3]
        let valueIndex = arc4random() % 2
        let value = availableValues[Int(valueIndex)]
        
        return Tile(location: location, value: value)
    }
}

class Game {
    var board = Board(4, 4)
    var tiles = [Location: Tile]()
    var _trueScore = -1
    var score: Int { return max(0, _trueScore) }
    var tileGenerationStrategy: TileGenerationStrategy = RandomTileGenerator()
    var delegate: GameDelegate? = nil
    
    func addTiles(numberOfTiles: Int) {
        for _ in 0..<numberOfTiles {
            let tile = self.tileGenerationStrategy.newTile(_availableSpaces())
            self.tiles[tile.location] = tile
            
            if delegate {
                delegate!.game(self, didAddTile: tile)
            }
        }
    }
    
    func move(move: Move) {
        var anyTileMoved = false
        
        let sortedLocations = sorted(self.board.allLocations()) {
            return move.locationBeforeLocation($0, $1)
        }
        
        for fromLocation in sortedLocations {
            let tile = self.tiles[fromLocation]
            if !tile { continue }
            if _moveTile(tile!, move: move) {
                if self.delegate {
                    self.delegate!.game(self, didMoveTile: tile!, from: fromLocation)
                }
                anyTileMoved = true
            }
        }
        
        if anyTileMoved {
            for (_, tile) in tiles { tile.canMerge = true }
            self.addTiles(1)
        }
    }
    
    func _moveTile(tile: Tile, move: Move) -> Bool {
        var tileMoved = false
        var tileMovedThisIteration = false
        
        do {
            tileMovedThisIteration = _moveTileOnce(tile, move: move)
            tileMoved = tileMoved || tileMovedThisIteration
        } while tileMovedThisIteration
        
        return tileMoved
    }
    
    func _moveTileOnce(tile: Tile, move: Move) -> Bool { // return whether tile moved
        let fromLocation = tile.location
        let toLocation = Location(fromLocation.x + move.vector().xDistance, fromLocation.y + move.vector().yDistance)
        let toTile = self.tiles[toLocation]
        
        if !contains(self.board.allLocations(), toLocation) { // Tile is already at edge of board
            return false
        }
        
        tile.goTo(toLocation, impedingTile: toTile) { (moved, merged) in
            if merged {
                self._trueScore += tile.value + 1
                tile.canMerge = false
                
                if self.delegate {
                    self.delegate!.game(self, didUpdateScore: self.score)
                }
            }
            if moved {
                self.tiles[fromLocation] = nil
                self.tiles[toLocation] = tile
            }
        }
        
        return tile.location == toLocation
    }
    
    func _availableSpaces() -> [Location] {
        return self.board.allLocations().filter {
            return self.tiles[$0] == nil
        }
    }
}
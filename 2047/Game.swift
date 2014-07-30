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
    var logsMoves = false
    
    func addTiles(numberOfTiles: Int) {
        for _ in 0..<numberOfTiles {
            let tile = self.tileGenerationStrategy.newTile(_availableSpaces())
            self.tiles[tile.location] = tile
        }
    }
    
    func move(move: Move) {
        if logsMoves { println("\nmoving \(move) {") }
        var tileMoved = false
        var tileMovedThisIteration = false
        
        do {
            _moveOnce(move) { anyTileMoved in
                tileMovedThisIteration = anyTileMoved
                tileMoved = anyTileMoved || tileMoved
            }
        } while tileMovedThisIteration == true
        
        if tileMoved { self.addTiles(1); if logsMoves { println("\tadding next tile") } }
        if logsMoves {
            println("}")
            var formattedTiles = Dictionary<String, String>()
            for (location, tile) in tiles {
                formattedTiles[location.stringValue()] = tile.stringValue()
            }
            
            println("tiles are \(formattedTiles)\n")
        }
    }
    
    func _moveOnce(move: Move, _ finished: (anyTileMoved: Bool) -> ()) {
        if logsMoves { println("\tmoving once {") }
        let sortedLocations = sorted(self.board.allLocations()) {
            return move.locationBeforeLocation($0, $1)
        } // TODO: this is calculated way to often
        
        var anyTileMoved = false
        
        for fromLocation in sortedLocations {
            let tile = self.tiles[fromLocation]
            
            if tile {
                _moveSingleTileOnce(fromLocation, tile!, move) { moved in
                    anyTileMoved = moved || anyTileMoved
                }
            }
        }
        
        finished(anyTileMoved: anyTileMoved)
        if logsMoves { println("\t}") }
    }
    
    func _moveSingleTileOnce(fromLocation: Location, _ tile: Tile, _ move: Move, _ finished: (moved: Bool) -> ()) {
        if logsMoves { println("\t\tmoving single tile once {") }
        let toLocation = Location(fromLocation.x + move.vector().xDistance, fromLocation.y + move.vector().yDistance)
        let toTile = self.tiles[toLocation]
        
        if logsMoves {
            println("\t\t\ttile: \(tile.stringValue())")
            println("\t\t\tto location: \(toLocation.stringValue())")
            let toTileStringValue = toTile ? toTile!.stringValue() : "no impeding tile"
            println("\t\t\timpeding tile: \(toTileStringValue)")
            println("\t\t\tstatus {")
        }
        
        if !contains(self.board.allLocations(), toLocation) { // Tile is already at edge of board
            finished(moved: false)
            if logsMoves {
                println("\t\t\t\tnot moving because tile is at edge of board")
                println("\t\t\t}\n\t\t}")
            }
            return
        }
        
        tile.goTo(toLocation, impedingTile: toTile) { (moved, merged) in
            if self.logsMoves {
                println("\t\t\t\tmoved: \(moved)")
                println("\t\t\t\tmerged: \(merged)")
            }
            if moved {
                self.tiles[fromLocation] = nil
                self.tiles[toLocation] = tile
            }
            finished(moved: moved)
        }
        if logsMoves { println("\t\t\t}\n\t\t}") }
    }
    
    func _availableSpaces() -> [Location] {
        return self.board.allLocations().filter {
            return self.tiles[$0] == nil
        }
    }
}
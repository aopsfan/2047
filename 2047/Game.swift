//
//  Game.swift
//  2047
//
//  Created by Bruce Ricketts on 7/17/14.
//  Copyright (c) 2014 fireypotato. All rights reserved.
//

import Foundation

protocol GameDelegate {
    func game(_ game: Game, didAddTile tile: Tile)
    func game(_ game: Game, didMoveTile tile: Tile, from fromLocation: Location)
    func game(_ game: Game, didUpdateScore score: Int)
}

protocol TileGenerationStrategy {
    func newTile(_ availableSpaces: [Location]) -> Tile
}

class RandomTileGenerator : TileGenerationStrategy {
    func newTile(_ availableSpaces: [Location]) -> Tile {
        let locationIndex = arc4random() % UInt32(availableSpaces.count)
        let location = availableSpaces[Int(locationIndex)]
        
        let valueIndex = arc4random() % 10
        let value = Int(valueIndex) == 1 ? 4 : 2
        
        return Tile(location: location, value: value)
    }
}

class Game {
    var board = Board(4, 4)
    var tiles = [Location: Tile]()
    var score = 0
    var tileGenerationStrategy: TileGenerationStrategy = RandomTileGenerator()
    var delegate: GameDelegate? = nil
    var mergeRule = DoublePlusOneMergeRule()
    
    func addTiles(_ numberOfTiles: Int) {
        for _ in 0..<numberOfTiles {
            let tile = self.tileGenerationStrategy.newTile(_availableSpaces())
            self.tiles[tile.location] = tile
            
            if delegate != nil {
                delegate!.game(self, didAddTile: tile)
            }
        }
    }
    
    func isOver(availableDirections: [Direction]) -> Bool {
        if _availableSpaces().count > 0 { return false }
        
        let notOver = board.allLocations().reduce(false) { (canMergeYet, location) in
            if canMergeYet { return canMergeYet }
            
            let tile = self.tiles[location]! // this can't be nil or the method will have alread returned
            return availableDirections.reduce(false) { (canMergeYet, direction) in
                return canMergeYet || self._tileCanMerge(tile, direction: direction)
            }
        }
        
        return !notOver
    }
    
    func _tileCanMerge(_ tile: Tile, direction: Direction) -> Bool {
        let blockingTile = self.tiles[tile.location + direction.vector()]
        return blockingTile != nil && mergeRule.valueByMergingTiles([tile, blockingTile!]) != nil
    }
    
    func move(_ direction: Direction) {
        var anyTileMoved = false
        
        let sortedLocations = board.allLocations().sorted {
            return direction.locationBeforeLocation($0, $1)
        }
        
        for fromLocation in sortedLocations {
            let tile = self.tiles[fromLocation]
            if tile == nil { continue }
            if _moveTile(tile!, direction: direction) {
                if self.delegate != nil {
                    self.delegate!.game(self, didMoveTile: tile!, from: fromLocation)
                }
                anyTileMoved = true
            }
        }
        
        if anyTileMoved {
            for (_, tile) in tiles { tile.enableMerging() }
            self.addTiles(1)
        }
    }
    
    func _moveTile(_ tile: Tile, direction: Direction) -> Bool {
        var tileMoved = false
        var tileMovedThisIteration = false
        
        repeat {
            tileMovedThisIteration = _moveTileOnce(tile, direction: direction)
            tileMoved = tileMoved || tileMovedThisIteration
        } while tileMovedThisIteration
        
        return tileMoved
    }
    
    func _moveTileOnce(_ tile: Tile, direction: Direction) -> Bool { // return whether tile moved
        let fromLocation = tile.location
        let toLocation = Location(fromLocation.x + direction.vector().xDistance, fromLocation.y + direction.vector().yDistance)
        let toTile = self.tiles[toLocation]
        
        if !self.board.allLocations().contains(toLocation) { return false }
        
        if tile.moveBy(direction.vector(), blockingTile: toTile, mergeRule: mergeRule) {
            if toTile != nil { // merged
                score += tile.value
                if self.delegate != nil { self.delegate!.game(self, didUpdateScore: self.score) }
            }
            
            self.tiles[fromLocation] = nil
            self.tiles[toLocation] = tile
        }
        
        return tile.location == toLocation
    }
    
    func _availableSpaces() -> [Location] {
        return self.board.allLocations().filter {
            return self.tiles[$0] == nil
        }
    }
}

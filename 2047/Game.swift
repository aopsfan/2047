//
//  Game.swift
//  2047
//
//  Created by Bruce Ricketts on 7/17/14.
//  Copyright (c) 2014 fireypotato. All rights reserved.
//

import Foundation

class Game {
    var board = Board(4, 4)
    var tiles = [Location: Tile]()
    var score = 0
}
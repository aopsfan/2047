//
//  DoublePlusOneMergeRule.swift
//  2047
//
//  Created by Bruce Ricketts on 8/15/14.
//  Copyright (c) 2014 fireypotato. All rights reserved.
//

import Foundation

class DoublePlusOneMergeRule: TileMergeRule {
    func valueByMergingTiles(_ tiles: [Tile]) -> Int? {
        return tiles[0].value == tiles[1].value ? tiles[0].value * 2 : nil
    }
}

//
//  TileMergeRule.swift
//  2047
//
//  Created by Bruce Ricketts on 8/15/14.
//  Copyright (c) 2014 fireypotato. All rights reserved.
//

import Foundation

protocol TileMergeRule {
    func valueByMergingTiles(_ tiles: [Tile]) -> Int?
}

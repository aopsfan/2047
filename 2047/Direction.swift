//
//  Direction.swift
//  2047
//
//  Created by Bruce Ricketts on 7/20/14.
//  Copyright (c) 2014 fireypotato. All rights reserved.
//

import Foundation

protocol Direction {
    func vector() -> Vector
    func locationBeforeLocation(_ location1: Location, _ location2: Location) -> Bool
}

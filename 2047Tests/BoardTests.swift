//
//  BoardTests.swift
//  2047
//
//  Created by Bruce Ricketts on 7/19/14.
//  Copyright (c) 2014 fireypotato. All rights reserved.
//

import UIKit
import XCTest

class BoardTests: XCTestCase {

    func test2x2() {
        let board = Board(2, 2)
        let locations = board.allLocations()
        
        XCTAssertEqual(locations.count, 4)
        XCTAssert(locations.contains(Location(0, 0)))
        XCTAssert(locations.contains(Location(0, 1)))
        XCTAssert(locations.contains(Location(1, 0)))
        XCTAssert(locations.contains(Location(1, 1)))
    }

}

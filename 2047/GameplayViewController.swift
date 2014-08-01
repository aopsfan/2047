//
//  ViewController.swift
//  2047
//
//  Created by Bruce Ricketts on 7/17/14.
//  Copyright (c) 2014 fireypotato. All rights reserved.
//

import UIKit

class GameplayViewController : UIViewController, GameDelegate {
    var gridView: TileGridView { return self.view as TileGridView }
    var game = Game()
    
    func game(game: Game, didAdd tile: Tile) {
        gridView.addTileViewAt(tile.location, withLabel: "\(tile.value)")
    }
    
    func game(game: Game, didMove tile: Tile, from fromLocation: Location) {
        gridView.moveTileViewAt(fromLocation, to: tile.location)
        gridView.setLabelTextForTileAt(tile.location, labelText: "\(tile.value)")
    }
    
    func game(game: Game, didRemoveTileAt location: Location) {
        gridView.removeTileAt(location)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        game.delegate = self
        game.addTiles(2)
        
        let upRecognizer = UISwipeGestureRecognizer(target: self, action: "swipeUp")
        let downRecognizer = UISwipeGestureRecognizer(target: self, action: "swipeDown")
        let rightRecognizer = UISwipeGestureRecognizer(target: self, action: "swipeRight")
        let leftRecognizer = UISwipeGestureRecognizer(target: self, action: "swipeLeft")
        upRecognizer.direction = UISwipeGestureRecognizerDirection.Up
        downRecognizer.direction = UISwipeGestureRecognizerDirection.Down
        rightRecognizer.direction = UISwipeGestureRecognizerDirection.Right
        leftRecognizer.direction = UISwipeGestureRecognizerDirection.Left
        
        for recognizer in [upRecognizer, downRecognizer, rightRecognizer, leftRecognizer] {
            self.view.addGestureRecognizer(recognizer)
        }
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func swipeUp() {
        game.move(Up())
    }
    
    func swipeDown() {
        game.move(Down())
    }
    
    func swipeRight() {
        game.move(Right())
    }
    
    func swipeLeft() {
        game.move(Left())
    }
}


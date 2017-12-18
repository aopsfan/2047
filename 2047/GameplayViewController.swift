//
//  ViewController.swift
//  2047
//
//  Created by Bruce Ricketts on 7/17/14.
//  Copyright (c) 2014 fireypotato. All rights reserved.
//

import UIKit

class GameplayViewController : UIViewController, GameDelegate {
    @IBOutlet var gridView: TileGridView!
    @IBOutlet var scoreLabel: UILabel!
    var game = Game()
    let appearanceSources: [TileAppearance] = [
        OrangeAppearance(),
        GreyAppearance(),
        SkyBlueAppearance(),
        CyanAppearance(),
        MagentaAppearance(),
        GreenAppearance(),
        RedAppearance(),
        PurpleAppearance(),
        BlackAppearance()
    ]
    
    func game(_ game: Game, didAddTile tile: Tile) {
        gridView.addTileViewAt(tile.location, withLabel: "\(tile.value)", appearanceSource: appearanceSourceFor(tile.value))
    }
    
    func game(_ game: Game, didMoveTile tile: Tile, from fromLocation: Location) {
        gridView.moveTileViewAt(fromLocation, to: tile.location, appearanceSource: appearanceSourceFor(tile.value))
        gridView.setLabelTextForTileAt(tile.location, labelText: "\(tile.value)")
    }
    
    func game(_ game: Game, didUpdateScore score: Int) {
        refreshScore()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        game.delegate = self
        game.addTiles(2)
        
        refreshScore()
        
        let upRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeUp))
        let downRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeDown))
        let rightRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeRight))
        let leftRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeLeft))
        upRecognizer.direction = UISwipeGestureRecognizerDirection.up
        downRecognizer.direction = UISwipeGestureRecognizerDirection.down
        rightRecognizer.direction = UISwipeGestureRecognizerDirection.right
        leftRecognizer.direction = UISwipeGestureRecognizerDirection.left
        
        for recognizer in [upRecognizer, downRecognizer, rightRecognizer, leftRecognizer] {
            self.view.addGestureRecognizer(recognizer)
        }
    }
    
    @objc func swipeUp() {
        move(Up())
    }
    
    @objc func swipeDown() {
        move(Down())
    }
    
    @objc func swipeRight() {
        move(Right())
    }
    
    @objc func swipeLeft() {
        move(Left())
    }
    
    func appearanceSourceFor(_ value: Int) -> TileAppearance {
        return appearanceSources.filter({ $0.availableFor(value) })[0]
    }
    
    func refreshScore() {
        scoreLabel.text = "\(game.score)"
    }
    
    func move(_ direction: Direction) {
        gridView.animate {
            self.game.move(direction)
        }
    }
}


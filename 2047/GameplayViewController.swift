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
    
    func game(game: Game, didAddTile tile: Tile) {
        gridView.addTileViewAt(tile.location, withLabel: "\(tile.value)", appearanceSource: appearanceSourceFor(tile.value))
    }
    
    func game(game: Game, didMoveTile tile: Tile, from fromLocation: Location) {
        gridView.moveTileViewAt(fromLocation, to: tile.location, appearanceSource: appearanceSourceFor(tile.value))
        gridView.setLabelTextForTileAt(tile.location, labelText: "\(tile.value)")
    }
    
    func game(game: Game, didUpdateScore score: Int) {
        refreshScore()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        game.delegate = self
        game.addTiles(2)
        
        refreshScore()
        
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
        move(Up())
    }
    
    func swipeDown() {
        move(Down())
    }
    
    func swipeRight() {
        move(Right())
    }
    
    func swipeLeft() {
        move(Left())
    }
    
    func appearanceSourceFor(value: Int) -> TileAppearance {
        return appearanceSources.filter({ $0.availableFor(value) })[0]
    }
    
    func refreshScore() {
        scoreLabel.text = "\(game.score)"
    }
    
    func move(move: Move) {
        gridView.animate {
            self.game.move(move)
        }
    }
}


//
//  TileGridView.swift
//  2047
//
//  Created by Bruce Ricketts on 8/1/14.
//  Copyright (c) 2014 fireypotato. All rights reserved.
//

import UIKit

class TileGridView: UIView {
    let tileViewSize = CGSize(width: 80, height: 80)
    let margin = 0
    var tileViews = [Location: TileView]()
    var _coveredTileViews = [TileView]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // Initialization code
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    func animate(animations: @escaping () -> ()) {
        UIView.animate(withDuration: 0.1, animations: animations, completion: { completed in
            self.removeCoveredTileViews()
            })
    }
    
    func removeCoveredTileViews() {
        for tileView in _coveredTileViews {
            tileView.removeFromSuperview()
        }
        
        _coveredTileViews.removeAll()
    }
    
    func addTileViewAt(_ location: Location, withLabel label: String, appearanceSource: TileAppearance) {
        let tileView = TileView(frame: _frameFor(location), appearanceSource: appearanceSource)
        tileView.labelText = label
        tileViews[location] = tileView
        
        // fade-in animation
        tileView.alpha = 0.0
        self.insertSubview(tileView, at: 0)
        tileView.alpha = 1.0
    }
    
    func removeTileAt(_ location: Location) {
        let tileView = tileViews[location]
        tileView!.removeFromSuperview()
        tileViews[location] = nil
    }
    
    func moveTileViewAt(_ fromLocation: Location, to toLocation: Location, appearanceSource: TileAppearance) {
        let tileView = tileViews[fromLocation]
        self.bringSubview(toFront: tileView!)
        tileView!.frame = _frameFor(toLocation)
        tileView!.configureWith(appearanceSource)
        tileViews[fromLocation] = nil
        
        let oldTileView = tileViews[toLocation]
        if oldTileView != nil { _coveredTileViews.append(oldTileView!) }
        tileViews[toLocation] = tileView
    }
    
    func setLabelTextForTileAt(_ location: Location, labelText: String) {
        tileViews[location]!.labelText = labelText
    }

    func _frameFor(_ location: Location) -> CGRect {
        let xMargin = CGFloat((location.x + 1) * margin)
        let yMargin = CGFloat((location.y + 1) * margin)
        let leadingXTileSpace = CGFloat(location.x) * tileViewSize.width
        let leadingYTileSpace = CGFloat(location.y) * tileViewSize.height
        
        let origin = CGPoint(x: xMargin + leadingXTileSpace, y: yMargin + leadingYTileSpace)
        return CGRect(x: origin.x, y: origin.y, width: tileViewSize.width, height: tileViewSize.height)
    }
}

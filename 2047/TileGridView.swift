//
//  TileGridView.swift
//  2047
//
//  Created by Bruce Ricketts on 8/1/14.
//  Copyright (c) 2014 fireypotato. All rights reserved.
//

import UIKit

class TileGridView: UIView {
    let tileViewSize = CGSizeMake(70, 70)
    let margin = 8
    var tileViews = [Location: TileView]()
    
    init(frame: CGRect) {
        super.init(frame: frame)
        // Initialization code
    }
    
    init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
    }
    
    func addTileViewAt(location: Location, withLabel label: String) {
        let tileView = TileView(frame: _frameFor(location))
        tileView.labelText = label
        tileViews[location] = tileView
        self.addSubview(tileView)
    }
    
    func removeTileAt(location: Location) {
        let tileView = tileViews[location]
        tileView!.removeFromSuperview()
        tileViews[location] = nil
    }
    
    func moveTileViewAt(fromLocation: Location, to toLocation: Location) {
        let tileView = tileViews[fromLocation]
        tileView!.frame = _frameFor(toLocation)
        tileViews[fromLocation] = nil
        tileViews[toLocation] = tileView
    }
    
    func setLabelTextForTileAt(location: Location, labelText: String) {
        tileViews[location]!.labelText = labelText
    }

    func _frameFor(location: Location) -> CGRect {
        let xMargin = CGFloat((location.x + 1) * margin)
        let yMargin = CGFloat((location.y + 1) * margin)
        let leadingXTileSpace = CGFloat(location.x) * tileViewSize.width
        let leadingYTileSpace = CGFloat(location.y) * tileViewSize.height
        
        let origin = CGPointMake(xMargin + leadingXTileSpace, yMargin + leadingYTileSpace)
        return CGRectMake(origin.x, origin.y, tileViewSize.width, tileViewSize.height)
    }
}

//
//  TileView.swift
//  2047
//
//  Created by Bruce Ricketts on 8/1/14.
//  Copyright (c) 2014 fireypotato. All rights reserved.
//

import UIKit
import QuartzCore

class TileView: UIView {
    var labelText: String {
        get {
            return _label.text
        }
        set(newText) {
            _label.text = newText
        }
    }
    let _label: UILabel
    var _gradientLayer: CAGradientLayer!
    
    required init(coder aDecoder: NSCoder!) {
        _label = UILabel() // WHYYYYYYY
        _gradientLayer = CAGradientLayer() // AAAAAAH
        super.init(coder: aDecoder) // THIS IS SO STUPID WHY IS THIS CRAP REQUIRED SMH
    }
    
    init(frame: CGRect, appearanceSource: TileAppearance) {
        _label = UILabel(frame: CGRectMake(0, 0, frame.width, frame.height))
        super.init(frame: frame)
        _label.font = UIFont(name: "HelveticaNeue-Thin", size: 28.0)
        _label.adjustsFontSizeToFitWidth = true
        _label.textAlignment = .Center
        
        self.backgroundColor = UIColor.orangeColor()
        self.addSubview(_label)
        
        configureWith(appearanceSource)
    }
    
    func configureWith(appearanceSource: TileAppearance) {
        _label.textColor = appearanceSource.labelColor()
        
        let topRGB = appearanceSource.topColorRGB()
        let bottomRGB = appearanceSource.bottomColorRGB()
        let topColor = UIColor(red: topRGB[0]/255.0, green: topRGB[1]/255.0, blue: topRGB[2]/255.0, alpha: 1.0)
        let bottomColor = UIColor(red: bottomRGB[0]/255.0, green: bottomRGB[1]/255.0, blue: bottomRGB[2]/255.0, alpha: 1.0)
        let colors: Array<AnyObject> = [topColor.CGColor, bottomColor.CGColor] // typed like this because of a bug in swift: http://stackoverflow.com/questions/24113354/swift-array-element-cannot-be-bridged-to-objective-c
        let locations: Array<AnyObject> = [CGFloat(0.0), CGFloat(1.0)]
        
        if _gradientLayer == nil {
            _gradientLayer = CAGradientLayer()
            _gradientLayer.frame = bounds
            layer.insertSublayer(_gradientLayer, atIndex: 0)
        }
        
        _gradientLayer.colors = colors
        _gradientLayer.locations = locations
    }
}

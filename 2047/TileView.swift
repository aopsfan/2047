//
//  TileView.swift
//  2047
//
//  Created by Bruce Ricketts on 8/1/14.
//  Copyright (c) 2014 fireypotato. All rights reserved.
//

import UIKit

class TileView: UIView {
    var labelText: String { // WHY IS THE INDENTATION LIKE THIS IT LOOKS AWEFUL
    get {
        return _label.text
    }
    set(newText) {
        _label.text = newText
    }
    }
    let _label: UILabel
    
    init(frame: CGRect) {
        _label = UILabel(frame: CGRectMake(0, 0, frame.width, frame.height))
        _label.textColor = UIColor.blackColor()
        _label.font = UIFont.systemFontOfSize(34)
        _label.adjustsFontSizeToFitWidth = true
        _label.textAlignment = .Center
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.orangeColor()
        self.addSubview(_label)
    }
}

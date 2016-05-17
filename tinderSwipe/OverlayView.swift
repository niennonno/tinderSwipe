//
//  OverlayView.swift
//  tinderSwipe
//
//  Created by Aditya Vikram Godawat on 16/05/16.
//  Copyright © 2016 Wow Labz. All rights reserved.
//

import UIKit


enum GGOverlayViewMode {
    case GGOverlayViewModeLeft
    case GGOverlayViewModeRight
}

class OverlayView: UIView{
    var _mode: GGOverlayViewMode! = GGOverlayViewMode.GGOverlayViewModeLeft
    var imageView: UIView!
    var text: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.whiteColor()
        imageView = UIView(frame: self.frame)
        text = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 25))
        text.center = self.center
        text.textAlignment = .Center
        text.backgroundColor = .whiteColor()
        self.addSubview(imageView)
        imageView.addSubview(text)
    }
    
    func setMode(mode: GGOverlayViewMode) -> Void {
        if _mode == mode {
            return
        }
        _mode = mode
        
        if _mode == GGOverlayViewMode.GGOverlayViewModeLeft {
            imageView.backgroundColor = UIColor.greenColor()
            text.text = "YO!"
        } else {
            imageView.backgroundColor = UIColor.redColor()
            text.text = "NO!"
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
  //      imageView.frame = CGRectMake(50, 50, 100, 100)
    }
}
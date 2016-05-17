//
//  DraggableView.swift
//  tinderSwipe
//
//  Created by Aditya Vikram Godawat on 16/05/16.
//  Copyright © 2016 Wow Labz. All rights reserved.
//

import UIKit

let ACTION_MARGIN: Float = 120      //%%% distance from center where the action applies. Higher = swipe further in order for the action to be called
let SCALE_STRENGTH: Float = 4       //%%% how quickly the card shrinks. Higher = slower shrinking
let SCALE_MAX:Float = 0.93          //%%% upper bar for how much the card shrinks. Higher = shrinks less
let ROTATION_MAX: Float = 1         //%%% the maximum rotation allowed in radians.  Higher = card can keep rotating longer
let ROTATION_STRENGTH: Float = 320  //%%% strength of rotation. Higher = weaker rotation
let ROTATION_ANGLE: Float = 3.14/8  //%%% Higher = stronger rotation angle

protocol DraggableViewDelegate {
    func cardSwipedLeft(card: UIView) -> Void
    func cardSwipedRight(card: UIView) -> Void
}

class DraggableView: UIView {
    var delegate: DraggableViewDelegate!
    var panGestureRecognizer: UIPanGestureRecognizer!
    var originPoint: CGPoint!
    var overlayView: OverlayView!
    var information: UILabel!
    var xFromCenter: Float!
    var yFromCenter: Float!
    var questionImage: UIImageView!
    var askedByImageView: UIImageView!
    var myImageView: UIImageView!
    var askedByNameLabel: UILabel!
    var questionTextLabel: UILabel!
    var isMine = Bool()
    var aPadding = CGFloat(10.0)
    var yesNoImageView: UIImageView!

    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupView()
        
        questionImage = UIImageView(frame: CGRectMake(aPadding, aPadding, self.frame.size.width - aPadding * 2, self.frame.size.width - aPadding * 2))
        
        self.addSubview(questionImage)
        questionImage.image = UIImage(named: "image1")
        questionImage.layer.cornerRadius = 5
        questionImage.layer.masksToBounds = true
        
        let aView = UIView(frame: questionImage.bounds)
        aView.backgroundColor = UIColor.blackColor()
        aView.alpha = 0.3
        aView.layer.cornerRadius = 5
        aView.layer.masksToBounds = true
        
        questionImage.addSubview(aView)
        
        askedByImageView = UIImageView(frame: CGRect(x: aPadding, y: aPadding * 2, width: 50, height: 50))
        askedByImageView.layer.cornerRadius = askedByImageView.frame.size.width/2
        askedByImageView.layer.borderColor = UIColor.whiteColor().CGColor
        askedByImageView.layer.borderWidth = 2
        askedByImageView.layer.masksToBounds = true
        askedByImageView.image = UIImage(named: "groot")
        //print("abcd")
        questionImage.addSubview(askedByImageView)
        
        myImageView = UIImageView(frame: CGRect(x: frame.size.width - aPadding * 3 - 50, y: aPadding * 2, width: 50, height: 50))
        myImageView.layer.cornerRadius = myImageView.frame.size.width/2
        myImageView.layer.borderColor = UIColor.whiteColor().CGColor
        myImageView.layer.borderWidth = 2
        myImageView.layer.masksToBounds = true
        questionImage.addSubview(myImageView)
        myImageView.hidden = true
        
        yesNoImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        myImageView.addSubview(yesNoImageView)
        
        askedByNameLabel = UILabel(frame: CGRect(x: CGRectGetMaxX(askedByImageView.frame) + aPadding, y: aPadding, width: CGRectGetMinX(myImageView.frame) - 75, height: CGRectGetMaxY(myImageView.frame)))
        askedByNameLabel.numberOfLines = 2
        askedByNameLabel.textColor = UIColor.whiteColor()
        questionImage.addSubview(askedByNameLabel)
        
        questionTextLabel = UILabel(frame: CGRect(x: aPadding, y: CGRectGetMaxY(myImageView.bounds) + 25, width: questionImage.frame.size.width - aPadding * 2, height: questionImage.frame.size.height - 80))
        questionTextLabel.textColor = .whiteColor()
        questionTextLabel.numberOfLines = 0
        questionTextLabel.textAlignment = .Center
        questionTextLabel.text = "text"
        questionImage.addSubview(questionTextLabel)
        
        self.backgroundColor = UIColor.whiteColor()
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "beingDragged:")
        self.addGestureRecognizer(panGestureRecognizer)
        
        overlayView = OverlayView(frame: self.bounds)
        overlayView.alpha = 0
        self.addSubview(overlayView)
        
        xFromCenter = 0
        yFromCenter = 0

    }
    
    func setupView() -> Void {
        self.frame = CGRect(x: 20, y: 20, width: UIScreen.mainScreen().bounds.width-40, height: UIScreen.mainScreen().bounds.width-40)
        self.layer.cornerRadius = 4;
        self.layer.shadowRadius = 3;
        self.layer.shadowOpacity = 0.2;
        self.layer.shadowOffset = CGSizeMake(1, 1);
    }
    
    func beingDragged(gestureRecognizer: UIPanGestureRecognizer) -> Void {
        xFromCenter = Float(gestureRecognizer.translationInView(self).x)
        yFromCenter = Float(gestureRecognizer.translationInView(self).y)
        
        switch gestureRecognizer.state {
        case UIGestureRecognizerState.Began:
            self.originPoint = self.center
        case UIGestureRecognizerState.Changed:
            let rotationStrength: Float = min(xFromCenter/ROTATION_STRENGTH, ROTATION_MAX)
            let rotationAngle = ROTATION_ANGLE * rotationStrength
            let scale = max(1 - fabsf(rotationStrength) / SCALE_STRENGTH, SCALE_MAX)
            
            self.center = CGPointMake(self.originPoint.x + CGFloat(xFromCenter), self.originPoint.y + CGFloat(yFromCenter))
            
            let transform = CGAffineTransformMakeRotation(CGFloat(rotationAngle))
            let scaleTransform = CGAffineTransformScale(transform, CGFloat(scale), CGFloat(scale))
            self.transform = scaleTransform
            self.updateOverlay(CGFloat(xFromCenter))
        case UIGestureRecognizerState.Ended:
            self.afterSwipeAction()
        case UIGestureRecognizerState.Possible:
            fallthrough
        case UIGestureRecognizerState.Cancelled:
            fallthrough
        case UIGestureRecognizerState.Failed:
            fallthrough
        default:
            break
        }
    }
    
    func updateOverlay(distance: CGFloat) -> Void {
        if distance > 0 {
            overlayView.setMode(GGOverlayViewMode.GGOverlayViewModeRight)
        } else {
            overlayView.setMode(GGOverlayViewMode.GGOverlayViewModeLeft)
        }
        overlayView.alpha = CGFloat(min(fabsf(Float(distance))/100, 1))
    }
    
    func afterSwipeAction() -> Void {
        let floatXFromCenter = Float(xFromCenter)
        if floatXFromCenter > ACTION_MARGIN {
            self.rightAction()
        } else if floatXFromCenter < -ACTION_MARGIN {
            self.leftAction()
        } else {
            UIView.animateWithDuration(0.3, animations: {() -> Void in
                self.center = self.originPoint
                self.transform = CGAffineTransformMakeRotation(0)
                self.overlayView.alpha = 0
            })
        }
    }
    
    func rightAction() -> Void {
        let finishPoint: CGPoint = CGPointMake(500, 2 * CGFloat(yFromCenter) + self.originPoint.y)
        UIView.animateWithDuration(0.3,
            animations: {
                self.center = finishPoint
            }, completion: {
                (value: Bool) in
                self.removeFromSuperview()
        })
        delegate.cardSwipedRight(self)
    }
    
    func leftAction() -> Void {
        let finishPoint: CGPoint = CGPointMake(-500, 2 * CGFloat(yFromCenter) + self.originPoint.y)
        UIView.animateWithDuration(0.3,
            animations: {
                self.center = finishPoint
            }, completion: {
                (value: Bool) in
                self.removeFromSuperview()
        })
        delegate.cardSwipedLeft(self)
    }
    
    func rightClickAction() -> Void {
        let finishPoint = CGPointMake(600, self.center.y)
        UIView.animateWithDuration(0.3,
            animations: {
                self.center = finishPoint
                self.transform = CGAffineTransformMakeRotation(1)
            }, completion: {
                (value: Bool) in
                self.removeFromSuperview()
        })
        delegate.cardSwipedRight(self)
    }
    
    func leftClickAction() -> Void {
        let finishPoint: CGPoint = CGPointMake(-600, self.center.y)
        UIView.animateWithDuration(0.3,
            animations: {
                self.center = finishPoint
                self.transform = CGAffineTransformMakeRotation(1)
            }, completion: {
                (value: Bool) in
                self.removeFromSuperview()
        })
        delegate.cardSwipedLeft(self)
    }
}
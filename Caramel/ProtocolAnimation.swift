//
//  ProtocolAnimation.swift
//  Caramel
//
//  Created by James Sun on 2014-11-09.
//  Copyright (c) 2014 Beyond. All rights reserved.
//

import UIKit

class ProtocolAnimation {
    
    class func animate (index: Int, buttons: [UIButton], images: [UIImageView], maskView: UIView, color: UIColor, isFinal: Bool) -> Int {
        //performs animations
        //returns updated index
        if isFinal {
            ProtocolAnimation.popupFinal(buttons, images: images, maskView: maskView)
            return index
        } else {
            ProtocolAnimation.normalCheckmark(index, buttons: buttons, images: images, color: color)
            return index + 1
        }
    }
    
    private class func normalCheckmark(index: Int, buttons: [UIButton], images: [UIImageView], color: UIColor) {
        images[index].hidden = false
        buttons[index].backgroundColor = UIColor.whiteColor()
        buttons[index].setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        buttons[index + 1].backgroundColor = color
        buttons[index + 1].setTitleColor(UIColor.whiteColor(),forState: UIControlState.Normal)
    }
    
    private class func popupFinal(buttons: [UIButton], images: [UIImageView], maskView: UIView) {
        images.last!.hidden = false
        buttons.last!.backgroundColor = UIColor.whiteColor()
        buttons.last!.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        maskView.hidden = false
        spring(0.7){
            maskView.transform = CGAffineTransformMakeTranslation(0, 0)
        }
    }
}
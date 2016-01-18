//
//  Extension.swift
//  TestPageViewController
//
//  Created by testdev on 16/1/15.
//  Copyright © 2016年 testdev. All rights reserved.
//

import UIKit

extension UIScrollView {

    public override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        self.nextResponder()?.touchesBegan(touches, withEvent: event)
        super.touchesBegan(touches, withEvent: event)
        
    }
    
    public override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        self.nextResponder()?.touchesMoved(touches, withEvent: event)
        super.touchesMoved(touches, withEvent: event)
        
    }
    
    public override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        
        self.nextResponder()?.touchesCancelled(touches, withEvent: event)
        super.touchesCancelled(touches, withEvent: event)
        
    }
    
    public override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        self.nextResponder()?.touchesEnded(touches, withEvent: event)
//        super.touchesEnded(touches, withEvent: event)
        
    }
    
}

extension UIImageView {
    
    public override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        self.nextResponder()?.touchesBegan(touches, withEvent: event)
        super.touchesBegan(touches, withEvent: event)
        
    }
    
    public override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        self.nextResponder()?.touchesMoved(touches, withEvent: event)
        super.touchesMoved(touches, withEvent: event)
        
    }
    
    public override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        
        self.nextResponder()?.touchesCancelled(touches, withEvent: event)
        super.touchesCancelled(touches, withEvent: event)
        
    }
    
    public override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        self.nextResponder()?.touchesEnded(touches, withEvent: event)
//        super.touchesEnded(touches, withEvent: event)
        
    }
    
}



//
//  GamePauseDailog.swift
//  Switris
//
//  Created by long nguyen on 12/19/16.
//  Copyright © 2016 Mathieu Vandeginste. All rights reserved.
//

import UIKit

class GamePauseDailog: UIView {

      @IBOutlet weak var imgBgDailog: UIImageView!
    
    func showDialog(){
               
        self.imgBgDailog.image?.resizableImageWithCapInsets(UIEdgeInsets.init(top: 15, left: 15, bottom: 15, right: 15), resizingMode: UIImageResizingMode.Stretch)
        
        self.hidden = false
        self.alpha = 0
        UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.alpha = 1
            
            }, completion: nil)
        
    }
    
    func dismisDialog(){
        
        UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.alpha = 0
        }) { (result) in
            self.hidden = true
        }
    }
    


}

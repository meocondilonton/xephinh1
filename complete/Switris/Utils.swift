//
//  Utils.swift
//  Switris
//
//  Created by long on 12/20/16.
//  Copyright © 2016 Mathieu Vandeginste. All rights reserved.
//

import UIKit

class Utils: NSObject {
    
   class func setMusic(){
        let prefs = NSUserDefaults.standardUserDefaults()
        let isMusicOn = prefs.boolForKey("music") ?? true
        prefs.setValue(!isMusicOn, forKey: "music")
        prefs.synchronize()
    }
    
   class func isMusicOn() -> Bool {
        let prefs = NSUserDefaults.standardUserDefaults()
        let isMusicOn = prefs.boolForKey("music") ?? true
        return isMusicOn
    }

}

//
//  GameOverDailog.swift
//  Switris
//
//  Created by long on 12/13/16.
//  Copyright © 2016 Mathieu Vandeginste. All rights reserved.
//

import UIKit

class GameOverDailog: UIView {
    

    @IBOutlet weak var imgBgDailog: UIImageView!
    @IBOutlet weak var lblHighSocre: UILabel!
    @IBOutlet weak var lblYourScore: UILabel!
    
    
    func showDialog(){
        self.imgBgDailog.image?.resizableImageWithCapInsets(UIEdgeInsets.init(top: 15, left: 15, bottom: 15, right: 15), resizingMode: UIImageResizingMode.Stretch)
        
    }
    
    
}

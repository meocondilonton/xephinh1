//
//  MenuViewController.swift
//  Switris
//
//  Created by long on 12/12/16.
//  Copyright © 2016 Mathieu Vandeginste. All rights reserved.
//

import UIKit
import AVFoundation

class MenuViewController: UIViewController {
    
 
    
    @IBOutlet weak var btnMusic: UIButton!
    var backgroundAudio = AVPlayer(URL:NSURL(fileURLWithPath:NSBundle.mainBundle().pathForResource("Sounds/background",ofType:"mp3")!))
    override func viewDidLoad() {
        super.viewDidLoad()
   NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MenuViewController.gotoForceground(_:)), name:"NotificationEnterForeground", object: nil)
        
    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MenuViewController.gotoBackground(_:)), name:"NotificationEnterBackground", object: nil)
      
    }

    func gotoForceground(notification: NSNotification){
        self.backgroundAudio.play()
    }
    
    func gotoBackground(notification: NSNotification){
          backgroundAudio.pause()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if Utils.isMusicOn() {
            self.btnMusic.selected = false
             backgroundAudio.play()
        }else{
            self.btnMusic.selected = true
            backgroundAudio.pause()
        }
    }
   
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        backgroundAudio.pause()
    }
    
    @IBAction func btnPlayTouch(sender: AnyObject) {
          backgroundAudio.pause()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("GameViewController") as! GameViewController
         vc.modalPresentationStyle =  .Custom
        vc.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
        self.presentViewController(vc, animated: true) { 
            
        }
        vc.block = {[weak self] () -> ()  in
            
            if Utils.isMusicOn() == true {
                self?.btnMusic.selected = false
                self?.backgroundAudio.play()
            }else{
                self?.btnMusic.selected = true
                self?.backgroundAudio.pause()
            }
        }
       
        
    }
    
    @IBAction func btnRateTouch(sender: AnyObject) {
        if let checkURL = NSURL(string: "http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=\(appId)&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8") {
            if UIApplication.sharedApplication().openURL(checkURL) {
                print("url successfully opened")
            }
        } else {
            print("invalid url")
        }
    }
    
    @IBAction func btnMusicTouch(sender: AnyObject) {
        Utils.setMusic()
        if Utils.isMusicOn() {
            self.btnMusic.selected = false
            backgroundAudio.play()
        }else{
            self.btnMusic.selected = true
            backgroundAudio.pause()
        }
    }
    
    

}

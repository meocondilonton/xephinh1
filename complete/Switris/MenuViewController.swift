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
         backgroundAudio.play()
        if self.isMusicOn() {
            self.btnMusic.selected = false
        }else{
            self.btnMusic.selected = true
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
            self?.backgroundAudio.play()
            if self?.isMusicOn() == true {
                self?.btnMusic.selected = false
            }else{
                self?.btnMusic.selected = true
            }
        }
       
        
    }
    
    @IBAction func btnRateTouch(sender: AnyObject) {
    }
    @IBAction func btnMusicTouch(sender: AnyObject) {
    }
    func setMusic(){
        let prefs = NSUserDefaults.standardUserDefaults()
        let isMusicOn = prefs.boolForKey("music")
        prefs.setValue(!isMusicOn, forKey: "music")
        prefs.synchronize()
    }
    
    func isMusicOn() -> Bool {
        let prefs = NSUserDefaults.standardUserDefaults()
        let isMusicOn = prefs.boolForKey("music")
        return isMusicOn
    }

}

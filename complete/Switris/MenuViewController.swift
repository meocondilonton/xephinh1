//
//  MenuViewController.swift
//  Switris
//
//  Created by long on 12/12/16.
//  Copyright © 2016 Mathieu Vandeginste. All rights reserved.
//

import UIKit
import AVFoundation
import FBAudienceNetwork

class MenuViewController: UIViewController ,FBInterstitialAdDelegate {
    var backgroundAudio = AVPlayer(URL:NSURL(fileURLWithPath:NSBundle.mainBundle().pathForResource("Sounds/background",ofType:"mp3")!))
     var interstitialAd:FBInterstitialAd!
    
    override func viewDidLoad() {
        super.viewDidLoad()
   NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MenuViewController.gotoForceground(_:)), name:"NotificationEnterForeground", object: nil)
        
    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MenuViewController.gotoBackground(_:)), name:"NotificationEnterBackground", object: nil)
      
        interstitialAd = FBInterstitialAd(placementID: "219892538457986_219904085123498")
        interstitialAd.delegate = self
        interstitialAd.loadAd()
        
    }

    func interstitialAdDidLoad(interstitialAd: FBInterstitialAd) {
        
    }
    
    func interstitialAdDidClose(interstitialAd: FBInterstitialAd) {
        interstitialAd.loadAd()
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
            self?.interstitialAd.showAdFromRootViewController(self)
        }
       
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

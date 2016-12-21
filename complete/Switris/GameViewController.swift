//
//  GameViewController.swift
//  Switris
//
//  Created by Mathieu Vandeginste on 10/05/2016.
//  Copyright (c) 2016 Mathieu Vandeginste. All rights reserved.
//

import UIKit
import SpriteKit
import FBAudienceNetwork

class GameViewController: UIViewController, SwiftrisDelegate, UIGestureRecognizerDelegate ,FBInterstitialAdDelegate ,FBAdViewDelegate{
    
    
   
    @IBOutlet weak var contraitBottomGBtn: NSLayoutConstraint!
    
    @IBOutlet weak var contraitHudScore: NSLayoutConstraint!
    
    @IBOutlet weak var banner1: UIView!
   
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var highLabel: UILabel!
    
    @IBOutlet weak var vGamePause: GamePauseDailog!
    @IBOutlet weak var vGameOver: GameOverDailog!
    
    @IBOutlet weak var btnMusic: UIButton!
    var interstitialAd:FBInterstitialAd!
    
    var scene: GameScene!
    var swiftris:Swiftris!
    var panPointReference:CGPoint?
    var enableTouch:Bool = false
    var block:(()->())?
    var isDropdowning:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Configure the view.
        if ScreenSize.IS_IPHONE_4_OR_LESS {
            contraitBottomGBtn.constant = -15
            contraitHudScore.constant = 100
        }
        let skView = view as! SKView
        skView.multipleTouchEnabled = false
        
        // Create and configure the scene.
        scene = GameScene(size: skView.bounds.size)
        scene.scaleMode = .AspectFill
        
        scene.tick = didTick
        
        swiftris = Swiftris()
        swiftris.delegate = self
        swiftris.beginGame()
        scene.playSound("Sounds/new_game.mp3")
        scene.playBgSound()
        // Present the scene.
        skView.presentScene(scene)
        
        interstitialAd = FBInterstitialAd(placementID: "219892538457986_219893525124554")
        interstitialAd.delegate = self
        interstitialAd.loadAd()
        
        
        let adView = FBAdView(placementID: "219892538457986_221355851644988", adSize: kFBAdSizeHeight50Banner, rootViewController: self)
       
        adView.frame = banner1.bounds
        adView.delegate = self
        adView.loadAd()
        
        banner1.addSubview(adView)
        if Utils.isMusicOn() {
            self.btnMusic.selected = false
        }else{
            self.btnMusic.selected = true
        }
        

    }
    
    func interstitialAdDidLoad(interstitialAd: FBInterstitialAd) {
      
    }
    
    func interstitialAdDidClose(interstitialAd: FBInterstitialAd) {
          interstitialAd.loadAd()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func didTick() {
        swiftris.letShapeFall()
    }
    
    @IBAction func didPan(sender: UIPanGestureRecognizer) {
        if enableTouch{
        let currentPoint = sender.translationInView(self.view)
        if let originalPoint = panPointReference {
            // #3
            if abs(currentPoint.x - originalPoint.x) > (BlockSize * 0.9) {
                // #4
                if sender.velocityInView(self.view).x > CGFloat(0) {
                    swiftris.moveShapeRight()
                    panPointReference = currentPoint
                } else {
                    swiftris.moveShapeLeft()
                    panPointReference = currentPoint
                }
            }
        } else if sender.state == .Began {
            panPointReference = currentPoint
        }
        }
    }
    
    @IBAction func didTap(sender: UITapGestureRecognizer) {
          if enableTouch{
            swiftris.rotateShape()
        }
    }
    
    @IBAction func didSwipe(sender: UISwipeGestureRecognizer) {
          if enableTouch{
            swiftris.dropShape()
        }
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    // #6
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailByGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer is UISwipeGestureRecognizer {
            if otherGestureRecognizer is UIPanGestureRecognizer {
                return true
            }
        } else if gestureRecognizer is UIPanGestureRecognizer {
            if otherGestureRecognizer is UITapGestureRecognizer {
                return true
            }
        }
        return false
    }
    
    func nextShape() {
        let newShapes = swiftris.newShape()
        guard let fallingShape = newShapes.fallingShape else {
            return
        }
        self.scene.addPreviewShapeToScene(newShapes.nextShape!) {}
        self.scene.movePreviewShape(fallingShape) {
            // #16
            self.view.userInteractionEnabled = true
            self.scene.startTicking()
        }
    }
    
    func gameDidBegin(swiftris: Swiftris) {
        let prefs = NSUserDefaults.standardUserDefaults()
        let highScore = prefs.integerForKey("highScore") ?? 0
        
        highLabel.text = "\(highScore)"
        levelLabel.text = "\(swiftris.level)"
        scoreLabel.text = "\(swiftris.score)"
        scene.tickLengthMillis = TickLengthLevelOne
        // The following is false when restarting a new game
        if swiftris.nextShape != nil && swiftris.nextShape!.blocks[0].sprite == nil {
            scene.addPreviewShapeToScene(swiftris.nextShape!) {
                self.nextShape()
            }
        } else {
            nextShape()
        }
    }
    
    func gameDidEnd(swiftris: Swiftris) {
//        view.userInteractionEnabled = false
         
        scene.stopTicking()
        self.scene.stopBgSound()
        scene.playSound("Sounds/gameover.mp3")
        scene.animateCollapsingLines(swiftris.removeAllBlocks(), fallenBlocks: swiftris.removeAllBlocks()) {[weak self] in
            
            let prefs = NSUserDefaults.standardUserDefaults()
            var highScore = prefs.integerForKey("highScore") ?? 0
            let score = self?.swiftris.score ?? 0
          
            self?.vGameOver.showDialog(highScore, score: score)
            if highScore < score {
                highScore = score
                prefs.setValue(highScore, forKey: "highScore")
                prefs.synchronize()
            }
            if self?.interstitialAd.adValid == true {
              self?.interstitialAd.showAdFromRootViewController(self)
            }
            
        }
    }
    
    func gameDidLevelUp(swiftris: Swiftris) {
        levelLabel.text = "\(swiftris.level)"
        if scene.tickLengthMillis >= 100 {
            scene.tickLengthMillis -= 100
        } else if scene.tickLengthMillis > 50 {
            scene.tickLengthMillis -= 50
        }
        scene.playSound("Sounds/levelup.mp3")
    }
    
    func gameShapeDidDrop(swiftris: Swiftris) {
        scene.stopTicking()
        scene.redrawShape(swiftris.fallingShape!) {
            swiftris.letShapeFall()
        }
        scene.playSound("Sounds/drop.mp3")
    }
    
    func gameShapeDidLand(swiftris: Swiftris) {
        scene.stopTicking()
//        self.view.userInteractionEnabled = false
        // #10
        let removedLines = swiftris.removeCompletedLines()
        if removedLines.linesRemoved.count > 0 {
            self.scoreLabel.text = "\(swiftris.score)"
            scene.animateCollapsingLines(removedLines.linesRemoved, fallenBlocks:removedLines.fallenBlocks) {
                // #11
                self.gameShapeDidLand(swiftris)
            }
            scene.playSound("Sounds/bomb.mp3")
        } else {
            nextShape()
        }
    }
    
    // #17
    func gameShapeDidMove(swiftris: Swiftris) {
        scene.redrawShape(swiftris.fallingShape!) {}
    }
    
    @IBAction func btnLeftTouch(sender: AnyObject) {
          swiftris.moveShapeLeft()
    }
    
    @IBAction func btnRightTouch(sender: AnyObject) {
          swiftris.moveShapeRight()
    }
    
    @IBAction func btnDownTouch(sender: AnyObject) {
        if (!isDropdowning){
            isDropdowning = true
               swiftris.dropShape()
            let dispatchTime: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(0.2 * Double(NSEC_PER_SEC)))
            dispatch_after(dispatchTime, dispatch_get_main_queue(), {
                self.dropDown()
            })
        }
     
    }
    
    func dropDown(){
        isDropdowning = false
    }
    
    @IBAction func btnRotateTouch(sender: AnyObject) {
          swiftris.rotateShape()
    }
    
    @IBAction func btnPauseTouch(sender: AnyObject) {
            scene.pauseGame()
            self.vGamePause.showDialog()
    }
    
    @IBAction func btnMenuTouch(sender: AnyObject) {
         self.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
         self.dismissViewControllerAnimated(true, completion: nil)
        if (block != nil) {
            block!()
        }
    }
   
    @IBAction func btnNewGameTouch(sender: AnyObject) {
         self.vGameOver.dismisDialog()
        
          scene.playSound("Sounds/new_game.mp3")
          swiftris.beginGame()
          scene.playBgSound()
    }
    
    //gamepause
    
     func gameForceNewGame(swiftris: Swiftris) {
   
        scene.stopTicking()
        self.scene.stopBgSound()
   
        for (columnIdx, column) in swiftris.removeAllBlocks().enumerate() {
            for (blockIdx, block) in column.enumerate() {
               
                let sprite = block.sprite!
                sprite.removeFromParent()
            }
        }
        if let blocks = swiftris.fallingShape?.blocks {
        for bl  in blocks {
              bl.sprite!.removeFromParent()
        }
        }
        
            self.scene.playSound("Sounds/new_game.mp3")
            self.swiftris.beginGame()
        if Utils.isMusicOn() {
            self.btnMusic.selected = false
            self.scene.playBgSound()
        }else{
            self.btnMusic.selected = true
            scene.backgroundAudio.pause()
            
        }
        
       
    }
 
    @IBAction func newGameTouch(sender: AnyObject) {
        self.vGamePause.dismisDialog()
             scene.resumeGame()
        self.swiftris.forceNewGame()
      
    }
    
    @IBAction func continueTouch(sender: AnyObject) {
        scene.resumeGame()
        self.vGamePause.dismisDialog()
    }
    
    @IBAction func menuTouch(sender: AnyObject) {
          scene.backgroundAudio.pause()
        self.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
        self.dismissViewControllerAnimated(true, completion: nil)
        if (block != nil) {
            block!()
        }

    }
    
    @IBAction func musicTouch(sender: AnyObject) {
       Utils.setMusic()
        if Utils.isMusicOn() {
            self.btnMusic.selected = false
             scene.backgroundAudio.play()
        }else{
             self.btnMusic.selected = true
             scene.backgroundAudio.pause()
            
        }
          scene.resumeGame()
        self.vGamePause.dismisDialog()
      
    }
    
  
    
}

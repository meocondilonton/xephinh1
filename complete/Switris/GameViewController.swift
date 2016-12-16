//
//  GameViewController.swift
//  Switris
//
//  Created by Mathieu Vandeginste on 10/05/2016.
//  Copyright (c) 2016 Mathieu Vandeginste. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController, SwiftrisDelegate, UIGestureRecognizerDelegate {
    
    
   
    @IBOutlet weak var contraitBottomGBtn: NSLayoutConstraint!
    
    @IBOutlet weak var contraitHudScore: NSLayoutConstraint!
    
   
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var highLabel: UILabel!
    
    @IBOutlet weak var vGameOver: GameOverDailog!
    
    var scene: GameScene!
    var swiftris:Swiftris!
    var panPointReference:CGPoint?
    var enableTouch:Bool = false

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
        
        // Present the scene.
        skView.presentScene(scene)
        

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
        swiftris.dropShape()
    }
    
    @IBAction func btnRotateTouch(sender: AnyObject) {
          swiftris.rotateShape()
    }
    @IBAction func btnPauseTouch(sender: AnyObject) {
        let prefs = NSUserDefaults.standardUserDefaults()
        let highScore = prefs.integerForKey("highScore") ?? 0

        self.vGameOver.showDialog(highScore, score: swiftris.score)
    }
    
    @IBAction func btnMenuTouch(sender: AnyObject) {
         self.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
         self.dismissViewControllerAnimated(true, completion: nil)
    }
   
    @IBAction func btnNewGameTouch(sender: AnyObject) {
         self.vGameOver.dismisDialog()
      
          swiftris.beginGame()
    }
    
    
}

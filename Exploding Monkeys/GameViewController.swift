//
//  GameViewController.swift
//  Exploding Monkeys
//
//  Created by Yohannes Wijaya on 10/20/15.
//  Copyright (c) 2015 Yohannes Wijaya. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    
    // MARK: - Stored Properties
    
    var currentGame: GameScene!
    
    // MARK: - IBOutlet Properties
    
    @IBOutlet weak var angleSlider: UISlider!
    @IBOutlet weak var angleLabel: UILabel!
    @IBOutlet weak var velocitySlider: UISlider!
    @IBOutlet weak var velocityLabel: UILabel!
    @IBOutlet weak var launchButton: UIButton!
    @IBOutlet weak var playerNumber: UILabel!
    
    // MARK: - IBAction Properties
    
    @IBAction func changeAngleActionSlider(sender: UISlider) {
        self.angleLabel.text = "Angle: \(Int(self.angleSlider.value))°"
    }
    
    @IBAction func changeVelocityActionSlider(sender: UISlider) {
        self.velocityLabel.text = "Velocity: \(Int(self.velocitySlider.value))"
    }
    
    @IBAction func launchProjectileActionButton(sender: UIButton) {
        self.angleSlider.hidden = true
        self.angleLabel.hidden = true
        
        
        self.velocitySlider.hidden = true
        self.velocityLabel.hidden = true
        
        self.launchButton.hidden = true
        
        self.currentGame.launchProjectile(angle: Int(self.angleSlider.value), velocity: Int(velocitySlider.value))
    }
    
    // MARK: - Local Methods
    
    func activatePlayerNumber(number: Int) {
        self.playerNumber.text = number == 1 ? "<<< PLAYER ONE" : "PLAYER TWO >>>"
        
        self.angleSlider.hidden = false
        self.angleLabel.hidden = false
        
        self.velocitySlider.hidden = false
        self.velocityLabel.hidden = false
        
        self.launchButton.hidden = false
    }
    
    // MARK: - Methods Override

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.changeAngleActionSlider(self.angleSlider)
        self.changeVelocityActionSlider(self.velocitySlider)

        if let scene = GameScene(fileNamed:"GameScene") {
            // Configure the view.
            let skView = self.view as! SKView
            skView.showsFPS = true
            skView.showsNodeCount = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            
            skView.presentScene(scene)
            
            self.currentGame = scene
            scene.viewController = self
        }
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}

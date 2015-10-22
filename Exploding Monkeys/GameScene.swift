//
//  GameScene.swift
//  Exploding Monkeys
//
//  Created by Yohannes Wijaya on 10/20/15.
//  Copyright (c) 2015 Yohannes Wijaya. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    // MARK: - Enum
    
    enum CollisionTypes: UInt32 {
        case Banana = 1, Building = 2, Player = 4
    }
    
    // MARK: - Stored Properties
    
    var buildings = Array<BuildingNode>()
    weak var viewController: GameViewController!
    
    var player1: SKSpriteNode!
    var player2: SKSpriteNode!
    var banana: SKSpriteNode!
    
    var currentPlayer = 1
    
    // MARK: - Methods Override
    
    override func didMoveToView(view: SKView) {
        self.backgroundColor = UIColor(hue: 0.669, saturation: 0.99, brightness: 0.67, alpha: 1)
        self.createBuildings()
        self.createPlayers()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
 
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    // MARK: - Local Methods
    
    func createBuildings() {
        var currentX: CGFloat = -15
        
        while currentX < 1024 {
            let size = CGSize(width: RandomInt(2, max: 4) * 40, height: RandomInt(300, max: 600))
            currentX += size.width + 2
            
            let building = BuildingNode(color: UIColor.redColor(), size: size)
            building.position = CGPoint(x: currentX - (size.width / 2), y: size.height / 2)
            building.setup()
            self.addChild(building)
            
            self.buildings.append(building)
        }
    }
    
    func createPlayers() {
        self.player1 = SKSpriteNode(imageNamed: "player")
        self.player1.name = "player1"
        self.player1.physicsBody = SKPhysicsBody(circleOfRadius: self.player1.size.width / 2)
        self.player1.physicsBody!.categoryBitMask = CollisionTypes.Player.rawValue
        self.player1.physicsBody!.collisionBitMask = CollisionTypes.Banana.rawValue
        self.player1.physicsBody!.contactTestBitMask = CollisionTypes.Banana.rawValue
        self.player1.physicsBody!.dynamic = false
        
        let firstIndex = self.buildings.startIndex.successor()
        print(firstIndex)
        let player1Building = self.buildings[firstIndex]
        // Position the player by adding the building's height to the player's height and dividing by 2, then adding that to the building's y-coordinate. SpriteKit measures from the center of nodes
        self.player1.position = CGPoint(x: player1Building.position.x, y: player1Building.position.y + ((player1Building.size.height + player1.size.height) / 2))
        self.addChild(self.player1)
        
        self.player2 = SKSpriteNode(imageNamed: "player")
        self.player2.physicsBody = SKPhysicsBody(circleOfRadius: self.player2.size.width / 2)
        self.player2.physicsBody!.categoryBitMask = CollisionTypes.Player.rawValue
        self.player2.physicsBody!.collisionBitMask = CollisionTypes.Banana.rawValue
        self.player2.physicsBody!.contactTestBitMask = CollisionTypes.Banana.rawValue
        self.player2.physicsBody!.dynamic = false
        
        let lastIndex = self.buildings.endIndex.predecessor().predecessor()
        print(lastIndex)
        let player2Building = self.buildings[lastIndex]
        self.player2.position = CGPoint(x: player2Building.position.x, y: player2Building.position.y + ((player2Building.size.height + player2.size.height) / 2))
    }
    
    func launchProjectile(angle angle: Int, velocity: Int) {
        // 1. Figure out how hard to throw the banana.
        let speed = Double(velocity) / 10
        
        // 2. Convert the input angle to radians.
        let radians = self.convertToRadiansFrom(degrees: angle)
        
        // 3. If a banana exists, remove it then create a new one using circle physics
        if self.banana != nil {
            self.banana.removeFromParent()
            self.banana = nil
        }
        
        self.banana = SKSpriteNode(imageNamed: "banana")
        self.banana.name = "banana"
        self.banana.physicsBody = SKPhysicsBody(circleOfRadius: self.banana.size.width / 2)
        self.banana.physicsBody!.categoryBitMask = CollisionTypes.Banana.rawValue
        self.banana.physicsBody!.collisionBitMask = CollisionTypes.Player.rawValue | CollisionTypes.Building.rawValue
        self.banana.physicsBody!.contactTestBitMask = CollisionTypes.Player.rawValue | CollisionTypes.Building.rawValue
        self.banana.physicsBody!.usesPreciseCollisionDetection = true
        self.addChild(self.banana)
        
        // 4. if player 1 is throwing the banana, position it up and to the left of the player and give it some spin. 
        if self.currentPlayer == 1 {
            self.banana.position = CGPoint(x: self.player1.position.x - 30, y: self.player1.position.y + 40)
            self.banana.physicsBody!.angularVelocity = -20
            
            // 5. Animate player 1 throwing their arm up then putting it down again.
            let raiseArm = SKAction.setTexture(SKTexture(imageNamed: "player1Throw"))
            let lowerArm = SKAction.setTexture(SKTexture(imageNamed: "player"))
            let pause = SKAction.waitForDuration(0.15)
            let sequence = SKAction.sequence([raiseArm, pause, lowerArm])
            self.player1.runAction(sequence)
            
            // 6. Make the banana move in the correct direction
            let impulse = CGVector(dx: cos(radians) * speed, dy: sin(radians) * speed)
            self.banana.physicsBody!.applyImpulse(impulse)
        }
        else {
            // 7. If player 2 is throwing the banana, we position it up and to the right, apply the opposite spin, then make it move in the correct direction.
            self.banana.position = CGPoint(x: self.player2.position.x + 30, y: self.player2.position.y + 40)
            self.banana.physicsBody!.angularVelocity = 20
            
            let raiseArm = SKAction.setTexture(SKTexture(imageNamed: "player2Throw"))
            let lowerArm = SKAction.setTexture(SKTexture(imageNamed: "player"))
            let pause = SKAction.waitForDuration(0.15)
            let sequence = SKAction.sequence([raiseArm, pause, lowerArm])
            self.player2.runAction(sequence)
            
            let impulse = CGVector(dx: cos(radians * -speed), dy: sin(radians) * speed)
            self.banana.physicsBody!.applyImpulse(impulse)
        }
    }
    
    func convertToRadiansFrom(degrees degrees: Int) -> Double {
        return Double(degrees) * M_PI / 180
    }
}

//
//  GameScene.swift
//  Exploding Monkeys
//
//  Created by Yohannes Wijaya on 10/20/15.
//  Copyright (c) 2015 Yohannes Wijaya. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    // MARK: - Stored Properties
    
    var buildings = Array<BuildingNode>()
    
    // MARK: - Methods Override
    
    override func didMoveToView(view: SKView) {
        self.backgroundColor = UIColor(hue: 0.669, saturation: 0.99, brightness: 0.67, alpha: 1)
        self.createBuildings()
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
}

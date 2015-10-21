//
//  BuildingNode.swift
//  Exploding Monkeys
//
//  Created by Yohannes Wijaya on 10/21/15.
//  Copyright © 2015 Yohannes Wijaya. All rights reserved.
//

import UIKit
import SpriteKit
import GameKit

class BuildingNode: SKSpriteNode {
    
    enum CollisionTypes: UInt32 {
        case Banana = 1, Building = 2, Player = 4
    }
    
    // MARK: - Stored Properties
    
    var currentImage: UIImage!
    
    // MARK: - Local Methods
    
    func setup() {
        self.name = "building"
        
        self.currentImage = self.draw(self.size)
        self.texture = SKTexture(image: self.currentImage)
        
        self.configurePhysics()
    }
    
    func configurePhysics() {
        self.physicsBody = SKPhysicsBody(texture: self.texture!, size: self.size)
        self.physicsBody!.dynamic = false
        self.physicsBody!.categoryBitMask = CollisionTypes.Building.rawValue
        self.physicsBody!.contactTestBitMask = CollisionTypes.Banana.rawValue
    }
    
    func draw(size: CGSize) -> UIImage {
        // 1. Create a new Core Graphics context the size of our building
        UIGraphicsBeginImageContextWithOptions(self.size, false, 0)
        let currentGraphicsContext = UIGraphicsGetCurrentContext()
        
        // 2. Fill it w/ a rectangle that's one of three colors
        let rectangle = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        
        var color: UIColor!
        switch GKRandomSource.sharedRandom().nextIntWithUpperBound(3) {
        case 0: color = UIColor(hue: 0.502, saturation: 0.98, brightness: 0.67, alpha: 1)
        case 1: color = UIColor(hue: 0.999, saturation: 0.99, brightness: 0.67, alpha: 1)
        default: color = UIColor(hue: 0, saturation: 0, brightness: 0.67, alpha: 1)
        }
        
        CGContextSetFillColorWithColor(currentGraphicsContext, color.CGColor)
        CGContextAddRect(currentGraphicsContext!, rectangle)
        CGContextDrawPath(currentGraphicsContext!, CGPathDrawingMode.Fill)
        
        // 3. Draw windows all over the building in 1 of 2 colors: either a light on (yellow) or off (gray)
        let lightOnColor = UIColor(hue: 0.190, saturation: 0.67, brightness: 0.99, alpha: 1)
        let lightOffColor = UIColor(hue: 0, saturation: 0, brightness: 0.34, alpha: 1)
        
        for var row: CGFloat = 10; row < self.size.height - 10; row += 40 {
            for var col: CGFloat = 10; col < self.size.width - 10; col += 40 {
                if RandomInt(0, max: 1) == 0 {
                    CGContextSetFillColorWithColor(currentGraphicsContext!, lightOnColor.CGColor)
                }
                else { CGContextSetFillColorWithColor(currentGraphicsContext, lightOffColor.CGColor) }
                CGContextFillRect(currentGraphicsContext, CGRect(x: col, y: row, width: 15, height: 20))
            }
        }
        
        // 4. Pull out the result as a UIImage and return it for use elsewhere
        let buildingImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return buildingImage
    }
    
}
